
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

hand_type := enum{HighCard, OnePair, TwoPair, ThreeOfAKind, FullHouse, FourOfAKind, FiveOfAKind}

hand := class():
    Cards : string = ""
    Bid : int = 0
    Type : hand_type = hand_type.HighCard

day_07_01_device := class(creative_device):

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=

        var Total : int := 0

        var LoopIdx : int := 0

        var Hands : []hand = array{}

        for (Item : Input):
            if:
                CardsAndBid := Item.Split(" ")
                Cards := CardsAndBid[0]
                Bid := CardsAndBid[1].AsInt[]
            then:
                var HandType : hand_type = hand_type.HighCard
                var CardCounts : [char]int = map{}
                for (Card : Cards):
                    var Count : int = 1
                    if:
                        set Count = CardCounts[Card]
                    then:
                        set Count += 1

                    if (set CardCounts[Card] = Count) {}

                var NumCounts : [int]int = map{}

                for (Card->Count : CardCounts):
                    var NumCount : int = 1
                    if:
                        set NumCount = NumCounts[Count]
                    then:
                        set NumCount += 1

                    if (set NumCounts[Count] = NumCount) {}

                for (Count->NumCount : NumCounts):
                    case(Count):
                        2 => 
                            if (HandType = hand_type.ThreeOfAKind):
                                set HandType = hand_type.FullHouse
                            else:
                                case(NumCount):
                                    1 => set HandType = hand_type.OnePair
                                    2 => set HandType = hand_type.TwoPair
                                    _ => {}
                        3 => 
                            if (HandType = hand_type.OnePair):
                                set HandType = hand_type.FullHouse
                            else:
                                set HandType = hand_type.ThreeOfAKind
                        4 => set HandType = hand_type.FourOfAKind
                        5 => set HandType = hand_type.FiveOfAKind
                        _ => {}

                set Hands += array{hand{Cards := Cards, Bid := Bid, Type := HandType}}

                set LoopIdx += 1
                    if (Mod[LoopIdx, 100] = 0):
                        Sleep(0.0)

        SortedHands := Sort(Hands, true, CompareHands)

        for(HandIdx := 0..SortedHands.Length - 1):
            if (Hand := SortedHands[HandIdx]):
                Rank := HandIdx + 1
                Winnings := Rank * Hand.Bid
                #Print("{Hand.Cards} : {ToString(Rank)} x {ToString(Hand.Bid)} = {ToString(Winnings)}")
                set Total += Winnings
        
        Print("Day 7 - Part 1 - Total: {Total}")
        SetBillboardText(ToString(Total))

    CompareHands(A : hand, B : hand)<computes>: int = 
        HTA := AsHandTypeValue(A.Type)
        HTB := AsHandTypeValue(B.Type)
        if (HTA < HTB):
            return -1
        else if(HTA > HTB):
            return 1
        else:
            for (CardIdx := 0..A.Cards.Length - 1):
                if:
                    CA := AsCardValue(A.Cards[CardIdx])
                    CB := AsCardValue(B.Cards[CardIdx])
                then:
                    if (CA < CB):
                        return -1
                    else if (CA > CB):
                        return 1
                        
        return 0

    AsCardValue(C : char)<computes> : int =
        case(C):
            '1' => 1
            '2' => 2
            '3' => 3
            '4' => 4
            '5' => 5
            '6' => 6
            '7' => 7
            '8' => 8
            '9' => 9
            'T' => 10
            'J' => 11
            'Q' => 12
            'K' => 13
            'A' => 14
            _ => 0

    AsHandTypeValue(HandType : hand_type)<computes> : int =
        case(HandType):
            hand_type.HighCard => 0
            hand_type.OnePair => 1
            hand_type.TwoPair => 2
            hand_type.ThreeOfAKind => 3
            hand_type.FullHouse => 4
            hand_type.FourOfAKind => 5
            hand_type.FiveOfAKind => 6
    
    Sort(Items : []t, IsAscending : logic, Comparer: type{_(:t, :t)<computes> : int} where t : type)<computes> : []t = 
        if (Items.Length > 1, Pivot := Items[Floor(Items.Length/2)]):
            Left := for(Item : Items, Comparer(Item, Pivot) < 0) do Item 
            Middle := for(Item : Items, Comparer(Item, Pivot) = 0) do Item
            Right := for(Item : Items, Comparer(Item, Pivot) > 0) do Item
            if(IsAscending?):
                Sort(Left, IsAscending, Comparer) + Middle + Sort(Right, IsAscending, Comparer)
            else: 
                Sort(Right, IsAscending, Comparer) + Middle + Sort(Left, IsAscending, Comparer)
        else:    
            Items

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