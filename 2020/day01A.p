/*
Specifically, they need you to find the two entries 
that sum to 2020 and then multiply those two numbers 
together.
*/

define temp-table tt no-undo
field nr as integer
index knr nr.


input from value("2020/day01Ainput.txt").
repeat:
    create tt.
    import tt.
end.
input close.

define buffer bf for tt.

for each tt:
    find bf where bf.nr eq 2020 - tt.nr no-error.
    if available bf then
        leave.
end.

clipboard:value = string(bf.nr * tt.nr).

message  
  tt.nr skip
  bf.nr skip
  bf.nr * tt.nr
view-as alert-box.
