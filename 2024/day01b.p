// Calculate similarity score

define temp-table tt no-undo
field nr1 as integer
field nr2 as integer
index knr1 nr1
index knr2 nr2
.
define buffer bf for tt.

var char line.
var int similarity.
var datetime-tz nu.
nu = now.


input from value("2024/day01a_input.txt").
repeat:
    import unformatted line.
    create tt.
    assign tt.nr1 = integer(substring(line,1,5))
           tt.nr2 = integer(substring(line,9,5))
           .
end.
input close.

open query q1 preselect each tt.

do while query q1:get-next():
  open query q2 preselect each bf where bf.nr2 eq tt.nr1.
  similarity += tt.nr1 * num-results("q2").
end.

clipboard:value = string(similarity).
message "duration " now - nu " ms"
  skip  "similarity " similarity 
  view-as alert-box.

