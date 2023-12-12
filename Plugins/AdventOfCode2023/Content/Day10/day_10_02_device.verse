
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

day_10_02_device := class(creative_device):

    Input : []string := ActualInput

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=

        var S : tuple(int, int, char) = (-1, -1, 'S')

        if:
            Width := Input[0].Length
            Height := Input.Length
        then:
            for (X := 0..Width - 1):
                for (Y := 0..Height - 1):
                    if (Input[Y][X] = 'S'):
                        set S = (X, Y, 'S')
                        Print("Found starting point: {ToPathNodeString(S)}")

        ValidPath := GetValidPath(S)
        Print("Found valid path: {ToPathString(ValidPath)}")

        # TODO: This works, but times out. Need to figure out how to solve that problem.
        NumEnclosed := CountEnclosed(ValidPath)
        Print("Day 10 - Part 2 - Num Enclosed: {NumEnclosed}")
        SetBillboardText(ToString(NumEnclosed))

    CountEnclosed(Path : []tuple(int, int, char))<suspends>:int =
        var Count : int = 0

        var LoopIdx : int = 0

        if:
            Width := Input[0].Length
            Height := Input.Length
        then:
            # Skip the edges
            for (X := 1..Width - 2):
                for (Y := 1..Height - 2, Point := (X, Y, Input[Y][X])):
                    #Print("Checking: {ToPathNodeString(Point)}")
                    if (not Path.Find[Point]):
                        #Print("Not on path, raycasting")
                        set Count += RayCast(Point, Path)

                    set LoopIdx += 1
                    if (Mod[LoopIdx, 100] = 0):
                        Sleep(0.0)

        return Count

    RayCast(From: tuple(int, int, char), Path : []tuple(int, int, char)):int =
        var Count : int = 0
        for (X := 0..From(0)):
            if:
                Point := (X, From(1), Input[From(1)][X])
                Path.Find[Point]
                Point(2) = '|' or Point(2) = '7' or Point(2) = 'F'
            then:
                #Print("Found path point: {ToPathNodeString(Point)}")
                set Count += 1
        
        if (Mod[Count, 2] = 0):
            0
        else:
            1


    GetValidPath(S : tuple(int, int, char))<suspends>:[]tuple(int, int, char) = 
        var CandidatePaths : [][]tuple(int,int,char) := 
            for (Step : GetValidNextSteps(-1, -1, S(0), S(1), S(2))):
                array{(S(0), S(1), 'S')} + array{Step}

        var ValidPath : []tuple(int,int,char) = array{}

        var LoopIdx : int = 0

        loop:
            var NextCandidatePaths : [][]tuple(int,int,char) = array{}

            for (Path : CandidatePaths, LastStep := Path[Path.Length - 1], PrevStep := Path[Path.Length - 2]):
                NextSteps := GetValidNextSteps(PrevStep(0), PrevStep(1), LastStep(0), LastStep(1), LastStep(2))
                for (NextStep : NextSteps):
                    NewPath := Path + array{NextStep}
                    if (NextStep(2) = 'S'):
                        # We're back at the start and we can stop.
                        set ValidPath = NewPath
                        break
                    set NextCandidatePaths += array{NewPath}

                set LoopIdx += 1
                if (Mod[LoopIdx, 100] = 0):
                    Sleep(0.0)

            set CandidatePaths = NextCandidatePaths
            if (CandidatePaths.Length = 0):
                break

        return ValidPath      

    GetValidNextSteps(PrevX : int, PrevY : int, X : int, Y : int, C : char)<transacts>:[]tuple(int,int,char) =
        var NextSteps : []tuple(int, int, char) = array{}

        # Above
        if:
            CanGoUp[C]
            CheckX := X
            CheckY := Y - 1
            CheckX <> PrevX or CheckY <> PrevY
            Above := Input[CheckY][CheckX]
            CanGoDown[Above]
        then:
            set NextSteps += array{(CheckX, CheckY, Above)}

        # Below
        if:
            CanGoDown[C]
            CheckX := X
            CheckY := Y + 1
            CheckX <> PrevX or CheckY <> PrevY
            Below := Input[CheckY][CheckX]
            CanGoUp[Below]
        then:
            set NextSteps += array{(CheckX, CheckY, Below)}

        # Left
        if:
            CanGoLeft[C]
            CheckX := X - 1
            CheckY := Y
            CheckX <> PrevX or CheckY <> PrevY
            Left := Input[CheckY][CheckX]
            CanGoRight[Left]
        then:
            set NextSteps += array{(CheckX, CheckY, Left)}

        # Right
        if:
            CanGoRight[C]
            CheckX := X + 1
            CheckY := Y
            CheckX <> PrevX or CheckY <> PrevY
            Right := Input[CheckY][CheckX]
            CanGoLeft[Right]
        then:
            set NextSteps += array{(CheckX, CheckY, Right)}

        return NextSteps

    ToPathString(Path : []tuple(int, int, char)):string =
        var Output : string = ""
        for (Node : Path):
            set Output += ToPathNodeString(Node)
        return Output

    ToPathNodeString(X : int, Y: int, C : char):string =
        "({ToString(X)}, {ToString(Y)}, {ToString(C)})"

    CanGoUp(C : char)<decides><transacts>:void =
        C = '|' or C = 'J' or C = 'L' or C = 'S'

    CanGoDown(C : char)<decides><transacts>:void =
        C = '|' or C = '7' or C = 'F' or C = 'S'

    CanGoLeft(C : char)<decides><transacts>:void =
        C = '-' or C = 'J' or C = '7' or C = 'S'

    CanGoRight(C : char)<decides><transacts>:void =
        C = '-' or C = 'L' or C = 'F' or C = 'S'