
define temp-table tile no-undo
field nr   as integer format ">>>9"
field tile as integer format ">>>9"
index knr nr
.
define temp-table image no-undo
field nr as integer format ">>>9"
field rownr as integer format ">9"
field line as character label "" format "x(1)" extent 10
index knr nr
.

define temp-table number no-undo
field nr as integer format ">>>9"
field side as character
field number as integer format ">>>9"
index knr nr
index knumber number
.

var char line.
var int64 i.
var int nr.
var int rownr.
var char firstcol.
var char lastcol.
var char firstrow.
var char lastrow.

input from value("2020/day20Ainput.txt").
repeat:
    import unformatted line.
    if trim(line) eq "" then
        next.
    if line begins "Tile" then do:
        create tile.
        assign 
            nr += 1
            rownr = 0
            tile.nr = nr
            tile.tile = integer(substring(line,6,4))
            .
        next.
    end.
    create image.
    assign
        image.nr = nr
        rownr += 1
        image.rownr = rownr
        .
    do i = 1 to 10:
        image.line[i] = substring(line,i,1).           
    end.
end.
input close.

function CreateNumbers return logical (nr as integer,line as character,side as character):
    var int i.
    
    create number.
    assign number.nr = nr
           number.side = side
           .
    do i = 1 to 10:
        put-bits(number.number,i,1) = if substring(line,11 - i,1) eq "#"
                                     then 1
                                     else 0.
    end.
    
    create number.
    assign number.nr = nr
           number.side = side
           .
    do i = 1 to 10:
        put-bits(number.number,i,1) = if substring(line,i,1) eq "#"
                                     then 1
                                     else 0.
    end.
    
end function.

for each image break by image.nr:
    if first-of(image.nr) then do:
        firstrow = "".
        firstcol = "".
        lastcol  = "".
        do i = 1 to 10:
            firstrow += image.line[i].           
        end.
    end.
    firstcol += image.line[1].
    lastcol  += image.line[10].
    if last-of(image.nr) then do:
        lastrow = "".
        do i = 1 to 10:
            lastrow += image.line[i].           
        end.
        CreateNumbers(image.nr,firstrow,"north").
        CreateNumbers(image.nr,firstcol,"west").
        CreateNumbers(image.nr,lastrow ,"south").
        CreateNumbers(image.nr,lastcol ,"east").
    end.
    
end.

define buffer tt for number.
i = 1.
for each tile:
    nr = 0.
    for each number where number.nr eq tile.nr break by number.side:
        
        find first tt where tt.number eq number.number
                        and tt.nr ne number.nr no-error.

                        if first-of(number.side) and not available tt then
            rownr = 1.
        if last-of(number.side) and not available tt and rownr = 1 then
            assign
              nr += 1
              rownr = 0
              .
    end.
    if nr eq 2 then
        i = i * tile.tile.
end.

clipboard:value = string(i).
message i
view-as alert-box.
