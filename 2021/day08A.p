// Day 8: Seven Segment Search


var char line.
var int answer , i.
var datetime-tz nu.
nu = now.


input from value("2021/day08input.txt").
repeat:
    import unformatted line.
    line = substring(line,62).
    do i = 1 to 4:
        if length(entry(i,line," ")) eq 2 // 1
        or length(entry(i,line," ")) eq 4 // 4
        or length(entry(i,line," ")) eq 3 // 7
        or length(entry(i,line," ")) eq 7 // 8
        then answer += 1. 
    end.
end.
input close.

clipboard:value = string(answer).

message  
  "ms:" now - nu skip
  "answer; " answer
view-as alert-box.

