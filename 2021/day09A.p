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
    then answer +=  point.hpos + 1.
    
end.
clipboard:value = string(answer).

message  
  "ms:" now - nu skip
  "answer; " answer
view-as alert-box.

