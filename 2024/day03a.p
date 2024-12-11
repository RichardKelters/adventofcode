// Scan the corrupted memory for uncorrupted mul instructions.

var char line.
var char[] muls.
var int i, multiplications.
var datetime-tz nu.
nu = now.

function isNumeric returns logical (digit as character):  
  return trim(digit,"0123456789") eq "".  
end function.

function getUncorruptedMulInstructions returns character extent (line as character):
  var int pos = 1.
  var char value1, value2.
  var char[] muls.
  
  do while index(line,"mul(",pos) gt 0:
  
    pos = index(line,"mul(",pos).

    if  index(line,",",pos) le pos + 7
    and index(line,")",pos) le pos + 11 then
    do:
      value1 = substring(line,pos + 4 ,index(line,",",pos) - pos - 4).
      value2 = substring(line,index(line,",",pos) + 1 ,index(line,")",pos) - index(line,",",pos) - 1).
      
      if isNumeric(value1)
      and isNumeric(value2) then
      do:
        extent(muls) = if extent(muls) eq ?
                       then 1 
                       else extent(muls) + 1.
        muls[extent(muls)] = substring(line,pos,index(line,")",pos) - pos + 1).
      end.

    end.
    pos += 8.
  end.
  
  return muls.
  
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

input from value("2024/day03a_input.txt").
repeat:
    import unformatted line.

    extent(muls) = ?.
    muls = getUncorruptedMulInstructions(line).

    do i = 1 to extent(muls):
      multiplications += calculateMul(muls[i]).
    end.

end.
input close.


clipboard:value = string(multiplications).
message "duration " now - nu " ms"
  skip  "multiplications " multiplications 
  view-as alert-box.


