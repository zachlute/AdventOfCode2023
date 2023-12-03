
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

day_03_01_device := class(creative_device):

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        var Sum : int = 0
        
        var RowIdx : int := 0
        var ColIdx : int := 0

        loop:
            if (Row := Input[RowIdx]):
                loop:
                    if (C := Row[ColIdx]):
                        if (Digit := AsDigit[C]):
                            # Figure out the full number
                            var IsPart : logic = false
                            var FullNum : int = Digit
                            var ExtraNumLength : int := 0
                            loop:
                                if:
                                    NextDigit := AsDigit[Row[ColIdx + ExtraNumLength + 1]]
                                then:
                                    set ExtraNumLength += 1
                                    set FullNum = FullNum * 10 + NextDigit
                                else:
                                    break
                            
                            # See if there's a symbol around it.
                            for (SymCheckIdx := (ColIdx - 1)..(ColIdx + ExtraNumLength + 1)):
                                if (Input[RowIdx - 1][SymCheckIdx].IsSymbol[] or Input[RowIdx][SymCheckIdx].IsSymbol[] or Input[RowIdx + 1][SymCheckIdx].IsSymbol[]):
                                    set IsPart = true  

                            if (IsPart = true):
                                #Print("{FullNum} is part!")
                                set Sum += FullNum
                            #else:
                            #    Print("{FullNum} is NOT part!")

                            set ColIdx += ExtraNumLength

                        set ColIdx += 1

                        if (ColIdx >= Row.Length):
                            break

            set ColIdx = 0
            set RowIdx += 1

            if (RowIdx >= Input.Length):
                break
        
        Print("Day 3 - Part 1 - Sum: {Sum}")
        SetBillboardText(ToString(Sum))

    (C: char).IsSymbol()<decides><transacts>: void =
        not AsDigit[C] and C <> '.'

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