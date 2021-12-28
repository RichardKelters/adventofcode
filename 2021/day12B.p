/*
cave paths
*/
define temp-table connection no-undo
field id as integer
field fromcave as character
field tocave as character
index kid as primary id 
index kfromcave fromcave 
.
define temp-table path no-undo
field cavelist as character
.

var int64 answer .
var int i,id.
var char line .

var datetime-tz nu.
nu = now.

// read data
input from value("2021/day12input.txt").
repeat:
    import unformatted line.
    create connection.
    assign id += 1
           connection.id = id
           connection.fromcave = entry(1,line,"-")
           connection.tocave = entry(2,line,"-")
           .
    create connection.
    assign id += 1
           connection.id = id
           connection.fromcave = entry(2,line,"-")
           connection.tocave = entry(1,line,"-")
           .
end.
input close.

// functions
function AddCaveToPath return logical (cave as character , pathlist as character):

    define buffer connection for connection.

    if cave eq "start"
    then return true.
    
    if  lookup(cave,pathlist) gt 0 
    and compare(cave,"EQ",lc(cave),"CASE-SENSITIVE") 
    then do:
        if pathlist begins "start"
        then return true.
        else pathlist = left-trim(pathlist,"x").
    end.
    
    pathlist = substitute("&1,&2",pathlist,cave).
    
    if cave eq "end"
    then do:
        create path.
        path.cavelist = pathlist.
        return true.
    end.
    
    for each connection where connection.fromcave eq cave:
        AddCaveToPath(connection.tocave,pathlist).
    end.
    
    return true.
    
end function.


// main
for each connection where connection.fromcave eq "start":
     AddCaveToPath(connection.tocave,"xstart").
end.

// main
open query q preselect each path.
answer = num-results('q').


clipboard:value = string(answer).

message  
  "ms:" now - nu skip
  "answer; " answer
view-as alert-box.

