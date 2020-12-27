
define temp-table range no-undo
field nr      as integer   format ">>9"
field class   as character format "x(20)"
field start   as integer
field stop    as integer
index knr nr
.
define temp-table myticket no-undo
field nr      as integer   format ">>9"
field ticket  as integer   format ">>>>>9"
index knr nr
.
define temp-table ticket no-undo
field nr      as integer   format ">>9"
field ticket  as integer   format ">>>>>9"
index knr nr
.

define variable line as character   no-undo.
define variable nr as integer no-undo.
define variable ticket as integer no-undo.
define variable i as integer no-undo .
define variable rate as integer no-undo .
define variable minticket as integer no-undo initial 1000.
define variable maxticket as integer no-undo initial 1.


input from value("2020/day16Ainput.txt").
repeat:
    import unformatted line.
    line = trim(line).
    if line matches "*or*" then do:
        line = replace(line," or ",":").
        
        nr = nr + 1.
        create range.
        assign range.nr = nr
               range.class = entry(1,line,":")
               range.start = integer(trim(entry(1,entry(2,line,":"),"-")))
               range.stop  = integer(trim(entry(2,entry(2,line,":"),"-")))
               .
        
        minticket = minimum(minticket,integer(trim(entry(1,entry(2,line,":"),"-"))) ).
        
        nr = nr + 1.
        create range.
        assign range.nr = nr
               range.class = entry(1,line,":")
               range.start = integer(trim(entry(1,entry(3,line,":"),"-")))
               range.stop  = integer(trim(entry(2,entry(3,line,":"),"-")))
               .
        
        maxticket = maximum(maxticket,integer(trim(entry(2,entry(3,line,":"),"-"))) ).
        next.
    end.
    
    if line begins "your ticket" then do:
        import unformatted line.
        nr = 0.
        do i = 1 to num-entries(line):
            nr = nr + 1.
            ticket = integer(trim(entry(i,line))).
            create myticket.
            assign myticket.nr = nr
                   myticket.ticket = ticket
                   .
        end.
    end.
    
    nr = 0.
    if line begins "nearby tickets" then 
    nearby:
    do while line gt "":
        nr = nr + 1.
        import unformatted line.
        do i = 1 to num-entries(line):
            ticket = integer(trim(entry(i,line))).
            if ticket lt minticket
            or ticket gt maxticket then do:
                for each ticket where ticket.nr = nr:
                    delete ticket.
                end.
                next nearby.
            end.
            create ticket.
            assign ticket.nr = nr
                   ticket.ticket = ticket
                   .
        end.
    end.
    
end.
input close.
/*
define buffer tt for ticket.
&scoped-define T tt
for each {&T}:
    display {&T}  .
end.
*/
clipboard:value = string(rate).

message
  rate 
view-as alert-box.

