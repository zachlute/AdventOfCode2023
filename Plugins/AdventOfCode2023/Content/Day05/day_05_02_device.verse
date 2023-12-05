
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

day_05_02_device := class(creative_device):

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # Calculation is getting intense. Because this is <suspends>,
        # we can manually timeslice the loop so it doesn't time out.
        var LoopIdx : int := 0

        # Start Seed, Range
        var SeedRanges : []tuple(int,int) = array{}

        var CurrentMap : ?thing_map = false

        # These maps are source => (destination, range)
        # We don't actually care what each map is, just that we can go through them in order.
        var Maps : []thing_map := array {}

        for (Item : Input):

            if:
                Item.Slice[0, "seeds: ".Length] = "seeds: "
                Remainder := Item.Slice["seeds: ".Length]
                SeedStrs := Remainder.Split(" ")
            then:
                Seeds := for (SeedStr : SeedStrs, SeedInt := SeedStr.AsInt[]):
                    SeedInt

                var SeedIdx : int = 0
                loop:
                    if (SeedIdx >= Seeds.Length):
                        break

                    if:
                        SeedPairStart := Seeds[SeedIdx]
                        SeedPairRange := Seeds[SeedIdx + 1]
                    then:
                        set SeedRanges += array{(SeedPairStart, SeedPairStart + SeedPairRange - 1)}

                    set SeedIdx += 2

                #Print("Seed Ranges: {ToIntIntTupleArrayString(SeedRanges)}")
            else if (not CurrentMap? and Item.Slice[Item.Length - " map:".Length] = " map:"):
                NewMap := thing_map{Name := Item}
                set CurrentMap = option{NewMap}
                set Maps += array{NewMap}
            else if (CurrentMap?):
                if (Item.Length = 0):
                    set CurrentMap = false
                else if:
                    MapStrs := Item.Split(" ")
                    DestRangeStart := MapStrs[0].AsInt[]
                    SourceRangeStart := MapStrs[1].AsInt[]
                    RangeLength := MapStrs[2].AsInt[]
                    CurrentMapReal := CurrentMap?
                then:
                    set CurrentMapReal.Entries += array{thing_map_entry{DestRangeStart := DestRangeStart, SourceRangeStart := SourceRangeStart, RangeLength := RangeLength}}

            set LoopIdx += 1
            if (Mod[LoopIdx, 100] = 0):
                Sleep(0.0)

        var LowestLocationValue : int = -1;

        set LoopIdx = 0

        # It's too ineffecient to look at every number, so we need to look at entire sections at once.
        for (Map : Maps):
            var NewRanges : []tuple(int,int) = array{}

            for (SeedRange : SeedRanges):
                var From : int := SeedRange(0)
                To := SeedRange(1)

                loop:
                    if (From > To):
                        break

                    Overlap := FindOverlap(From, To, Map)

                    if:
                        Start := Overlap(0)?
                        Stop := Overlap(1)?
                        Offset := Overlap(2)?
                    then:
                        # There was an overlap!
                        if (Start > From):
                            # But it didn't overlap completely, so we need to add multiple ranges.
                            set NewRanges += array{(From + Offset, Start - 1 + Offset)}
                            set From = Start
                        
                        set NewRanges += array{(Start + Offset, Stop + Offset)}
                        set From = Stop + 1
                    else:
                        # No overlap. Just add the range and keep gong.
                        set NewRanges += array{(From, To)}
                        break
            
            set SeedRanges = NewRanges

        for (SeedRange : SeedRanges):
            #Print("Processing Seed Range: {SeedRange(0)}, {SeedRange(1)}")
            if (LowestLocationValue = -1 or SeedRange(0) < LowestLocationValue):
                set LowestLocationValue = SeedRange(0)

            set LoopIdx += 1
            if (Mod[LoopIdx, 1000] = 0):
                Sleep(0.0)

        Print("Day 5 - Part 2 - Location: {LowestLocationValue}")
        SetBillboardText(ToString(LowestLocationValue))

    FindOverlap(From: int, To : int, ThingMap : thing_map):tuple(?int, ?int, ?int) =
        var Lowest : ?int = false
        var LowestStop : ?int = false
        var LowestOffset : ?int = false

        for (Entry : ThingMap.Entries):
            if (From < Entry.SourceRangeStart + Entry.RangeLength and To > Entry.SourceRangeStart):
                if (Lowest = false or Entry.SourceRangeStart < Lowest?):
                    # This is the new best match
                    set Lowest = option{Max(From, Entry.SourceRangeStart)}
                    set LowestStop = option{Min(To, Entry.SourceRangeStart + Entry.RangeLength - 1)}
                    set LowestOffset = option{Entry.DestRangeStart - Entry.SourceRangeStart}

        return (Lowest, LowestStop, LowestOffset)

    ToIntArrayString(A: []int): string =
        var Output : string = ""
        for (Idx := 0..A.Length - 1):
            if (I := A[Idx]):
                if (Idx > 0):
                    set Output += ", "
                set Output += ToString(I)

        return Output

    ToIntIntTupleArrayString(A: []tuple(int,int)): string =
        var Output : string = ""
        for (Idx := 0..A.Length - 1):
            if:
                I := A[Idx]
                I0 := I(0)
                I1 := I(1)
            then:
                if (Idx > 0):
                    set Output += ", "
                set Output += "({ToString(I0)}, {ToString(I1)})"

        return Output


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