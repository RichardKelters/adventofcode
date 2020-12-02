
define variable WirePath          as character extent 2 no-undo.
define variable i                 as integer    no-undo.
define variable position          as integer    no-undo.
define variable length            as integer    no-undo.
define variable steps             as integer    no-undo.
define variable x                 as integer    no-undo.
define variable y                 as integer    no-undo.

input from  d:\Prive\adventofcode\2019\day03ainput.txt.
    repeat:
        import unformatted WirePath[1].
        import unformatted WirePath[2].
    end.
input close.

define temp-table ttWirePath no-undo
    field path as integer
    field key  as integer
    field x    as integer
    field y    as integer
    index pukey as primary unique path key
    .

function CreateTtRecord returns logical ( path as integer
                                        , key as integer
                                        , x as integer
                                        , y as integer):
    create ttWirePath.
    assign ttWirePath.path = path
           ttWirePath.key  = key
           ttWirePath.x    = x
           ttWirePath.y    = y
           .
end function.

do i = 1 to 2:

    CreateTtRecord ( i , 1 , 0 , 0 ).

    length = num-entries(WirePath[i]).
    do position = 2 to length + 1:

        assign x = ttWirePath.x
               y = ttWirePath.y
               steps = integer(substring(entry(position - 1,WirePath[i]),2))
               .
        case substring(entry(position - 1,WirePath[i]),1,1):
            when 'U' then y = y + steps.
            when 'D' then y = y - steps.
            when 'R' then x = x + steps.
            when 'L' then x = x - steps.
        end case.
        
        CreateTtRecord ( i , position , x , y ).
        
    end.
end.
/*    
for each ttWirePath:
    display ttWirePath.
end.
*/
define buffer one for ttWirePath.
define buffer two for ttWirePath.
define variable ManhattanDistance as integer    no-undo.
define variable onex              as integer    no-undo.
define variable oney              as integer    no-undo.
define variable twox              as integer    no-undo.
define variable twoy              as integer    no-undo.

ManhattanDistance = 999999999.
for each one where path = 1:
  
    if one.key gt 1 then
    for each two where two.path = 2:
        if two.key gt 1 then
        do:
           // ignore parallel lines
           if  (one.x eq onex and two.x ne twox) 
           and  one.x ge minimum(two.x,twox)
           and  one.x le maximum(two.x,twox)
           and  two.y ge minimum(one.y,oney)
           and  two.y le maximum(one.y,oney) then
               ManhattanDistance = minimum(ManhattanDistance,absolute(one.x) + absolute(two.y)).
               
           if  (two.x eq twox and one.x ne onex) 
           and  two.x ge minimum(one.x,onex)
           and  two.x le maximum(one.x,onex)
           and  one.y ge minimum(two.y,twoy)
           and  one.y le maximum(two.y,twoy) then
               ManhattanDistance = minimum(ManhattanDistance,absolute(one.y) + absolute(two.x)).
           
        end.
        assign twox = two.x
               twoy = two.y
               .    
    end.
    assign onex = one.x
           oney = one.y
           .
end.

clipboard:value = string(ManhattanDistance).
message ManhattanDistance
    view-as alert-box.

 
