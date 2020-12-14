
define temp-table tt no-undo
field nr      as integer   format ">>>9"
field action  as character format "x(1)"
field units   as integer   format ">>9"
index knr nr
.

define variable line as character   no-undo.
define variable nr as integer no-undo.
define variable i as integer format ">>>>>>>9" no-undo.

define variable x as integer no-undo.
define variable y as integer no-undo.
define variable orientation as integer no-undo.
define variable action as character no-undo.

input from value("2020/day12Ainput.txt").
repeat:
    import unformatted line.
    line = trim(line).
    create tt.
    assign nr         = nr + 1
           tt.nr      = nr
           tt.action  = substring(line,1,1)
           tt.units   = integer(trim(substring(line,2)))
           .
end.
input close.
orientation = 0.
for each tt:
    action = tt.action.
    case action:
        when "R" then orientation = (orientation + tt.units) modulo 360.
        when "L" then orientation = (orientation - tt.units) modulo 360.
        when "F" then 
            case orientation:
                when   0 then action = "E".
                when  90 then action = "S".
                when 180 then action = "W".
                when 270 then action = "N".
            end case.
    end case.
    
    case action:
        when "N" then y = y + tt.units.
        when "S" then y = y - tt.units.
        when "E" then x = x + tt.units.
        when "W" then x = x - tt.units.
    end case.

end.
i = abs(x) + abs(y).
clipboard:value = string(i).

message  
  i
view-as alert-box.

