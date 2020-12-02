/*
In your expense report, what is the product of the 
three entries that sum to 2020?
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
define buffer ta for tt.
define buffer tb for tt.

block:
for each ta where ta.nr gt 0:
    for each tb where tb.nr gt 0 and tb.nr lt 2020 - ta.nr:
        find bf where bf.nr eq 2020 - ta.nr - tb.nr no-error.
        if available bf then
            leave block.
    end.
end.

clipboard:value = string(bf.nr * ta.nr * tb.nr).

message  
  bf.nr skip
  ta.nr skip
  tb.nr skip
  bf.nr * ta.nr * tb.nr
view-as alert-box.
