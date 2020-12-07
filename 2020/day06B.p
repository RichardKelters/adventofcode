
define temp-table tt no-undo
field nr      as integer   format ">>>9"
field answers as character format "x(30)"
index knr nr
.
define variable line as character   no-undo.
define variable nr as integer no-undo.
define variable i as integer no-undo.
define variable answers as character no-undo.
define variable firstanswers as logical no-undo.


create tt.
assign nr         = nr + 1
       tt.nr      = nr
       firstanswers = true
       .
input from value("2020/day06Ainput.txt").
repeat:
    import unformatted line.
    line = trim(line).
    if line eq "" then do:
        create tt.
        assign nr         = nr + 1
               tt.nr      = nr
               firstanswers = true
               .
        next.
    end.
    answers = tt.answers.    
    if firstanswers then
        assign tt.answers   = line
               firstanswers = false.
    else do i = 1 to length(answers):
        if index(line,substring(answers,i,1)) eq 0 then
            tt.answers = replace(tt.answers,substring(answers,i,1),"").
    end.
end.
input close.
i = 0.
for each tt:
    i = i + length(tt.answers).
end.
clipboard:value = string(i).

message  
  i 
view-as alert-box.

