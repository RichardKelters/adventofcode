
define temp-table tt no-undo
field nr     as integer   format ">>>9"
field number as int64     format ">>>>>>>>>>>>>>9"
index knr nr
.

define variable line as character   no-undo.
define variable nr as integer no-undo.
define variable i as integer no-undo.
define variable cypher as int64 no-undo.
define variable lownumber  as int64 no-undo.
define variable highnumber as int64 no-undo.

input from value("2020/day09Ainput.txt").
repeat:
    import unformatted line.
    line = trim(line).
    create tt.
    assign nr         = nr + 1
           tt.nr      = nr
           tt.number  = int64(trim(line))
           .
end.
input close.

lines:
do i = 1 to nr:
    cypher = 85848519. // result from 9A
    lownumber = cypher.
    highnumber = 0.

    for each tt where tt.nr ge i:
        lownumber  = minimum( tt.number , lownumber ).
        highnumber = maximum( tt.number , highnumber ). 
        cypher = cypher - tt.number.
    
        if cypher eq 0 then
            leave lines.
        if cypher lt 0 then
            next lines.
    end.
end.

cypher =  lownumber + highnumber.

clipboard:value = string(cypher).
message  
  cypher 
view-as alert-box.

