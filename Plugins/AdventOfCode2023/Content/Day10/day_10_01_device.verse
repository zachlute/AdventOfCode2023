
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

day_10_01_device := class(creative_device):

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

        # Starting at the starting point, we follow the path until we get back to S
        # We need to figure out possible path directions by searching every point around S

        var CandidatePaths : [][]tuple(int,int,char) := 
            for (Step : GetValidNextSteps(-1, -1, S(0), S(1), S(2))):
                #Print("{ToPathNodeString(S)}: Found Next Step From Start {ToPathNodeString(Step)}")
                array{(S(0), S(1), 'S')} + array{Step}

        var ValidPath : []tuple(int,int,char) = array{}

        var LoopIdx : int = 0

        loop:
            var NextCandidatePaths : [][]tuple(int,int,char) = array{}

            for (Path : CandidatePaths, LastStep := Path[Path.Length - 1], PrevStep := Path[Path.Length - 2]):
                #if (Path.Length > 10):
                #    Print("Checking Path: {ToPathString(Path)}")
                NextSteps := GetValidNextSteps(PrevStep(0), PrevStep(1), LastStep(0), LastStep(1), LastStep(2))
                #if (Path.Length > 10):
                #    Print("Found {ToString(NextSteps.Length)} valid next steps.")
                for (NextStep : NextSteps):
                    #Print("{ToPathNodeString(LastStep)}: Found Next Step {ToPathNodeString(NextStep)}")
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

        Print("Found Valid Path of Length {ToString(ValidPath.Length - 1)}: {ToPathString(ValidPath)}")           

        NumStepsToFarthestPos := 
            if (Result := Floor[(ValidPath.Length - 1) * 1.0 / 2.0]):
                Result
            else:
                0

        Print("Day 10 - Part 1 - Num Steps: {NumStepsToFarthestPos}")
        SetBillboardText(ToString(NumStepsToFarthestPos))

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