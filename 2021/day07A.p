/*
crab submarines
*/

define temp-table crab no-undo
field id as integer
field hpos as integer
.


var int i .
var int64 answer .
var int count , min , max ,fuel .
var char line .

var datetime-tz nu.
nu = now.

// read data
input from value("2021/day07input.txt").
    import unformatted line.
input close.

count = num-entries(line).

min = 99999.

do i = 1 to count:
    create crab.
    assign
        crab.id  = i
        crab.hpos = integer(entry(i,line))
        min = minimum(min,crab.hpos)
        max = maximum(max,crab.hpos)
        .
end.

fuelcosts:
do i = min to max:

    fuel = 0.
    
    for each crab:
        fuel = fuel + abs(crab.hpos - i).
    end.
    
    if i eq min 
    then answer = fuel.
    
    if fuel gt answer 
    then leave fuelcosts.
    else answer = fuel.
    
end.

clipboard:value = string(answer).

message  
  "ms:" now - nu skip
  "answer; " answer
view-as alert-box.
