
define temp-table tt no-undo
field nr     as integer   format ">>>9"
field number as int64     format ">>>>>>>>>>>>>>9"
index knr nr
.

define variable line as character   no-undo.
define variable nr as integer no-undo.
define variable i as integer no-undo.
define variable cypher as int64 no-undo.
define variable hassum as logical no-undo.
define variable preamble as integer no-undo.

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

define buffer bf for tt.
preamble = 25.
lines:
do i = preamble to nr:
    find tt where tt.nr eq i + 1.
    cypher = tt.number.
    hassum = false.

    preamble:
    for each tt where tt.nr gt i - preamble and tt.nr le i
       ,each bf where bf.nr gt i - preamble and bf.nr le i
                  and bf.number ne tt.number:

        hassum = cypher eq (tt.number + bf.number).
        if hassum then
            leave preamble.

    end.
    if not hassum then
        leave lines.
end.

clipboard:value = string(cypher).

message  
  cypher 
view-as alert-box.

