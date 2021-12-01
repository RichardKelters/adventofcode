/*
each depth is now defined by adding the next two depths
count the number of times a depth measurement increases 
from the previous measurement
*/

define temp-table tt no-undo
field nr as integer
field depth as integer
index knr nr.
define temp-table t3 like tt.
define buffer b1 for tt.
define buffer b2 for tt.
define buffer b3 for tt.

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
delete tt. // somehow an additional record is created, we don't need it

nr = 0.
for each b1:

    find first b2 where b2.nr gt b1.nr .
    find first b3 where b3.nr gt b2.nr no-error.
    if not available b3 then
        leave.
    create t3.
    assign
      nr += 1
      t3.nr = nr
      t3.depth = b1.depth
               + b2.depth
               + b3.depth
      .
       
end.



nr = 10000.
for each t3:
    if t3.depth gt nr then
        count += 1.
    nr = t3.depth.
end.

clipboard:value = string(count).

message  
  "ms: " now - nu skip
  "answer; " count
view-as alert-box.
