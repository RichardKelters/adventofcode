
define temp-table tt no-undo
field nr      as integer   format ">9"
field bus     as integer   format ">>9"
field bustime as integer   format ">>>9"
index knr nr
index kbustime bustime
.

define variable line as character   no-undo.
define variable nr as integer no-undo.
define variable MyTime as integer no-undo.
define variable i as integer no-undo.
define variable f as decimal no-undo.
define variable BusTime as integer no-undo.

input from value("2020/day13Ainput.txt").
repeat:
    import unformatted line.
    line = trim(line).
    MyTime = integer(line).
    import  unformatted line.
    do i = 1 to num-entries(line):
        if entry(i,line) eq "X" then
            next.
        create tt.
        assign nr         = nr + 1
               tt.nr      = nr
               tt.bus     = integer(entry(i,line))
               .
    end.
end.
input close.
BusTime = MyTime.
for each tt:
    f = truncate(MyTime / tt.bus , 0).
    tt.bustime = integer((f + 1) * tt.bus).
end.

find first tt use-index kbustime.

i = (tt.bustime - MyTime) * tt.bus.
clipboard:value = string(i).

message  
  i 
view-as alert-box.

