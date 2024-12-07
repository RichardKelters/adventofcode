// How many reports with tolerance are safe?

var char line.
var int safe.
var datetime-tz nu.
nu = now.

// a report is safe when
// - The levels are either all increasing or all decreasing.
// - Any two adjacent levels differ by at least one and at most three.
function isReportSafe returns logical (levels as integer extent):
  var int i.
  
  do i = 1 to extent(levels) - 1:
  
    if levels[i] ge levels[i + 1]  then
      return false.
    
    if levels[i + 1] - levels[i] gt 3 then
      return false.
  end.
  
  return true.
  
end function.

// order levels in report from low to high based on the two outer values
function getIncreasedReport returns integer extent (line as character):
  var int[] levels.
  var int i,numLevels.
  
  numLevels =  num-entries(line," ").
  extent(levels) = numLevels.
  
  if integer(entry(1,line," ")) le integer(entry(numLevels,line," ")) then
  do i = 1 to numLevels:
    levels[i] = integer(entry(i,line," ")).
  end.
  else
  do i = numLevels to 1 by -1:
    levels[numLevels - i + 1] = integer(entry(i,line," ")).
  end.
  
  return levels.
  
end function.

// a report is safe when
// - tolerate a single bad level
function isReportSafeWithTolerance returns logical (line as character):
  var int i,numLevels.
  var char tempLine.
  
  if isReportSafe(getIncreasedReport(line)) then
    return true.
  
  numLevels = num-entries(line," ").
  
  REMOVE_EACH_LEVEL:
  do i = 1 to numLevels:
  
    tempLine = line.
    entry(i,tempLine," ") = "".
    tempLine = trim(replace(tempLine,"  "," ")).

    if isReportSafe(getIncreasedReport(tempLine)) then
      return true.
    
  end.
  
  return false.
  
end function.


input from value("2024/day02a_input.txt").
repeat:
    import unformatted line.
    assign safe += 1 when isReportSafeWithTolerance(line).
end.
input close.


clipboard:value = string(safe).
message "duration " now - nu " ms"
  skip  "safe " safe 
  view-as alert-box.

