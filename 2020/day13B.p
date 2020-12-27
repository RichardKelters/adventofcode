
define temp-table tt no-undo
field nr      as integer   format ">9"
field bus     as integer   format ">>9"
index knr nr
//index kbus bus descending
.

define variable line as character   no-undo.
define variable nr as integer no-undo.
define variable bus as integer no-undo.
define variable MyTime as integer no-undo.
define variable f as decimal no-undo.
define variable answer as decimal no-undo.
define variable prevanswer as decimal no-undo.
define variable lastanswer as decimal no-undo.
define variable i as decimal no-undo.

var datetime-tz nu.
nu = now.

input from value("2020/day13Ainput.txt").
repeat:
    import unformatted line.
    line = trim(line).
    MyTime = integer(line).
    import  unformatted line.
    do i = 1 to num-entries(line):
        nr = nr + 1.
        if entry(integer(i),line) eq "X" then
            next.
        create tt.
        assign tt.nr      = nr
               tt.bus     = integer(entry(integer(i),line))
               .
    end.
end.
input close.
       //100000000000000
answer = 100417575713979.

MainBlock:
do while true:
    if answer - prevanswer gt 100000000 then do:
        output to value("2020/day13Boutput.txt").
            put unformatted answer skip.
        output close.
        prevanswer = answer.
        display answer format ">>>>>>>>>>>>>>>>9" string(integer(truncate(((now - nu) / 1000),0)),"hh:mm:ss").
        process events.
    end.
    if lastanswer eq answer then
        leave MainBlock.
    lastanswer = answer.
    find first tt.
    BusBlock:
    do while true:
        nr  = tt.nr.
        bus = tt.bus.
        i = truncate(answer / bus,0) - 1.
        find next tt no-error.
        if not available tt then
            next MainBlock.
        TimeBlock:
        do while true:
            i = i + 1.
            f = ((i * bus) + (tt.nr - nr)) / tt.bus.
            if f eq truncate(f,0)
            and i * bus - nr + 1 ge answer then do:
                answer = i * bus - nr + 1.
                leave TimeBlock.
            end.
        end.
    end.
end.

clipboard:value = string(answer).

message
  line skip
  answer  skip
  now - nu
view-as alert-box.

