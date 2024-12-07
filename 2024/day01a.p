// find the total distance between the left list and the right list

define temp-table tt no-undo
field nr1 as integer
field nr2 as integer
index knr1 nr1
index knr2 nr2
.
define buffer bf for tt.

var char line.
var int total.
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

open query q1 for each tt use-index knr1.
open query q2 for each bf use-index knr2.

do while query q1:get-next():
  query q2:get-next().
  total += absolute(tt.nr1 - bf.nr2).
end.

clipboard:value = string(total).
message "duration " now - nu " ms"
  skip  "total " total
  view-as alert-box.
