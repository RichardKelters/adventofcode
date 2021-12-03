/*
determine oxygen generator rating 
and CO2 scrubber rating then multiply
*/

define temp-table tt no-undo
field nr as integer
field line as character
index knr nr
index kline line.

define query q1 for tt.
define query q0 for tt.


var int nr , i , length , oxy , co2.
var int answer.
var int count.
var char line.
var char coxy , cco2.
var datetime-tz nu.
nu = now.

// read data
input from value("2021/day03input.txt").
repeat:
    import unformatted line.
    create tt.
    assign
      nr += 1
      tt.nr = nr
      tt.line = line
      .
    
    if nr eq 1 
    then length = length(line).
        
end.
input close.

// using temp-table index and queries determine oxygen generator rating
generator:
do i = 1 to length:

    open query q1 preselect each tt where tt.line begins coxy + '1'.
    open query q0 preselect each tt where tt.line begins coxy + '0'.
    
    if num-results('q1') + num-results('q0') eq 1
    then leave generator.
    
    if num-results('q1') ge num-results('q0') 
    then coxy += '1'.
    else coxy += '0'.
   
end.
if num-results('q1') eq 1
then get first q1.
else get first q0.
coxy = tt.line.

// same logic with slight difference determin CO2 scrubber rating
// code is similar as for the generator block and could have been
// combined for avoiding duplicate code but that would have resulted 
// in other if-then-else's which would not have added value at this time
scrubber:
do i = 1 to length:

    open query q1 preselect each tt where tt.line begins cco2 + '1'.
    open query q0 preselect each tt where tt.line begins cco2 + '0'.
    
    if num-results('q1') + num-results('q0') eq 1
    then leave scrubber.
    
    if num-results('q1') lt num-results('q0') 
    then cco2 += '1'.
    else cco2 += '0'.
   
end.
if num-results('q1') eq 1
then get first q1.
else get first q0.
cco2 = tt.line.

do i = 1 to length:
    put-bits ( oxy , length + 1 - i , 1 ) = integer(substring(coxy,i,1)).
    put-bits ( co2 , length + 1 - i , 1 ) = integer(substring(cco2,i,1)).
end.

answer = oxy * co2.
clipboard:value = string(answer).

message 
  "ms: " now - nu skip
  "answer; " answer
view-as alert-box.
