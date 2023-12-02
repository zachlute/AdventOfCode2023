
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

day_01_02_device := class(creative_device):

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        var Sum : int = 0;

        for (Item : Input):

            #Print("Input: {Item}")

            var FoundFront : logic = false
            var FoundBack : logic = false

            var FoundFrontDigit : int = 0;
            var FoundBackDigit: int = 0;

            var FrontIdx : int = 0
            var BackIdx : int = Item.Length - 1

            loop:

                if:
                    FoundFront = false
                    FrontDigit := Item.PrefixAsDigit[FrontIdx]
                then:
                    set FoundFront = true
                    set FoundFrontDigit = FrontDigit

                if:
                    FoundBack = false
                    BackDigit := Item.PrefixAsDigit[BackIdx]
                then:
                    set FoundBack = true
                    set FoundBackDigit = BackDigit

                if (FoundFront = true and FoundBack = true):
                    break

                set FrontIdx += 1
                set BackIdx -= 1

            Val := FoundFrontDigit * 10 + FoundBackDigit
            set Sum += Val    
        
        Print("Day 1 - Part 2 - Sum: {Sum}")
    
    (S:string).PrefixAsDigit(FromIdx : int)<decides><transacts> : int =

        var RetInt : ?int = false

        if (S.StartsWith[FromIdx, "0"] or S.StartsWith[FromIdx, "zero"]):
            set RetInt = option{0}
        else if (S.StartsWith[FromIdx, "1"] or S.StartsWith[FromIdx, "one"]):
            set RetInt = option{1}
        else if (S.StartsWith[FromIdx, "2"] or S.StartsWith[FromIdx, "two"]):
            set RetInt = option{2}
        else if (S.StartsWith[FromIdx, "3"] or S.StartsWith[FromIdx, "three"]):
            set RetInt = option{3}
        else if (S.StartsWith[FromIdx, "4"] or S.StartsWith[FromIdx, "four"]):
            set RetInt = option{4}
        else if (S.StartsWith[FromIdx, "5"] or S.StartsWith[FromIdx, "five"]):
            set RetInt = option{5}
        else if (S.StartsWith[FromIdx, "6"] or S.StartsWith[FromIdx, "six"]):
            set RetInt = option{6}
        else if (S.StartsWith[FromIdx, "7"] or S.StartsWith[FromIdx, "seven"]):
            set RetInt = option{7}
        else if (S.StartsWith[FromIdx, "8"] or S.StartsWith[FromIdx, "eight"]):
            set RetInt = option{8}
        else if (S.StartsWith[FromIdx, "9"] or S.StartsWith[FromIdx, "nine"]):
            set RetInt = option{9}

        RetInt?

    (S:string).StartsWith(FromIdx : int, Prefix : string)<decides><transacts> : void =

        if (S.Length - FromIdx >= Prefix.Length):

            for (PrefixIdx := 0..Prefix.Length - 1, FromIdx + PrefixIdx < S.Length):
                SC := S[FromIdx + PrefixIdx]
                PC := Prefix[PrefixIdx]
                SC = PC

        else:

            false?


