/*
Transparent Origami
*/
define temp-table pairs no-undo
field pair as character
field count as int64
.
define temp-table step no-undo like pairs.

define temp-table rules no-undo
field id as integer
field pair as character
field element as character
index kid id 
index kpair pair
.
define temp-table element no-undo
field element as character
field count as int64
index kelement element 
index kcount as primary count
.
define buffer mostcommon for element.
define buffer leastcommon for element.

var int64 answer .
var int i,id.
var char line , template .
var longchar polymer.

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
// create pairs
do i = 1 to length(template):
    find element where element.element eq substring(template,i,1).
    if not available element
    then do:
        create element.
        element.element = substring(template,i,1).
    end.
    element.count += 1.
    if i lt length(template)
    then do:
        find pairs where pairs.pair eq substring(template,i,2) no-error.
        if not available pairs
        then create pairs.
        pairs.pair = substring(template,i,2).
        pairs.count += 1.
    end.
end.

// functions
function IncrementCount return logical (element as character , count as int64):
    define buffer element for element.
    
    find element where element.element eq element.
    
    element.count += count.
    
    return true.

end function.

function AddStep return logical (pair as character , count as int64):
    define buffer step for step.
    
    find step where step.pair eq pair no-error.

    if not available step
    then create step.
        
    assign step.pair = pair
           step.count += count.
        
    return true.

end function.


function MakeStep return logical ():
    define buffer rules for rules.
    
    for each pairs:
        
        find rules where rules.pair eq pairs.pair.

        AddStep(substring(rules.pair,1,1) + rules.element , pairs.count).
        
        AddStep(rules.element + substring(rules.pair,2,1) , pairs.count).
        
        IncrementCount(rules.element , pairs.count).
        
    end.
    
    return true.

end function.

// main
do i = 1 to 40:
    empty temp-table step.
    
    MakeStep().
    
    empty temp-table pairs.
    temp-table pairs:handle:copy-temp-table(temp-table step:handle).
end.

find first leastcommon.
find last mostcommon.

answer = mostcommon.count - leastcommon.count.

clipboard:value = string(answer) .

message  
  "ms:" now - nu skip
  "answer:" answer
view-as alert-box.
