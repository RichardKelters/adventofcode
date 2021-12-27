/*
bioluminescent dumbo octopuses
*/
define temp-table octopus no-undo
field id as integer
field x as integer
field y as integer
field energy as integer
field flash as integer
index kid as primary id 
index kxy x y 
index kenergy energy
.
var int64 answer .
var int i,count,id.
var char line .

var datetime-tz nu.
nu = now.

// read data
input from value("2021/day11input.txt").
repeat:
    import unformatted line.
    count += 1.
    do i = 1 to length(line):
        create octopus.
        assign id += 1
               octopus.id = id
               octopus.x = count
               octopus.y = i
               octopus.energy = integer(substring(line,i,1))
               octopus.flash = 0
               .
    end.
end.
input close.

// functions
function IncrementAdjacent return logical (id as integer):

    define buffer octopus for octopus.
    define buffer adjacent for octopus.
    
    find octopus where octopus.id eq id.
    for each adjacent 
       where adjacent.x gt octopus.x - 2 and adjacent.x lt octopus.x + 2
         and adjacent.y gt octopus.y - 2 and adjacent.y lt octopus.y + 2:
        adjacent.energy += 1.
        if adjacent.energy eq 10 
        then IncrementAdjacent(adjacent.id).
    end.
    
    return true.
    
end function.

function IncrementOctopus return logical ():

    define buffer octopus for octopus.
    
    open query qoctopus preselect each octopus.
    repeat while query qoctopus:handle:get-next():
        octopus.energy += 1.
        if octopus.energy eq 10 
        then IncrementAdjacent(octopus.id).
    end.
    
    return true.
    
end function.

function FlashOctopus return logical ():

    define buffer octopus for octopus.
    
    open query qoctopus preselect each octopus where octopus.energy gt 9.
    repeat while query qoctopus:handle:get-next():
        assign octopus.energy = 0
               octopus.flash += 1
               .
    end.
    
    return true.
    
end function.

// main
do i = 1 to 100:
    IncrementOctopus().
    FlashOctopus().
end.

// main
answer = 0.
for each octopus:
    answer += octopus.flash.
end.

clipboard:value = string(answer).

message  
  "ms:" now - nu skip
  "answer; " answer
view-as alert-box.

