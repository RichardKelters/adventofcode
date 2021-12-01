/*
count the number of times a depth measurement increases 
from the previous measurement
*/

define temp-table tt no-undo
field nr as integer
field depth as integer
index knr nr.

var int nr.
var int count.
var datetime-tz nu.
nu = now.


input from value("2021/day01input.txt").
repeat:
    create tt.
    assign 
      nr += 1
      tt.nr = nr
      .
    import tt.depth.
end.
input close.


nr = 10000.
for each tt:
    if tt.depth gt nr then
        count += 1.
    nr = tt.depth.
end.

clipboard:value = string(count).

message  
  "ms: " now - nu skip
  "answer; " count
view-as alert-box.
