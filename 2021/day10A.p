/*
Syntax error in navigation subsystem
*/
define temp-table lines no-undo
field id as integer
field line as character
.
define temp-table chunk no-undo
field id as integer
field type as character
index kid id type
.

var int64 answer .
var int count.
var char line , unexpected .

var datetime-tz nu.
nu = now.

// read data
input from value("2021/day10input.txt").
repeat:
    import unformatted line.
    create lines.
    assign count += 1
           lines.line = line
    .
end.
input close.


function CloseChunk returns character (bracket as character):
    define buffer chunk for chunk.
    
    find last chunk.
    case bracket:
        when ")" then if chunk.type = "("  then delete chunk.
        when "]" then if chunk.type = "["  then delete chunk.
        when "}" then if chunk.type = "~{" then delete chunk.
        when ">" then if chunk.type = "<"  then delete chunk.
    end case.
    
    if available chunk
    then return bracket.
    else return "".
end function.

function CreateChunk returns logical (bracket as character):
    define buffer chunk for chunk.
    var int id.
    find last chunk no-error.
    if available chunk
    then id = chunk.id.
    create chunk.
    assign id += 1
           chunk.id = id
           chunk.type = bracket.
    return true.
end function.

function ProcesLine returns character (line as character):
    define buffer chunk for chunk.
    var int i.
    var char bracket.
    do i = 1 to length(line):
        case substring(line,i,1):
            when "(" or when "[" or when "~{" or when "<"
            then CreateChunk(substring(line,i,1)).
            otherwise do:
                bracket = CloseChunk(substring(line,i,1)).
                if bracket gt ""
                then return bracket.
            end.
        end case.
    end.
    return "".
end function.

for each lines:
    empty temp-table chunk.
    unexpected =  ProcesLine(lines.line).
    case unexpected:
        when ")" then answer += 3.
        when "]" then answer += 57.
        when "}" then answer += 1197.
        when ">" then answer += 25137.
    end case.
end.

clipboard:value = string(answer).

message  
  "ms:" now - nu skip
  "answer; " answer
view-as alert-box.

