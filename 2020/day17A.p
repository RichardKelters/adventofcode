
define temp-table cube no-undo
field x as integer  format "->>9"
field y as integer  format "->>9"
field z as integer  format "->>9"
field active as logical
index kxyx x y z
.
define buffer bfcube for cube.
define temp-table newcube no-undo like cube.

var char line.
var int row.
var int i.
var int j.
var int k.
var int cycle.

input from value("2020/day17Ainput.txt").
repeat:
    import unformatted line.
    row += 1.
    do i = 1 to length(line):
        create cube.
        assign 
            cube.x  = i
            cube.y  = row
            cube.z  = 0
            cube.active = "#" eq substring(line,i,1)
            .
    end.
end.
input close.

function ActiveNeighbors returns integer (x as integer , y as integer , z as integer):
    var int i.
    var int j.
    var int k.
    var int ActiveNeighbors.
    define buffer newcube for newcube.
    do i = -1 to 1:
    do j = -1 to 1:
    do k = -1 to 1:
        if i eq 0 and j eq 0 and k eq 0 then
            next.
        find newcube where newcube.x  eq x + i
                       and newcube.y  eq y + j
                       and newcube.z  eq z + k no-error. 
                     
        if available newcube 
        and newcube.active then
            ActiveNeighbors += 1.    
    end.
    end.
    end.
    return ActiveNeighbors.
end function.

do cycle = 1 to 6:
    
    empty temp-table newcube.

    for each cube:
        if cube.active eq false then
            delete cube.
        else 
        do i = -1 to 1:
        do j = -1 to 1:
        do k = -1 to 1:
            find first newcube
                 where newcube.x  eq cube.x + i
                   and newcube.y  eq cube.y + j
                   and newcube.z  eq cube.z + k no-error.
            find first bfcube 
                 where bfcube.x  eq cube.x + i
                   and bfcube.y  eq cube.y + j
                   and bfcube.z  eq cube.z + k no-error.                
            if not available newcube then
                create newcube .
            assign 
                newcube.x  = cube.x + i
                newcube.y  = cube.y + j
                newcube.z  = cube.z + k
                newcube.active = available bfcube and bfcube.active
                .
        end.
        end.
        end.
    end.
    
    temp-table cube:handle:copy-temp-table (temp-table newcube:handle).
    
    for each cube:
        case ActiveNeighbors(cube.x,cube.y,cube.z):
            when 2 then 
                next.
            when 3 then do:
                if not cube.active then
                     cube.active = true.
            end.
            otherwise cube.active = false.
        end case.
    end.
    
end.

i = 0.
for each cube where cube.active: 
    i += 1.
end.
clipboard:value = string(i).
message i view-as alert-box.
