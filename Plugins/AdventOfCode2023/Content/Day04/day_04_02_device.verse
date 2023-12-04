
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

day_04_02_device := class(creative_device):

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        var Sum : int = 0

        # Calculation is getting intense. Because this is <suspends>,
        # we can manually timeslice the loop so it doesn't time out.
        var LoopIdx : int := 0

        var ExtraCopyCountsForCardsAtOffset : []int := array {0}

        for (Item : Input):

            #Print("Before {LoopIdx}: {ToIntString(ExtraCopyCountsForCardsAtOffset)}")

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

                # For each winning number we have, we get a copy of the next N cards.
                # The card at offset 0 is for copies of THIS card, so we need to add one for this card
                # AND one for each copy of this card.:false = 
                if (ExtraCopiesToAdd := 1 + ExtraCopyCountsForCardsAtOffset[0]):
                    # Add the card for the original card AND each of the extra cards
                    set Sum += ExtraCopiesToAdd

                    for (Offset := 1..WinningIntsWeHave.Length):
                        if (CurrentCount := ExtraCopyCountsForCardsAtOffset[Offset]):
                            if (set ExtraCopyCountsForCardsAtOffset[Offset] = CurrentCount + ExtraCopiesToAdd) {}
                        else:
                            set ExtraCopyCountsForCardsAtOffset += array {ExtraCopiesToAdd}

                #Print("After {LoopIdx}: {ToIntString(ExtraCopyCountsForCardsAtOffset)}")

                # Now remove the 0th offset for the next card.
                # If there's only 1 thing in the array, just clear it for the next card.
                if (ExtraCopyCountsForCardsAtOffset.Length = 1):
                    if (set ExtraCopyCountsForCardsAtOffset[0] = 0) {}
                else if (NewArray := ExtraCopyCountsForCardsAtOffset.RemoveElement[0]):
                    set ExtraCopyCountsForCardsAtOffset = NewArray

            set LoopIdx += 1
            if (Mod[LoopIdx, 100] = 0):
                Sleep(0.0)
        
        Print("Day 4 - Part 2 - Sum: {Sum}")
        SetBillboardText(ToString(Sum))

    ToIntString(A: []int): string =
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