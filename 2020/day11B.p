
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
define variable colnr as integer no-undo.
define variable linenr as integer no-undo.
define variable change as logical no-undo.
define variable OccupiedTotal as integer no-undo.
define variable occupied as integer no-undo.

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

function FindOccupiedSeats returns integer (line as integer , colu as integer):
    define variable occupied as integer no-undo.
    define variable colnr as integer no-undo.
    define variable linenr as integer no-undo.
    define variable i as integer no-undo.
    define buffer bf for tt.
    define buffer tt for tt.
    
    for each bf where bf.line gt line - 2
                  and bf.line lt line + 2
                  and bf.colu gt colu - 2
                  and bf.colu lt colu + 2:
        if bf.seat eq "#" then
            occupied = occupied + 1.
        else if bf.seat eq "." then
        SearchVisible:
        do i = 1 to 100:
            linenr = line + ((bf.line - line) * i).
            colnr  = colu + ((bf.colu - colu) * i).
            find tt where tt.line eq linenr 
                      and tt.colu eq colnr no-error.
            if not available tt then
                leave SearchVisible.
            else do:
                case tt.seat:
                    when "." then next SearchVisible.
                    when "#" then occupied = occupied + 1.
                end case.
                leave SearchVisible.
            end.
        end.
    end.
    
    return occupied.  
    
end function.

change  = true.
FindChange:
do while change eq true:
    change = false.
    OccupiedTotal = 0.
    Seats:
    for each tt:
        if tt.seat eq "." then 
            next Seats.
        occupied = FindOccupiedSeats(tt.line,tt.colu).   
        case tt.seat:
            when "L" then do:
                if occupied eq 0 then
                    assign
                        tt.newseat = "#"
                        OccupiedTotal = OccupiedTotal + 1
                        change = true.
                else
                    tt.newseat = "L".
            end.
            when "#" then do:
                if occupied gt 5 then
                    assign
                        tt.newseat = "L"
                        change = true.
                else
                    assign
                        tt.newseat = "#"
                        OccupiedTotal = OccupiedTotal + 1.
            end.
        end case.
    end.
    if change eq false then
        leave FindChange.
    for each tt:
        tt.seat = tt.newseat.
    end.
end.


clipboard:value = string(OccupiedTotal).

message  
  OccupiedTotal 
view-as alert-box.

