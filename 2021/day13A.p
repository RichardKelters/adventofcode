/*
Transparent Origami
*/
define temp-table dot no-undo
field x as integer
field y as integer
index kx x 
index ky y 
.
define temp-table fold no-undo
field id as integer
field axis as character
field position as integer
index kid as primary id
.
var int64 answer .
var int i,id.
var char line .

var datetime-tz nu.
nu = now.

// read data
input from value("2021/day13input.txt").
dot:
repeat:
    import unformatted line.
    if trim(line) eq ""
    then leave dot.
    
    create dot.
    assign dot.x = integer(entry(1,line))
           dot.y = integer(entry(2,line))
           .
end.

id = 0.
fold:
repeat:
    import unformatted line.
    create fold.
    assign id += 1
           fold.id = id
           fold.axis     = substring(line,12,1) 
           fold.position = integer(substring(line,14))
           .
end.
input close.

// functions
function FoldMap return logical (axis as character , position as integer):
    define buffer dot for dot.
    define buffer bfdot for dot.
    var int newposition.
    
    if axis eq 'x'
    then for each dot where dot.x gt position:
        newposition =  position - (dot.x - position).
        if not can-find(bfdot where bfdot.x eq newposition
                                and bfdot.y eq dot.y )
        then do:
            create bfdot.
            assign bfdot.x = newposition
                   bfdot.y = dot.y.
        end.
        delete dot.
    end.
    else for each dot where dot.y gt position:
        newposition =  position - (dot.y - position).
        if not can-find(bfdot where bfdot.x eq dot.x
                                and bfdot.y eq newposition )
        then do:
            create bfdot.
            assign bfdot.x = dot.x
                   bfdot.y = newposition.
        end.
        delete dot.
    end.

end function.


// main
for each fold:
    FoldMap(fold.axis,fold.position).
    leave.
end.

open query q preselect each dot.
answer = num-results('q').
clipboard:value = string(answer).

message  
  "ms:" now - nu skip
  "answer; " answer
view-as alert-box.

