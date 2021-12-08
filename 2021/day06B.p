/*
lanternfish
*/

define temp-table fish no-undo
field timer as integer
field count as int64
.

define buffer mature for fish.

var int i , days .
var int64 answer.
var int count.
var char line .

var datetime-tz nu.
nu = now.

// read data
input from value("2021/day06input.txt").
    import unformatted line.
input close.

days  = 256.
count = num-entries(line).


// initialize fish
do i = 1 to count:
    find fish where fish.timer eq integer(entry(i,line)) no-error.
    if not available fish
    then create fish.
    assign
        fish.timer = integer(entry(i,line))
        fish.count += 1
        .
end.

// count down the days
do i = 1 to days :
    
    repeat preselect each fish:
        find next fish.
        fish.timer -= 1.
    end.

    find fish where fish.timer eq -1 no-error.
    if available fish
    then do:

        find mature where mature.timer eq 6 no-error.
        
        if not available mature 
        then create mature.
        
        assign 
            mature.timer = 6
            mature.count += fish.count
            fish.timer   = 8
            .            
    end.
end.

for each fish:
    answer += fish.count.
end.

clipboard:value = string(answer).

message 
  "ms:" now - nu skip
  "answer; " answer
view-as alert-box.
