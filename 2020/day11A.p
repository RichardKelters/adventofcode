
define temp-table tt no-undo
field nr      as integer   format ">>>>9"
field seat    as character format "x(1)"
field newseat as character format "x(1)"
field line    as integer   format ">>9"
field colu  as integer   format ">>9"
index knr nr
index klc line colu
.

define variable line as character   no-undo.
define variable nr as integer no-undo.
define variable i as integer format ">>>>>>>9" no-undo.
define variable colnr as integer format ">>>>>>>9" no-undo.
define variable linenr as integer format ">>>>>>>9" no-undo.
define variable change as logical no-undo.
define variable occupied as integer no-undo.

define buffer bf for tt.

input from value("2020/day11Ainput.txt").
repeat:
    import unformatted line.
    line = trim(line).
    linenr = linenr + 1.
    do colnr = 1 to length(line):
        create tt.
        assign nr         = nr + 1
               tt.nr      = nr
               tt.line    = linenr
               tt.colu    = colnr
               tt.seat    = substring(line,colnr,1)
               tt.newseat = tt.seat
               .
    end.
end.
input close.

change  = true.
FindChange:
do while change eq true:
    change = false.
    occupied = 0.
    Seats:
    for each tt:
        if tt.seat eq "." then 
            next Seats.
            
        open query q preselect each bf where bf.line gt tt.line - 2
                                         and bf.line lt tt.line + 2
                                         and bf.colu gt tt.colu - 2
                                         and bf.colu lt tt.colu + 2
                                         and bf.seat eq "#".
        case tt.seat:
            when "L" then do:
                if num-results('q') eq 0 then
                    assign
                        tt.newseat = "#"
                        occupied = occupied + 1
                        change = true.
                else
                    tt.newseat = "L".
            end.
            when "#" then do:
                if num-results('q') gt 4 then
                    assign
                        tt.newseat = "L"
                        change = true.
                else
                    assign
                        tt.newseat = "#"
                        occupied = occupied + 1.
            end.
        end case.
    end.
    if change eq false then
        leave FindChange.
    for each tt:
        tt.seat = tt.newseat.
    end.
end.


clipboard:value = string(occupied).

message  
  occupied 
view-as alert-box.

