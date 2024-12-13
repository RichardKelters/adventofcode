// Count mas cross

define temp-table xmas no-undo
field c as character
field x as integer
field y as integer
index key c x y
.
define buffer bf for xmas.
define buffer a for xmas.
define buffer s1 for xmas.
define buffer m1 for xmas.
define buffer s2 for xmas.
define buffer m2 for xmas.

var char line.
var int i, j, numXmas.
var datetime-tz nu.
nu = now.


input from value("2024/day04a_input.txt").
repeat:
    import unformatted line.
    j += 1.
    do i = 1 to length(line):
      create xmas.
      assign xmas.c = substring(line,i,1)
             xmas.x = i
             xmas.y = j
             .
    end.
end.
input close.

/* M.S */
/* .A. */
/* M.S */
open query q preselect 
 each a where a.c eq 'A' ,
 each s1 where s1.c eq 'S' and s1.x eq a.x + 1 and s1.y eq a.y + 1,
 each m1 where m1.c eq 'M' and m1.x eq a.x - 1 and m1.y eq a.y - 1,
 each s2 where s2.c eq 'S' and s2.x eq a.x + 1 and s2.y eq a.y - 1,
 each m2 where m2.c eq 'M' and m2.x eq a.x - 1 and m2.y eq a.y + 1. 

numXmas += num-results('q').

/* S.S */
/* .A. */
/* M.M */
open query q preselect 
 each a where a.c eq 'A' ,
 each s1 where s1.c eq 'S' and s1.x eq a.x - 1 and s1.y eq a.y - 1,
 each m1 where m1.c eq 'M' and m1.x eq a.x + 1 and m1.y eq a.y + 1,
 each s2 where s2.c eq 'S' and s2.x eq a.x + 1 and s2.y eq a.y - 1,
 each m2 where m2.c eq 'M' and m2.x eq a.x - 1 and m2.y eq a.y + 1.
 
numXmas += num-results('q').

/* S.M */
/* .A. */
/* S.M */
open query q preselect 
 each a where a.c eq 'A' ,
 each s1 where s1.c eq 'S' and s1.x eq a.x - 1 and s1.y eq a.y - 1,
 each m1 where m1.c eq 'M' and m1.x eq a.x + 1 and m1.y eq a.y + 1,
 each s2 where s2.c eq 'S' and s2.x eq a.x - 1 and s2.y eq a.y + 1,
 each m2 where m2.c eq 'M' and m2.x eq a.x + 1 and m2.y eq a.y - 1.
 
numXmas += num-results('q').

/* M.M */
/* .A. */
/* S.S */
open query q preselect 
 each a where a.c eq 'A' ,
 each s1 where s1.c eq 'S' and s1.x eq a.x + 1 and s1.y eq a.y + 1,
 each m1 where m1.c eq 'M' and m1.x eq a.x - 1 and m1.y eq a.y - 1,
 each s2 where s2.c eq 'S' and s2.x eq a.x - 1 and s2.y eq a.y + 1,
 each m2 where m2.c eq 'M' and m2.x eq a.x + 1 and m2.y eq a.y - 1.
 
numXmas += num-results('q').


clipboard:value = string(numXmas).
message "duration " now - nu " ms"
  skip  "numXmas " numXmas 
  view-as alert-box.

