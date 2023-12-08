
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

node := class():
    Name : string = ""
    Left : string = ""
    Right : string = ""

day_08_01_device := class(creative_device):

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=

        var Steps : int := 0

        var Directions : string = ""
        if (set Directions = Input[0]) {}

        var Nodes : [string]node = map{}

        for (LoopIdx := 2..Input.Length - 1, Item := Input[LoopIdx]):
            if:
                Name := Item.Slice[0, 3]
                Left := Item.Slice[7, 10]
                Right := Item.Slice[12, 15]
            then:
                if (set Nodes[Name] = node{Name := Name, Left := Left, Right := Right}) {}
                #Print("{Name} {Left} {Right}")

            if (Mod[LoopIdx, 100] = 0):
                Sleep(0.0)
        
        if (StartNode := Nodes["AAA"]):
            LoopIdx := 0
            var CurrentNode : node = StartNode
            loop:
                #Print(CurrentNode.Name)
                if (D := Directions[Mod[Steps, Directions.Length]]):
                    #Print(ToString(D))
                    case(D):
                        'L' => if (set CurrentNode = Nodes[CurrentNode.Left]) {}
                        'R' => if (set CurrentNode = Nodes[CurrentNode.Right]) {}
                        _ => break
                else:
                    break

                set Steps += 1

                if (CurrentNode.Name = "ZZZ"):
                    break

                if (Mod[LoopIdx, 100] = 0):
                    Sleep(0.0)

        Print("Day 8 - Part 1 - Steps: {Steps}")
        SetBillboardText(ToString(Steps))