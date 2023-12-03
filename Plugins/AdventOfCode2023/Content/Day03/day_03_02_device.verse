
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

potential_gear := class():
    Row: int = -1
    Col: int = -1
    var AdjacentParts : []int = array{}

day_03_02_device := class(creative_device):

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        var Sum : int = 0
        
        var RowIdx : int := 0
        var ColIdx : int := 0

        var PotentialGears : []potential_gear := array{}

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
                            for (SymCheckColIdx := (ColIdx - 1)..(ColIdx + ExtraNumLength + 1)):
                                for (SymCheckRowIdx := RowIdx - 1..RowIdx + 1):
                                    if:
                                        SymCheckChar := Input[SymCheckRowIdx][SymCheckColIdx]
                                        SymCheckChar.IsSymbol[]
                                    then:
                                        set IsPart = true
                                        if (SymCheckChar = '*'):
                                            # It might be a gear.
                                            if (Found := FindPotentialGears(PotentialGears, SymCheckRowIdx, SymCheckColIdx)[0]):
                                                set Found.AdjacentParts += array{FullNum}
                                            else:
                                                set PotentialGears += array {potential_gear{Row := SymCheckRowIdx, Col := SymCheckColIdx, AdjacentParts := array{FullNum}}}

                            set ColIdx += ExtraNumLength

                        set ColIdx += 1

                        if (ColIdx >= Row.Length):
                            break

            set ColIdx = 0
            set RowIdx += 1

            if (RowIdx >= Input.Length):
                break

        # Go through all the potential gears and figure out which are actually gears (exactly 2 adjacent parts)
        for (PotentialGear : PotentialGears):
            #Print("Potential Gear: {PotentialGear.Row}, {PotentialGear.Col} = {PotentialGear.AdjacentParts.Length}")
            if:
                PotentialGear.AdjacentParts.Length = 2
                GearRatio := PotentialGear.AdjacentParts[0] * PotentialGear.AdjacentParts[1]
            then:
                set Sum += GearRatio
        
        Print("Day 3 - Part 2 - Sum: {Sum}")
        SetBillboardText(ToString(Sum))

    FindPotentialGears(PotentialGears : []potential_gear, Row : int, Col : int)<transacts> : []potential_gear =
        for (PotentialGear : PotentialGears, PotentialGear.Row = Row and PotentialGear.Col = Col):
            PotentialGear

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