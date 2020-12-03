

define temp-table tt no-undo
field nr as integer
field tree as logical extent 31  format "#/." 
index knr nr
.
define variable line as character   no-undo.
define variable nr as integer no-undo.
define variable i as integer no-undo.

input from value("2020/day03Ainput.txt").
repeat:
    import unformatted line.
    if trim(line) eq "" then
        next.
        
    create tt.
    nr = nr + 1.
    tt.nr = nr.
    do i = 1 to 31:
        tt.tree[i] = substring(line,i,1) eq "#".
    end.
    //display tt.
end.
input close.

i = 0.

define variable pos as integer no-undo.
for each tt:
    if tt.nr = 1 then next.
    
    pos = ((tt.nr - 1) * 3) + 1.
    pos = pos modulo 31.
    pos = if pos = 0 then 31 else pos.
    
    if tt.tree[pos] then
        i = i + 1.
    //display tt.nr pos tt.tree[pos].
end.

clipboard:value = string(i).

message  
  i
view-as alert-box.

