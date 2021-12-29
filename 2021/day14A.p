/*
Transparent Origami
*/
define temp-table rules no-undo
field id as integer
field pair as character
field element as character
index kid id 
index kpair pair
.
define temp-table element no-undo
field element as character
field count as integer
index kelement element 
index kcount as primary count
.
define buffer mostcommon for element.
define buffer leastcommon for element.

var int64 answer .
var int i,id.
var char line , template .
var char polymer.

var datetime-tz nu.
nu = now.

// read data
input from value("2021/day14input.txt").
    import unformatted line.
    template = trim(line).
    // read second empty line and ignore it
    import unformatted line.
    // create rules and elements
    repeat:
        import unformatted line.
        create rules.
        assign id += 1
               rules.id = id
               rules.pair    = substring(line,1,2) 
               rules.element = substring(line,7)
               .
        if not can-find(element where element.element eq rules.element)
        then do:
            create element.
            element.element = rules.element.
        end.
    end.
input close.

// add missing elements in case they exist
do i = 1 to length(template):
    if not can-find(element where element.element eq substring(template,i,1))
    then do:
        create element.
        element.element = substring(template,i,1).
    end.
end.

// functions
function MakeStep return character (template as character):
    define buffer rules for rules.
    var char polymer.
    
    var int length , i.
    
    length = length(template).
    
    do i = 1 to length - 1:
        find rules where rules.pair eq substring(template,i,2).
        assign  polymer += substring(rules.pair,1,1)
                polymer +=           rules.element
                .
    end.
    polymer += substring(rules.pair,2,1).
    return polymer.

end function.

function CountElements return logical (polymer as character):
    define buffer element for element.
    var int length , i.
    
    length = length(polymer).
    
    do i = 1 to length:
        find element where element.element eq substring(polymer,i,1).
        element.count += 1.
    end.
    
    return true.

end function.


// main
polymer = template.
do i = 1 to 10:
    polymer = MakeStep(polymer).
end.

CountElements(polymer).

find first leastcommon.
find last mostcommon.

answer = mostcommon.count - leastcommon.count.

clipboard:value = string(answer) .

message  
  "ms:" now - nu skip
  "answer:" answer
view-as alert-box.
