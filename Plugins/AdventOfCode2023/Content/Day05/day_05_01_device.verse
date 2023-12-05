
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

thing_map_entry := class():
    DestRangeStart: int = -1
    SourceRangeStart: int = -1
    RangeLength: int = -1

ToString(Entry : thing_map_entry):string =
    return "{Entry.DestRangeStart} {Entry.SourceRangeStart} {Entry.RangeLength}"

thing_map := class():
    Name: string = ""
    var Entries: []thing_map_entry = array{}

    GetValue(Source : int): int =
        for (Entry : Entries):
            if (Source >= Entry.SourceRangeStart and Source < Entry.SourceRangeStart + Entry.RangeLength):
                Offset := Source - Entry.SourceRangeStart
                return Entry.DestRangeStart + Offset

        return Source

ToString(Map : thing_map):string =
    var Output : string = Map.Name
    for (Entry : Map.Entries):
        set Output += "\n{Entry}"
    return Output

day_05_01_device := class(creative_device):

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # Calculation is getting intense. Because this is <suspends>,
        # we can manually timeslice the loop so it doesn't time out.
        var LoopIdx : int := 0

        var Seeds : []int = array{}

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
                set Seeds = for (SeedStr : SeedStrs, SeedInt := SeedStr.AsInt[]):
                    SeedInt
                #Print("Seeds: {ToIntArrayString(Seeds)}")
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

        for (Seed : Seeds):
            # Run it through all the maps and see what the location is.
            var CurrentVal : int = Seed
            for (Map : Maps):
                set CurrentVal = Map.GetValue(CurrentVal)

            if (LowestLocationValue = -1 or CurrentVal < LowestLocationValue):
                set LowestLocationValue = CurrentVal

        Print("Day 5 - Part 1 - Location: {LowestLocationValue}")
        SetBillboardText(ToString(LowestLocationValue))

    ToIntArrayString(A: []int): string =
        var Output : string = ""
        for (Idx := 0..A.Length - 1):
            if (I := A[Idx]):
                if (Idx > 0):
                    set Output += ", "
                set Output += ToString(I)

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