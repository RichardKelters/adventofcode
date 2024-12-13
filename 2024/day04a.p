// Count xmas

define temp-table xmas no-undo
field c as character
field x as integer
field y as integer
index key c x y
.
define buffer bf for xmas.
define buffer x for xmas.
define buffer m for xmas.
define buffer a for xmas.
define buffer s for xmas.

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

// S is least common character
open query q preselect 
 each s where s.c eq 'S' ,
 each a where a.c eq 'A' and a.x eq s.x + 1 and a.y eq s.y + 1,
 each m where m.c eq 'M' and m.x eq s.x + 2 and m.y eq s.y + 2, 
 each x where x.c eq 'X' and x.x eq s.x + 3 and x.y eq s.y + 3. 

numXmas += num-results('q').

open query q preselect 
 each s where s.c eq 'S' ,
 each a where a.c eq 'A' and a.x eq s.x + 1 and a.y eq s.y - 1,
 each m where m.c eq 'M' and m.x eq s.x + 2 and m.y eq s.y - 2, 
 each x where x.c eq 'X' and x.x eq s.x + 3 and x.y eq s.y - 3. 
 
numXmas += num-results('q').

open query q preselect 
 each s where s.c eq 'S' ,
 each a where a.c eq 'A' and a.x eq s.x - 1 and a.y eq s.y - 1,
 each m where m.c eq 'M' and m.x eq s.x - 2 and m.y eq s.y - 2, 
 each x where x.c eq 'X' and x.x eq s.x - 3 and x.y eq s.y - 3. 
 
numXmas += num-results('q').

open query q preselect 
 each s where s.c eq 'S' ,
 each a where a.c eq 'A' and a.x eq s.x - 1 and a.y eq s.y + 1,
 each m where m.c eq 'M' and m.x eq s.x - 2 and m.y eq s.y + 2, 
 each x where x.c eq 'X' and x.x eq s.x - 3 and x.y eq s.y + 3. 
 
numXmas += num-results('q').

open query q preselect 
 each s where s.c eq 'S' ,
 each a where a.c eq 'A' and a.x eq s.x and a.y eq s.y + 1,
 each m where m.c eq 'M' and m.x eq s.x and m.y eq s.y + 2, 
 each x where x.c eq 'X' and x.x eq s.x and x.y eq s.y + 3. 

numXmas += num-results('q').

open query q preselect 
 each s where s.c eq 'S' ,
 each a where a.c eq 'A' and a.x eq s.x + 1 and a.y eq s.y,
 each m where m.c eq 'M' and m.x eq s.x + 2 and m.y eq s.y, 
 each x where x.c eq 'X' and x.x eq s.x + 3 and x.y eq s.y. 

numXmas += num-results('q').

open query q preselect 
 each s where s.c eq 'S' ,
 each a where a.c eq 'A' and a.x eq s.x and a.y eq s.y - 1,
 each m where m.c eq 'M' and m.x eq s.x and m.y eq s.y - 2, 
 each x where x.c eq 'X' and x.x eq s.x and x.y eq s.y - 3. 

numXmas += num-results('q').

open query q preselect 
 each s where s.c eq 'S' ,
 each a where a.c eq 'A' and a.x eq s.x - 1 and a.y eq s.y,
 each m where m.c eq 'M' and m.x eq s.x - 2 and m.y eq s.y, 
 each x where x.c eq 'X' and x.x eq s.x - 3 and x.y eq s.y. 

numXmas += num-results('q').


clipboard:value = string(numXmas).
message "duration " now - nu " ms"
  skip  "numXmas " numXmas 
  view-as alert-box.

