
define temp-table spoken no-undo
field nr      as integer   format ">>9"
field spoken  as character format "x(8)"
index knr nr
index kspokennr spoken nr
.
define variable line as character   no-undo.
define variable nr as integer no-undo.
define variable i as integer no-undo.

function SpokenNumber returns character (nr as integer):
    define buffer LastSpoken for spoken.
    define buffer BeforeLast for spoken.
    define variable spoken as character no-undo.

    find LastSpoken where LastSpoken.nr = nr - 1.
    spoken = "0".
    for each BeforeLast where BeforeLast.spoken eq LastSpoken.spoken
        by BeforeLast.spoken descending 
        by BeforeLast.nr descending:
        
        if BeforeLast.nr = nr - 1 then
            next.
        spoken = string(LastSpoken.nr - BeforeLast.nr).
        leave.
    end.
    return spoken.
end function.

//line = "0,3,6".
//line = "3,1,2".
line= "1,2,16,19,18,0".
etime(true).
do i = 1 to 30000000:
    //nr = nr + 1.
    create spoken.
    assign spoken.nr = i.
    if i le num-entries(line) then
        spoken.spoken = entry(i,line).
    else
        spoken.spoken = SpokenNumber(i).
           
end.



clipboard:value = spoken.spoken.
message
  spoken.spoken   skip
  etime
view-as alert-box.
// answer 24065124 it took 4091666 ms (~ 1 hour and 8 minutes)

