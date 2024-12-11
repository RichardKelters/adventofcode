// Scan the corrupted memory for uncorrupted mul instructions and for od's and dont's

var char line.
var char[] instructions.
var int i, multiplications.
var logical doe. // do=keyword, doe=dutch for do
var datetime-tz nu.
nu = now.

function isNumeric returns logical (digit as character):  
  return trim(digit,"0123456789") eq "".  
end function.

function addInstruction returns logical (instruction as character):  
  extent(instructions) = if extent(instructions) eq ?
                 then 1 
                 else extent(instructions) + 1.
  instructions[extent(instructions)] = instruction.
  return true.
end function.

// find instructions
// valid mul(xxx,yyy)
// do()
// don't()
function getUncorruptedInstructions returns log (line as character):
  var int pos = 1.
  var char value1, value2.
  
  INSTRUCTION:
  do while (   index(line,"mul(",pos)  gt 0
            or index(line,"don't()",pos) gt 0
            or index(line,"do()",pos) gt 0
           ):
    // do we need to add a don't() instruction
    if index(line,"don't()",pos) lt index(line,"do()",pos)
    or index(line,"do()",pos) eq 0 then
    do:
      if  index(line,"don't()",pos) gt 0
      and (   index(line,"don't()",pos) lt index(line,"mul(",pos)
           or index(line,"mul(",pos) eq 0
          ) then
      do:
        pos = index(line,"don't()",pos) + 7.
        addInstruction("don't()").
        next INSTRUCTION.
      end.
    end.

    // do we need to add a do() instruction
    if  index(line,"do()",pos) gt 0
    and (   index(line,"do()",pos) lt index(line,"mul(",pos)
         or index(line,"mul(",pos) eq 0
        ) then
    do:
      pos = index(line,"do()",pos) + 4.
      addInstruction("do()").
      next INSTRUCTION.
    end.

    pos = index(line,"mul(",pos).
    
    if  index(line,",",pos) le pos + 7
    and index(line,")",pos) le pos + 11 then
    do:
      value1 = substring(line,pos + 4 ,index(line,",",pos) - pos - 4).
      value2 = substring(line,index(line,",",pos) + 1 ,index(line,")",pos) - index(line,",",pos) - 1).
      
      if isNumeric(value1)
      and isNumeric(value2) then
        addInstruction(substring(line,pos,index(line,")",pos) - pos + 1)).

    end.
    
    pos += 8.
    
  end. //  INSTRUCTION
  
  return true.
  
end function.

function calculateMul returns integer (mulInput as character):
  var int mulValue,x,y.
  var char mul.
  
  mul = mulInput.
  mul = substring(mul,4).
  mul = trim(mul,"()").
  
  x = integer(entry(1,mul)).
  y = integer(entry(2,mul)).
  mulValue = x * y.

  return mulValue.
  
end function.

doe = true.

input from value("2024/day03a_input.txt").
repeat:
    import unformatted line.

    extent(instructions) = ?.
    getUncorruptedInstructions(line).

    do i = 1 to extent(instructions):
      if instructions[i] begins "do" then
        doe =  "do()" eq instructions[i].
      else do:
        if doe then
          multiplications += calculateMul(instructions[i]).
      end.
    end.

end.
input close.


clipboard:value = string(multiplications).
message "duration " now - nu " ms"
  skip  "multiplications " multiplications 
  view-as alert-box.

