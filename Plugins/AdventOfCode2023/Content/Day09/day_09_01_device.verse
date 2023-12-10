
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

day_09_01_device := class(creative_device):

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=

        var Total : int := 0

        var History : [][]int = array{}

        for (Item : Input):
            var Record : []int = array{}
            for (Val : Item.Split(" "), IntVal := Val.AsInt[]):
                set Record += array{IntVal}
            
            #Print("Adding Record: {ToIntArrayString(Record)}")
            set History += array{Record}

        Print("Total Records: {ToString(History.Length)}")

        var LoopIdx : int = 0
        for (Record : History):
            var DiffLines : [][]int := array{Record}
            
            var CurrLine : []int := Record

           

            loop:
                var NextLine : []int := array{}
                var EntryIdx : int := 1
                loop:
                    if (EntryIdx >= CurrLine.Length):
                        break

                    if:
                        Prev := CurrLine[EntryIdx - 1]
                        Curr := CurrLine[EntryIdx]
                    then:
                        Diff := Curr - Prev
                        set NextLine += array {Diff}

                    set EntryIdx += 1

                #Print("NextLine: {ToIntArrayString(NextLine)}")
                set DiffLines += array{NextLine}
                set CurrLine = NextLine
                
                # If the last one is 0, we can assume they're all 0?
                var AllZero : logic = true
                for (N : NextLine, AllZero = true):
                    if (N <> 0):
                        set AllZero = false

                if (AllZero = true):
                    break
            
            # Now that we've built all the lines, walk back up the pyramid.
            var LastItemFromLineBelow : int := 0
            var DiffIdx : int = DiffLines.Length - 1   
            loop:

                if:
                    Line := DiffLines[DiffIdx]
                    LastItem := Line[Line.Length - 1]
                then:
                    NextValue := LastItem + LastItemFromLineBelow
                    #Print("LastItemFromLineBelow: {ToString(LastItemFromLineBelow)}, LastItem: {ToString(LastItem)}, NextValue: {ToString(NextValue)}")
                    #Print("Full Line: {ToIntArrayString(Line)}, {ToString(NextValue)}")
                    set LastItemFromLineBelow = NextValue

                    if (DiffIdx = 0):
                        #Print("Final Line: {ToIntArrayString(Line)}, {ToString(NextValue)}")
                        #Print("-------------")
                        set Total += NextValue
                else:
                    break
                
                set DiffIdx -= 1
            
            set LoopIdx += 1
            if (Mod[LoopIdx, 1000] = 0):
                Sleep(0.0)

        Print("Day 9 - Part 1 - Total: {Total}")
        SetBillboardText(ToString(Total))

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