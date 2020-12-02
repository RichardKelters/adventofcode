
define variable intcode as character  no-undo.
define variable code as integer extent  no-undo.
define variable position as integer  no-undo.
define variable length as integer  no-undo.

input from  d:\Prive\adventofcode\2019\day02ainput.txt.
repeat:
import unformatted intcode.
end.
input close.
//intcode = "1,0,0,0,99".
//intcode = "2,3,0,3,99".
//intcode = "2,4,4,5,99,0".
//intcode = "1,1,1,4,99,5,6,0,99".
length = num-entries(intcode).
extent(code) = length + 5. 
do position = 1 to length:
    code[position] = integer(entry(position,intcode)).
end.
code[2] = 12.
code[3] = 2.
1202Block:
do position = 1 to length:

    case code[position]:
        when 1 then
        do:
            code[code[position + 3] + 1] = code[code[position + 1] + 1] 
                                         + code[code[position + 2] + 1].
            position = position + 3. 
        end.
        when 2 then
        do:
            code[code[position + 3] + 1] = code[code[position + 1] + 1] 
                                         * code[code[position + 2] + 1].
            position = position + 3. 
        end.
        when 99 then
        do:
            leave 1202Block.  
        end.
        otherwise
            message code[position] skip position
                view-as alert-box.
    end case.
    
end.
clipboard:value = string(code[1]).
message code[1]
    view-as alert-box.

