function fuel returns decimal (mass as integer):
  return truncate(mass / 3,0) - 2.
end function.
define variable line as character  no-undo.
define variable fuel as integer  no-undo.
define variable fuelTotal as integer  no-undo.
input from  d:\Prive\adventofcode\2019\day01ainput.txt.
repeat:
import unformatted line.
  fuel = fuel(integer(line)).
  fuelTotal = fuelTotal + fuel.
end.
input close.

clipboard:value = string(fuelTotal).
MESSAGE fuelTotal
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

