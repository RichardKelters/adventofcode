
var char line.
var int64 i.

function Compute returns int64 (line as character):
    var int64 R.
    var int64 Operand1.
    var char Operator.
    var int64 Operand2.
    var int pos.    
    
    if trim(line,"0123456789") eq "" then
        return int64(line).
        
    pos = index(line,"(").
    
    if pos gt 0 then do:
        do while index(line,"(",pos) gt 0 and index(line,"(",pos) lt index(line,")",pos):
            pos += 1.
        end.
        substring(line,pos - 1, index(line,")",pos ) - pos + 2) = string( Compute ( substring( line , pos, index(line,")",pos) - pos))).
        return Compute(line).
    end.
    
    if num-entries(line," ") eq 3 then do:
        Operand1 = int64(entry(1,line," ")).
        Operator =       entry(2,line," ").
        Operand2 = int64(entry(3,line," ")).
        case Operator:
            when "*" then R = Operand1 * Operand2.
            when "+" then R = Operand1 + Operand2.
        end case.
    end.
    else do:
        pos = 1.
        do i = 1 to 3:  
            pos = index(line," ",pos) + 1.
        end.
        substring(line,1,pos - 2) = string(Compute(substring(line,1,pos - 2))).
        return Compute(line).
    end.
        
    return R.
end function.

input from value("2020/day18Ainput.txt").
repeat:
    import unformatted line.
    i = i + Compute(line).
end.
input close.

clipboard:value = string(i).
message i 
view-as alert-box.
