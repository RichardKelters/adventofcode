/*
lanternfish
*/


define temp-table fish no-undo
field day as integer format ">>>9" initial 8
.
define buffer bfish for fish.

var int i.
var int answer.
var int count.
var char line .

var datetime-tz nu.
nu = now.

// read data
input from value("2021/day06input.txt").
    import unformatted line.
input close.
count = num-entries(line).
do i = 1 to count:
    create fish.
    assign fish.day = integer(entry(i,line)).
end.

do i = 1 to 80:
    repeat preselect each fish:
        find next fish.
        fish.day -= 1.
        if fish.day lt 0
        then do:
            fish.day = 6.
            create bfish.
        end.
    end.
end.
open query q preselect each fish.
answer =   num-results('q').
clipboard:value = string(answer).

message 
  "ms:" now - nu skip
  "answer; " answer
view-as alert-box.
