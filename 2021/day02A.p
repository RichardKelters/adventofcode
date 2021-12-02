/*
count the number of times a depth measurement increases 
from the previous measurement
*/

define temp-table tt no-undo
field nr as integer
field direction as character
field depth as integer
index knr nr.

var int nr.
var int answer.
var char line.
var int distance , depth.
var datetime-tz nu.
nu = now.


input from value("2021/day02input.txt").
repeat:
    import unformatted line.
    create tt.
    assign 
      nr += 1
      tt.nr = nr
      tt.direction = entry(1,line," ")
      tt.depth = integer(entry(2,line," "))
      .
end.
input close.


for each tt:
    case tt.direction:
        when "forward" then distance += tt.depth.
        when "down" then depth += tt.depth.
        when "up" then depth -= tt.depth.
    end case.
end.

answer = distance * depth.
clipboard:value = string(answer).

message 
  "ms: " now - nu skip
  "answer; " answer
view-as alert-box.
