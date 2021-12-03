/*
determine gamma and epsilon values then multiply
*/


var int nr , i , gamma , epsilon , length.
var int answer.
var int[] count.
var char line.
var datetime-tz nu.
nu = now.

input from value("2021/day03input.txt").
repeat:
    import unformatted line.
    nr += 1.
    
    if nr eq 1 then
        assign
            length = length(line)
            extent(count) = length
            .
        

    do i = 1 to length:
        if substring(line,i,1) eq '1' then
            count[i] += 1.
    end.
end.
input close.

do i = 1 to length:
    put-bits ( gamma   , length + 1 - i , 1 ) = if count[i] gt nr / 2 then 1 else 0.
    put-bits ( epsilon , length + 1 - i , 1 ) = if count[i] lt nr / 2 then 1 else 0.
end.

answer = gamma * epsilon.
clipboard:value = string(answer).

message 
  "ms: " now - nu skip
  "answer; " answer
view-as alert-box.
