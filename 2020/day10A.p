
define temp-table tt no-undo
field nr      as integer   format ">>>9"
field joltage as integer   format ">>>9"
index kjoltage joltage
.

define variable line as character   no-undo.
define variable nr as integer no-undo.
define variable i as integer no-undo.
define variable jolt-1 as integer no-undo.
define variable jolt-3 as integer no-undo.
define variable joltage as integer no-undo.

input from value("2020/day10Ainput.txt").
repeat:
    import unformatted line.
    line = trim(line).
    create tt.
    assign nr         = nr + 1
           tt.nr      = nr
           tt.joltage = integer(trim(line))
           .
end.
input close.
joltage = 0.
jolt-1  = 0.
jolt-3  = 1.
for each tt:
    case tt.joltage - joltage:
        when 1 then assign jolt-1  = jolt-1  + 1
                           joltage = tt.joltage.
        when 2 then assign joltage = tt.joltage.
        when 3 then assign jolt-3  = jolt-3  + 1
                           joltage = tt.joltage.
        otherwise message "error" view-as alert-box.
    end case.
end.

i = jolt-1 * jolt-3.
clipboard:value = string(i).

message  
  i
view-as alert-box.

