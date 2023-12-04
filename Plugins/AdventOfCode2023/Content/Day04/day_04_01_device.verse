
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

day_04_01_device := class(creative_device):

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        var Sum : int = 0

        # Calculation is getting intense. Because this is <suspends>,
        # we can manually timeslice the loop so it doesn't time out.
        var LoopIdx : int := 0

        for (Item : Input):

            CardAndResults := Item.Split(": ");
            if:
                Card := CardAndResults[0]
                WinningAndHave := CardAndResults[1].Split(" | ")
                Winning := WinningAndHave[0].Split(" ")
                Have := WinningAndHave[1].Split(" ")
            then:

                WinningInts := 
                    for (W : Winning, WI := W.AsInt[]):
                        WI

                WinningIntsWeHave := 
                    for (H : Have, HI := H.AsInt[], WinningInts.Find[HI]):
                        HI
                
                var WinningValue : int := 0
                if (WinningIntsWeHave.Length > 0):
                    set WinningValue = 1

                for (Idx := 0..WinningIntsWeHave.Length - 2):
                    set WinningValue *= 2

                set Sum += WinningValue

            set LoopIdx += 1
            if (Mod[LoopIdx, 100] = 0):
                Sleep(0.0)
        
        Print("Day 4 - Part 1 - Sum: {Sum}")
        SetBillboardText(ToString(Sum))

    (S: string).AsInt()<decides><transacts>: int =
        var RetInt : ?int = false

        var Sign : int := 1;

        var StartIdx : int := 0

        if (S[0] = '-'):
            set Sign = -1
            set StartIdx = 1

        for (Idx := StartIdx..S.Length, C := S[Idx]):
            if (D := AsDigit[C]):
                if (Val := RetInt?):
                    set RetInt = option{Val * 10 + D}
                else:
                    set RetInt = option{D}
            else:
                set RetInt = false

        if (Val := RetInt?):
            set RetInt = option{Val * Sign}

        RetInt?

    AsDigit(C : char)<decides><transacts> : int =
        case(C):
            '0' => 0
            '1' => 1
            '2' => 2
            '3' => 3
            '4' => 4
            '5' => 5
            '6' => 6
            '7' => 7
            '8' => 8
            '9' => 9

    (S: string).Split(Delimiter: string)<transacts>: []string =
        
        var Result : []string := array{}
        var Start : int := 0
        var End : int := 0

        if (S.Length > 0):
            loop:
                if:
                    InputSlice : string := S.Slice[End, End + Delimiter.Length]
                    InputSlice = Delimiter
                    ResultSlice : string := S.Slice[Start, End]
                then:
                    set Result += array{ResultSlice}
                    set End += Delimiter.Length - 1
                    set Start = End + 1
                
                set End += 1

                if (End = S.Length):
                    break
            
        if:
            Start <= S.Length - 1
            RemainingSlice := S.Slice[Start]
        then:
            set Result += array{RemainingSlice}

        return Result