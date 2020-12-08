
define temp-table tt no-undo
field nr     as integer   format ">>9"
field action as character format "x(3)"
field args   as integer   format "->>9"
field used   as logical
index knr nr
.

define variable line as character   no-undo.
define variable nr as integer no-undo.
define variable i as integer no-undo.
define variable accumulator as integer no-undo.

input from value("2020/day08Ainput.txt").
repeat:
    import unformatted line.
    line = trim(line).
    create tt.
    assign nr         = nr + 1
           tt.nr      = nr
           tt.action  = substring(line,1,3)
           tt.args    = integer(substring(line,5))
           .
end.
input close.

function LastStep return integer():
    define variable pos as integer no-undo.
    define buffer tt for tt.
    accumulator = 0.

    find first tt.
    do while available tt:
        assign 
            pos      = tt.nr
            tt.used  = true
            .
        if pos eq 638 then do:
            if tt.action eq "acc" then 
                accumulator =  accumulator + tt.args.
            return pos.
        end.

        case tt.action:
            when "acc" then assign
                    accumulator =  accumulator + tt.args
                    pos = pos + 1
                    .
            when "nop" then assign
                    pos = pos + 1
                    .
            when "jmp" then assign
                    pos = pos + tt.args
                    .
        end case.
        find tt where tt.nr eq pos
                  and tt.used eq false no-error.
    end.
    return pos.
end function.

function ResetUsed return logical():
    define buffer tt for tt.
    for each tt:
      tt.used = false.
    end.
    return true.
end function.

define variable LastStep as integer no-undo.
define buffer bf for tt.
for each bf:
    case bf.action:
        when "nop" then bf.action = "jmp".
        when "jmp" then bf.action = "nop".
        otherwise next.
    end case.
    LastStep = LastStep().

    if LastStep eq 638 then
        leave.
    
    ResetUsed().
    case bf.action:
        when "nop" then bf.action = "jmp".
        when "jmp" then bf.action = "nop".
    end case.
end.

clipboard:value = string(accumulator).

message  
  accumulator 
view-as alert-box.

