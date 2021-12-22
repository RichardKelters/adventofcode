/*
lava tubes
*/

define temp-table point no-undo
field id as integer
field x as integer
field y as integer
field hpos as integer
index pkid as primary id
index kx x
index ky y
.
define temp-table basin no-undo
field id as integer
field size as integer
index kid as unique id
index ksize size    
.

define buffer north for point.
define buffer south for point.
define buffer west for point.
define buffer east for point.

var int64 answer .
var int i , count , lines.
var char line .

var datetime-tz nu.
nu = now.

// read data
input from value("2021/day09input.txt").
repeat:
    import unformatted line.
    lines += 1.
    do i = 1 to length(line):
        create point.
        assign count += 1
               point.id = count
               point.x = i
               point.y = lines
               point.hpos = integer(substring(line,i,1))
               .
    end.
end.
input close.

function CalculateBasinSize returns logical (basinid as integer , pointid as integer):
    define buffer point for point.
    define buffer north for point.
    define buffer south for point.
    define buffer west for point.
    define buffer east for point.
    define buffer basin for basin.
    
    var int x,y,hpos.
    
    find point where point.id eq pointid.
    find basin where basin.id eq basinid no-error.
    if not available basin
    then create basin.
    assign basin.id = basinid
           basin.size += 1
           x = point.x
           y = point.y
           hpos = point.hpos
           .
    delete point.     

    find north where north.x eq x
                 and north.y eq y - 1 no-error.
    if available north and north.hpos lt 9 and north.hpos gt hpos
    then CalculateBasinSize(basinid,north.id).
    
    find south where south.x eq x
                 and south.y eq y + 1 no-error.
    if available south and south.hpos lt 9 and south.hpos gt hpos
    then CalculateBasinSize(basinid,south.id).
   
    find west  where west.x  eq x + 1
                 and west.y  eq y no-error.
    if available west and west.hpos lt 9 and west.hpos gt hpos
    then CalculateBasinSize(basinid,west.id).

    find east  where east.x  eq x - 1
                 and east.y  eq y no-error.
    if available east and east.hpos lt 9 and east.hpos gt hpos
    then CalculateBasinSize(basinid,east.id).
    
    return true.
end function.

for each point:

    find north where north.x eq point.x
                 and north.y eq point.y - 1 no-error.
    find south where south.x eq point.x
                 and south.y eq point.y + 1 no-error.
    find west  where west.x  eq point.x + 1
                 and west.y  eq point.y no-error.
    find east  where east.x  eq point.x - 1
                 and east.y  eq point.y no-error.

    if  (not available north or north.hpos gt point.hpos)
    and (not available south or south.hpos gt point.hpos)
    and (not available west  or west.hpos  gt point.hpos)
    and (not available east  or east.hpos  gt point.hpos)
    then CalculateBasinSize(point.id,point.id).
    
end.

answer = 1.
for each basin by basin.size descending i = 1 to 3:
    answer *= basin.size.
end.
clipboard:value = string(answer).

message  
  "ms:" now - nu skip
  "answer; " answer
view-as alert-box.

