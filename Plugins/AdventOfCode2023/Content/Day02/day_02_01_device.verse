
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

day_02_01_device := class(creative_device):

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        var Sum : int = 0

        TestRed : int := 12
        TestGreen : int := 13
        TestBlue : int := 14

        for (Item : Input):

            GameAndResults := Item.Split(": ");
            if:
                Game := GameAndResults[0]
                Results := GameAndResults[1]
                GameNum := Game.Split(" ")[1].AsInt[]
                Pulls := Results.Split("; ")
            then:
                var MaxRed : int = 0
                var MaxGreen : int = 0
                var MaxBlue : int = 0

                for (Pull : Pulls):
                    for (ColorPull : Pull.Split(", ")):
                        CountAndColor := ColorPull.Split(" ")
                        if:
                            ColorCount := CountAndColor[0].AsInt[]
                            Color := CountAndColor[1]
                        then:
                            if (Color = "red" and ColorCount > MaxRed):
                                set MaxRed = ColorCount
                            if (Color = "green" and ColorCount > MaxGreen):
                                set MaxGreen = ColorCount
                            if (Color = "blue" and ColorCount > MaxBlue):
                                set MaxBlue = ColorCount

                #Print("Game {GameNum}: {MaxRed}, {MaxGreen}, {MaxBlue}")
                
                if:
                    MaxRed <= TestRed
                    MaxGreen <= TestGreen
                    MaxBlue <= TestBlue
                then:
                    set Sum += GameNum
        
        Print("Day 2 - Part 1 - Sum: {Sum}")
        SetBillboardText(ToString(Sum))
    
    (S: string).AsInt()<decides><transacts>: int =
        var RetInt : int := 0

        var Sign : int := 1;

        if (S[0] = '-'):
            set Sign = -1

        for (C : S):
            set RetInt = RetInt * 10 + AsDigit[C]

        return Sign * RetInt

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