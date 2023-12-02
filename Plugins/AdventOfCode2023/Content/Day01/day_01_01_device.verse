
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

day_01_01_device := class(creative_device):

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        var Sum : int = 0;

        for (Item : Input):

            var FoundFront : logic = false
            var FoundBack : logic = false

            var FoundFrontDigit : int = 0;
            var FoundBackDigit: int = 0;

            var FrontIdx : int = 0
            var BackIdx : int = Item.Length - 1

            loop:

                if:
                    FoundFront = false
                    FrontChar := Item[FrontIdx]
                    FrontDigit := AsDigit[FrontChar]
                then:
                    set FoundFront = true
                    set FoundFrontDigit = FrontDigit

                if:
                    FoundBack = false
                    BackChar := Item[BackIdx]
                    BackDigit := AsDigit[BackChar]
                then:
                    set FoundBack = true
                    set FoundBackDigit = BackDigit

                if (FoundFront = true and FoundBack = true):
                    break

                set FrontIdx += 1
                set BackIdx -= 1

            Val := FoundFrontDigit * 10 + FoundBackDigit
            set Sum += Val    
        
        Print("Day 1 - Part 1 - Sum: {Sum}")
    
    AsDigit(c : char)<decides><transacts> : int =
        case(c):
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