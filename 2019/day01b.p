function fuel returns decimal (mass as integer):
  return truncate(mass / 3,0) - 2.
end function.

define variable line as character  no-undo.
define variable fuel as integer  no-undo.
define variable fuelTotal as integer  no-undo.
/*
  fuel = 1969.
  do while fuel gt 0:
    fuel = fuel(integer(fuel)).
    if fuel gt 0 then
      fuelTotal = fuelTotal + fuel.
    MESSAGE fuel skip fuelTotal
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  end.
*/  

input from  d:\Prive\adventofcode\2019\day01ainput.txt.
repeat:
import unformatted line.
  fuel = integer(line).
  do while fuel gt 0:
    fuel = fuel(integer(fuel)).
    if fuel gt 0 then
      fuelTotal = fuelTotal + fuel.
  end.
end.
input close.

clipboard:value = string(fuelTotal).
MESSAGE fuelTotal
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

