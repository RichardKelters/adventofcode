/*
bingo
*/


define temp-table cards no-undo
field card as integer
field number as integer
field drawn as logical
field irow as integer
field icol as integer
index kcard card
index knumber number

.
define buffer bf for cards.

var int nr , i , card , irow , icol ,  count .
var int answer.
var char line , numbers.

var datetime-tz nu.
nu = now.

// read data
input from value("2021/day04input.txt").
repeat:
    import unformatted line.
    if numbers eq ""
    then do: 
        numbers = line.
        count = num-entries(numbers).
        next.
    end. 
    if trim(line) eq "" 
    then do:
        card += 1.
        irow = 0.
        next.
    end.
    assign
      irow += 1
      .
    do icol = 0 to 4:
        create cards.
        assign
            cards.card = card
            cards.irow = irow
            cards.icol = icol + 1
            cards.number = integer(trim(substring(line,(icol * 3) + 1 ,2)))
            .
    end.
       
end.
input close.


BINGO:
do i = 1 to count :

    FindLastCard:
    for each cards where cards.number eq integer(entry(i,numbers)):
        
        cards.drawn = true.
        
        // is current row completely marked for bingo?
        for each bf where bf.card eq cards.card
                      and bf.irow eq cards.irow:
            if bf.drawn eq false 
            then leave.
        end.
        
        if available bf then
        // is current column completely marked for bingo?
        for each bf where bf.card eq cards.card
                      and bf.icol eq cards.icol:
            if bf.drawn eq false 
            then leave.
        end.
        
        // if there are no other cards then we are at the last bingo
        if not available bf
        and not can-find(first bf where bf.card ne cards.card) 
        then leave BINGO. 
     
        // if we're not at the last bingo then just delete the card
        if not available bf
        then for each bf where bf.card eq cards.card:
            delete bf.
        end.
        
    end.
end.

// final score
for each bf where bf.card eq cards.card:
    if bf.drawn eq false 
    then answer += bf.number.
end.

answer = answer * integer(entry(i,numbers)).
clipboard:value = string(answer).

message   
  "ms:" now - nu skip
  "answer; " answer
view-as alert-box.
