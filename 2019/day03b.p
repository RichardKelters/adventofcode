
define variable WirePath          as character  no-undo extent 2.
define variable i                 as integer    no-undo.
define variable position          as integer    no-undo.
define variable length            as integer    no-undo.
define variable steps             as integer    no-undo extent 2.
define variable x                 as integer    no-undo.
define variable y                 as integer    no-undo.

input from  d:\Prive\adventofcode\2019\day03ainput.txt.
    repeat:
        import unformatted WirePath[1].
        import unformatted WirePath[2].
    end.
input close.
WirePath[1] = "R75,D30,R83,U83,L12,D49,R71,U7,L72".
WirePath[2] = "U62,R66,U55,R34,D71,R55,D58,R83".
define temp-table ttWirePath no-undo
    field path  as integer  format "9"
    field key   as integer  format ">>>9"
    field x     as integer  format "->>>9"
    field y     as integer  format "->>>9"
    field steps as integer
    index pukey as primary unique path key
    index pathkey path x y
    .

function CreateTtRecord returns logical ( path as integer
                                        , key as integer
                                        , x as integer
                                        , y as integer
                                        , steps as integer):
    create ttWirePath.
    assign ttWirePath.path = path
           ttWirePath.key  = key
           ttWirePath.x    = x
           ttWirePath.y    = y
           ttWirePath.steps = steps
           .
end function.

do i = 1 to 2:

    CreateTtRecord ( i , 1 , 0 , 0 , 0 ).
    steps[1] = 0.

    length = num-entries(WirePath[i]).
    do position = 2 to length + 1:

        assign x = ttWirePath.x
               y = ttWirePath.y
               steps[2] = integer(substring(entry(position - 1,WirePath[i]),2))
               steps[1] = steps[1] + steps[2]
               .
        case substring(entry(position - 1,WirePath[i]),1,1):
            when 'U' then y = y + steps[2].
            when 'D' then y = y - steps[2].
            when 'R' then x = x + steps[2].
            when 'L' then x = x - steps[2].
        end case.
        
        CreateTtRecord ( i , position , x , y , steps[2] ).
        
    end.
end.

/*
for each ttWirePath:
    display ttWirePath.
end.
*/
define buffer one for ttWirePath.
define buffer two for ttWirePath.

function NumberOfSteps returns integer ( path as integer , key as integer , x as integer , y as integer ):
    define buffer steps for ttWirePath.
    define buffer cross for ttWirePath.
    define variable stepsx as integer    no-undo.
    define variable stepsy as integer    no-undo.
    define variable crossx as integer    no-undo.
    define variable crossy as integer    no-undo.
    define variable steps  as integer    no-undo.
    
    Steps:
    for each steps where steps.path eq path
                     and steps.key  le key:
        if steps.key gt 1 then
        do:
            for each cross where cross.path eq steps.path
                             and cross.key  le key:
                if steps.key gt 1 then
                do:
                    if  (steps.x eq stepsx and cross.x ne crossx) 
                    and  steps.x ge minimum(cross.x,crossx)
                    and  steps.x le maximum(cross.x,crossx)
                    and  cross.y ge minimum(steps.y,stepsy)
                    and  cross.y le maximum(steps.y,stepsy) then
                    do:
                        steps = steps + (absolute(crossy) - absolute(stepsy)) + (absolute(crossx) - absolute(stepsx)) .
                        find one where rowid(one) eq rowid(cross).
                        leave Steps.
                    end.
                    else   
                    if  (cross.x eq crossx and steps.x ne stepsx) 
                    and  cross.x ge minimum(steps.x,stepsx)
                    and  cross.x le maximum(steps.x,stepsx)
                    and  steps.y ge minimum(cross.y,crossy)
                    and  steps.y le maximum(cross.y,crossy) then
                    do:    
                        steps = steps + absolute(crossx) - absolute(stepsx) + absolute(crossy) - absolute(stepsy) .
                        find one where rowid(one) eq rowid(cross).
                        leave Steps.
                    end.
                end.
                assign crossx = cross.x
                       crossy = cross.y
                       .
            end.
            steps = steps + steps.steps.

        end.
        assign stepsx = steps.x
               stepsy = steps.y
               .
   end.
    
    return steps.
end function.

define variable TotalSteps as integer    no-undo.
define variable onex              as integer    no-undo.
define variable oney              as integer    no-undo.
define variable twox              as integer    no-undo.
define variable twoy              as integer    no-undo.

TotalSteps = 999999999.
for each one where one.path = 1:
  
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
               TotalSteps = minimum( TotalSteps , NumberOfSteps(1,one.key,one.x,two.y) 
                                                + NumberOfSteps(2,two.key,one.x,two.y) ).
           else   
           if  (two.x eq twox and one.x ne onex) 
           and  two.x ge minimum(one.x,onex)
           and  two.x le maximum(one.x,onex)
           and  one.y ge minimum(two.y,twoy)
           and  one.y le maximum(two.y,twoy) then
               TotalSteps = minimum( TotalSteps , NumberOfSteps(1,one.key,two.x,one.y) 
                                                + NumberOfSteps(2,two.key,two.x,one.y) ).
           //else
               //TotalSteps =
           
        end.
        assign twox = two.x
               twoy = two.y
               .    
    end.
    assign onex = one.x
           oney = one.y
           .
end.

clipboard:value = string(TotalSteps).
message TotalSteps
    view-as alert-box.

 
