
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

day_06_02_device := class(creative_device):

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=

        var Product : ?int := false

        if:
            TimeStrs := Input[0].Split(":")[1].Split(" ")
            DistanceStrs := Input[1].Split(":")[1].Split(" ")
            Times := for (TimeStr : TimeStrs, I := TimeStr.AsInt[]) { I }
            Distances := for (DistanceStr : DistanceStrs, I := DistanceStr.AsInt[]) { I }
        then:
            var ConcatTimeStr : string = ""
            var ConcatDistanceStr : string = ""

            for (TimeIdx := 0..Times.Length - 1):
                if:
                    Time := Times[TimeIdx]
                    Distance := Distances[TimeIdx]
                then:
                    set ConcatTimeStr += ToString(Time)
                    set ConcatDistanceStr += ToString(Distance)

            if:
                Time := ConcatTimeStr.AsInt[]
                Distance := ConcatDistanceStr.AsInt[]
            then:
                #Print("Time: {Time}")
                #Print("Distance: {Distance}")
                NumPossibilities := WaysToWin(Time, Distance)

                Print("Day 6 - Part 2 - Num Possibilities: {NumPossibilities}")
                SetBillboardText(ToString(NumPossibilities))

    WaysToWin(Time : int, Record : int):int =
        Discriminant : int := (Time * Time) - (4 * Record)
        if:
            MinRoot := Floor[((Time * 1.0) - Sqrt(Discriminant * 1.0)) / 2.0] + 1
            MaxRoot := Ceil[((Time * 1.0) + Sqrt(Discriminant * 1.0)) / 2.0] - 1
        then:
            return MaxRoot - MinRoot + 1

        return 0

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