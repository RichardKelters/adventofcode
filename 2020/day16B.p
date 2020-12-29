
define temp-table range no-undo
field nr      as integer   format ">>9"
field class   as character format "x(30)"
field start   as integer
field stop    as integer
index knr nr
.
define temp-table myticket no-undo
field nr      as integer   format ">>9"
field ticket  as integer   format ">>>>>9"
index knr nr
.
define temp-table nearby no-undo
field rownr   as integer   format ">>9"
field nr      as integer   format ">>9"
field ticket  as integer   format ">>>>>9"
index knr nr
index krownr rownr nr
.
define temp-table classnr no-undo
field nr   as integer   format ">>9"
field class   as character format "x(20)"
index knr nr
.

define variable line as character   no-undo.
define variable rownr as integer no-undo.
define variable nr as integer no-undo.
define variable ticket as integer no-undo.
define variable i as integer no-undo .
define variable count as int64 no-undo .
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
        
        //nr = nr + 1.
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
    
    
    if line begins "nearby tickets" then 
    nearby:
    do while line gt "":
        rownr = rownr + 1.
        import unformatted line.
        nr = 0.
        do i = 1 to num-entries(line):
            nr = nr + 1.
            ticket = integer(trim(entry(i,line))).
            if ticket lt minticket
            or ticket gt maxticket then do:
                for each nearby where nearby.rownr = rownr:
                    delete nearby.
                end.
                next nearby.
            end.
            create nearby.
            assign nearby.rownr = rownr
                   nearby.nr = nr
                   nearby.ticket = ticket
                   .
        end.
    end.
    
end.
input close.

define buffer range1 for range.
define buffer range2 for range.
// second try ... gives same result maybe I don't understand the question
position:
do nr = 1 to 20:
    if not can-find(first nearby where nearby.nr eq nr) then
        next position.
    range:
    do i = 1 to 20:
        find first range1 where range1.nr eq i no-error.
        if not available range1 then
            next range.
        find range2 where range2.nr eq i and rowid(range2) ne rowid(range1).
        nearby:
        for each nearby where nearby.nr eq nr:
            if (    nearby.ticket ge range1.start 
                and nearby.ticket le range1.stop )
            or (    nearby.ticket ge range2.start 
                and nearby.ticket le range2.stop )
            then next nearby.
            else next range.
        end.
        leave range.
    end.
    if not available range1 then
        next position.
    create classnr.
    assign classnr.nr = nr
           classnr.class = range1.class
           .
    delete range1.
    delete range2.
    for each nearby where nearby.nr eq nr:
        delete nearby.
    end.
    next position.
    
end.

/*
first try
range:
do i = 1 to 20:
    find first range1 where range1.nr eq i.
    find range2 where range2.nr eq i and rowid(range2) ne rowid(range1).
    position:
    do nr = 1 to 20:
        if not can-find(first nearby where nearby.nr eq nr) then
            next position.
        nearby:
        for each nearby where nearby.nr eq nr:
            if (    nearby.ticket ge range1.start 
                and nearby.ticket le range1.stop )
            or (    nearby.ticket ge range2.start 
                and nearby.ticket le range2.stop )
            then next nearby.
            else next position.
            
        end.
        create classnr.
        assign classnr.nr = nr
               classnr.class = range1.class
               .
        delete range1.
        delete range2.
        for each nearby where nearby.nr eq nr:
            delete nearby.
        end.
        next range.
        
    end.
end.
*/


count = 1.
define buffer tt for classnr.
for each tt where tt.class begins "departure"
   ,each myticket where myticket.nr eq tt.nr:
    count = count * myticket.ticket.
    display tt.nr tt.class  myticket.ticket.
end.

clipboard:value = string(count).

message
  count 
view-as alert-box.

