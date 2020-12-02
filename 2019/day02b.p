define variable intcode as character  no-undo.
define variable code as integer extent  no-undo.
define variable codeoriginal as integer extent  no-undo.
define variable position as integer  no-undo.
define variable length as integer  no-undo.
DEFINE VARIABLE noun AS INTEGER     NO-UNDO.
DEFINE VARIABLE verb AS INTEGER     NO-UNDO.

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
extent(code) = length. 
extent(codeoriginal) = length. 
do position = 1 to length:
    code[position] = integer(entry(position,intcode)).
end.
codeoriginal = code.
noun:
do noun = 0 to 99:
    verb:
    do verb = 0 to 99:
        code = codeoriginal.
        code[2] = noun.
        code[3] = verb.
        1202Block:
        do position = 1 to length:
            case code[position]:
                when 1 then
                do:
                    //if code[code[position + 1] + 1] + code[code[position + 2] + 1] eq  19690720 then
                    code[code[position + 3] + 1] = code[code[position + 1] + 1] 
                                                 + code[code[position + 2] + 1].
                    position = position + 3. 
                end.
                when 2 then
                do:
                    //if code[code[position + 1] + 1] * code[code[position + 2] + 1] eq  19690720 then
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
            if code[1] eq  19690720 then
            do:
                leave noun.  
            end.
            
        end.
    end.
end.
clipboard:value = string(100 * code[2] + code[3]).
message string(100 * code[2] + code[3]) skip 
code[1] skip 
position skip
    view-as alert-box.

