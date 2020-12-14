
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
define variable waypoint-x as integer no-undo.
define variable waypoint-y as integer no-undo.
define variable temp-waypoint-x as integer no-undo.
define variable orientation as integer no-undo.

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
waypoint-x = 10.
waypoint-y = 1.
for each tt:
    case tt.action:
        when "N" then waypoint-y = waypoint-y + tt.units.
        when "S" then waypoint-y = waypoint-y - tt.units.
        when "E" then waypoint-x = waypoint-x + tt.units.
        when "W" then waypoint-x = waypoint-x - tt.units.
        when "R" or when "L" then do:
            if tt.action eq "R" then
                //orientation = (orientation + tt.units) modulo 360.
                orientation = tt.units.
            else
                //orientation = (orientation - tt.units) modulo 360.
                orientation =      if tt.units eq  90 then 270
                              else if tt.units eq 270 then  90
                              else tt.units.

            case orientation:
                when  90 then assign temp-waypoint-x = waypoint-x
                                     waypoint-x = waypoint-y
                                     waypoint-y = temp-waypoint-x * -1
                                     .
                when 180 then assign waypoint-x = waypoint-x * -1
                                     waypoint-y = waypoint-y * -1
                                     .
                when 270 then assign temp-waypoint-x = waypoint-x
                                     waypoint-x = waypoint-y * -1
                                     waypoint-y = temp-waypoint-x
                                     .
            end case.
        end.
        when "F" then assign y = y + (tt.units * waypoint-y)
                             x = x + (tt.units * waypoint-x)
                             .
    end case.
end.

i = abs(x) + abs(y).
clipboard:value = string(i).

message  
  i
view-as alert-box.

