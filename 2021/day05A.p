/*
hydrothermal vents
*/


define temp-table lines no-undo
field line as integer format ">>>9"
field x1 as integer   format ">>>9"
field y1 as integer   format ">>>9"
field x2 as integer   format ">>>9"
field y2 as integer   format ">>>9"
index kline line
.
define temp-table points no-undo
field x as integer   format ">>>9"
field y as integer   format ">>>9"
field visit as integer   format ">>>9"
index kxy x y
.

var int nr , ix , iy .
var int answer.
var int count.
var char line .

var datetime-tz nu.
nu = now.

// read data
input from value("2021/day05input.txt").
repeat:
    import unformatted line.
    create lines.
    assign 
        count += 1
        lines.line = count
        lines.x1 = integer(entry(1,entry(1,line," ")))
        lines.y1 = integer(entry(2,entry(1,line," ")))
        lines.x2 = integer(entry(1,entry(3,line," ")))
        lines.y2 = integer(entry(2,entry(3,line," ")))
        .
end.
input close.

// create the visited points
for each lines where lines.x1 eq lines.x2 
                  or lines.y1 eq lines.y2 :
    
    do ix = minimum(lines.x1,lines.x2) to maximum(lines.x1,lines.x2):
    do iy = minimum(lines.y1,lines.y2) to maximum(lines.y1,lines.y2):
    
        find points where points.x eq ix
                      and points.y eq iy no-error.
        if not available points
        then create points.
        
        assign
            points.x = ix
            points.y = iy
            points.visit += 1
            .
        
    end.
    end.
     
end.

for each points where points.visit ge 2:
    answer += 1.
end.

clipboard:value = string(answer).

message 
  "ms:" now - nu skip
  "answer; " answer
view-as alert-box.
