
define temp-table tt no-undo
field id    as integer   format ">>>9"
field bag   as character format "x(30)"
field inbag as character format "x(30)"
field innr  as integer   format ">>>9"
index kid id
index kbag bag
index kinbag inbag
.

define variable line as character   no-undo.
define variable id as integer no-undo.
define variable i as integer no-undo.
define variable bag as character no-undo.
define variable inbags as character no-undo.

input from value("2020/day07Ainput.txt").
repeat:
    import unformatted line.
    line = trim(line).
    bag    = substring(line,1,index(line,"bags contain") - 2).
    inbags = substring(line,  index(line,"bags contain") + 13).
    do i = 1 to num-entries(inbags):
        create tt.
        assign id         = id + 1
               tt.id      = id
               tt.bag     = bag
               .
        if substring(entry(i,inbags),1,2) eq "no" then
            assign
                innr       = 0
                inbag      = ""
                .
        else
            assign
                innr       = integer(substring(entry(i,inbags),1,2))
                inbag      = trim(substring(entry(i,inbags),3,index(entry(i,inbags),"bag") - 4))
                .
        
    end.
    
end.
input close.

function FindBags returns integer (bag as character):
    define variable i as integer no-undo.
    define buffer tt for tt.

    for each tt where tt.bag eq bag:
        i = i + tt.innr + tt.innr * FindBags(tt.inbag).
    end.
    return i.
end function.

i = FindBags("shiny gold").

clipboard:value = string(i).

message  
  i 
view-as alert-box.

