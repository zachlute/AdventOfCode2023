
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

day_08_02_device := class(creative_device):

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=

        var Steps : int := 0

        var Directions : string = ""
        if (set Directions = Input[0]) {}

        var Nodes : [string]node = map{}
        var StartingNodes : []node = array{}

        for (InputIdx := 2..Input.Length - 1, Item := Input[InputIdx]):
            if:
                Name := Item.Slice[0, 3]
                Left := Item.Slice[7, 10]
                Right := Item.Slice[12, 15]
            then:
                Node := node{Name := Name, Left := Left, Right := Right}
                if (set Nodes[Name] = Node) {}
                if (Name[Name.Length - 1] = 'A'):
                    Print("Found starting node {Name}")
                    set StartingNodes += array{Node}
                #Print("{Name} {Left} {Right}")

        var StepsForEachStartingNode : []int = array{}

        for (StartingNode : StartingNodes):
            var StepNumber : int := 1
            var CurrentNode : node := StartingNode
            loop:
                for (D : Directions):
                    case(D):
                        'L' => if (set CurrentNode = Nodes[CurrentNode.Left]) {}
                        'R' => if (set CurrentNode = Nodes[CurrentNode.Right]) {}
                        _ => break

                if (CurrentNode.Name[CurrentNode.Name.Length - 1] = 'Z'):
                    Print("Found end {CurrentNode.Name} for starting node {StartingNode.Name} after {StepNumber} steps!")
                    break

                set StepNumber += 1

                if (Mod[StepNumber, 1000] = 0):
                    Sleep(0.0)
            
            set StepsForEachStartingNode += array{StepNumber * Directions.Length}

        set Steps = 1
        for (StepCount : StepsForEachStartingNode):
            set Steps = Lcm(Steps, StepCount)

        Print("Day 8 - Part 2 - Steps: {Steps}")
        SetBillboardText(ToString(Steps))

    Lcm(A: int, B: int):int =
        if:
            FoundGcd := Gcd(A, B)
            Result := Floor(A * B / FoundGcd)
        then:
            #Print("Found GCD: {ToString(FoundGcd)} and LCM: {ToString(Result)} for {ToString(A)} and {ToString(B)}")
            return Result
    
        return 0

    Gcd(A: int, B: int)<transacts>:int =
        var CA : int := A
        var CB : int := B
        loop:
            if (CB <= 0):
                break

            TempA := CA
            set CA = CB
            if (set CB = Mod[TempA, CB]) {}

        return CA