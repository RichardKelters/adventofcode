
define temp-table tt no-undo
field nr      as integer   format ">>9"
field row     as character 
field chair   as character format "x(3)"
field rownr   as integer   format ">>9"
field chairnr as integer   format ">>9"
field id      as integer
index knr rownr chairnr
index kid id
.
define variable line as character   no-undo.
define variable nr as integer no-undo.
define variable ID as integer no-undo.

function RowNumber returns integer (row as character):
    define variable RowNumber as integer no-undo.
    put-bits(RowNumber,1,7) = if substring(row,7,1) eq "B" then 1 else 0.
    put-bits(RowNumber,2,7) = if substring(row,6,1) eq "B" then 1 else 0.
    put-bits(RowNumber,3,7) = if substring(row,5,1) eq "B" then 1 else 0.
    put-bits(RowNumber,4,7) = if substring(row,4,1) eq "B" then 1 else 0.
    put-bits(RowNumber,5,7) = if substring(row,3,1) eq "B" then 1 else 0.
    put-bits(RowNumber,6,7) = if substring(row,2,1) eq "B" then 1 else 0.
    put-bits(RowNumber,7,7) = if substring(row,1,1) eq "B" then 1 else 0.
    return RowNumber.
end function.

function ChairNumber returns integer (chair as character):
    define variable ChairNumber as integer no-undo.
    put-bits(ChairNumber,1,3) = if substring(Chair,3,1) eq "R" then 1 else 0.
    put-bits(ChairNumber,2,3) = if substring(Chair,2,1) eq "R" then 1 else 0.
    put-bits(ChairNumber,3,3) = if substring(Chair,1,1) eq "R" then 1 else 0.
    return ChairNumber.
end function.

input from value("2020/day05Ainput.txt").
repeat:
    import unformatted line.
    if trim(line) eq "" then 
        next.
        
    create tt.
    assign nr         = nr + 1
           tt.nr      = nr
           tt.row     = substring(line,1,7)
           tt.chair   = substring(line,8,3)
           tt.rownr   = RowNumber(tt.row)
           tt.chairnr = ChairNumber(tt.chair)
           tt.id      = RowNumber(tt.row) * 8 + ChairNumber(tt.chair)
           .
    
end.
input close.

define variable firstrow as integer no-undo.
define variable lastrow as integer no-undo.

for each tt by rownr by chairnr:
    firstrow = tt.rownr.
    leave.
end.
for each tt by rownr descending by chairnr descending :
    lastrow = tt.rownr.
    leave.
end.

define buffer bf for tt.
nr = -1.
for each tt where tt.rownr gt firstrow and tt.rownr lt lastrow:
    
    if nr + 1 ne tt.chairnr then
        leave.
    ID = tt.id + 1.
    nr = if tt.chairnr eq 7 then -1 else tt.chairnr.
    
end.

clipboard:value = string(ID).

message  
  ID 
view-as alert-box.

