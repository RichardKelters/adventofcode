/*
For example, suppose you have the following list:

1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
Each line gives the password policy and then the password. The 
password policy indicates the lowest and highest number of times 
a given letter must appear for the password to be valid. 
For example, 1-3 a means that the password must contain a at least 
1 time and at most 3 times.

In the above example, 2 passwords are valid. 
The middle password, cdefg, is not; it contains no instances of b, 
but needs at least 1. The first and third passwords are valid: they 
contain one a or nine c, both within the limits of their respective 
policies.

How many passwords are valid according to their policies?
*/

define temp-table tt no-undo
field min as integer
field max as integer
field char as character
field password as character format "x(20)"
.
define variable line as character   no-undo.

input from value("2020/day02Ainput.txt").
repeat:
    import unformatted line.
    if trim(line) eq "" then
        next.
        
    create tt.
    assign 
        tt.min   = integer(substring(line,1,index(line,"-") - 1))
        tt.max   = integer(substring(line,index(line,"-") + 1,index(line,"-")))
        tt.char     = trim(substring(line,index(line," ") + 1,1))
        tt.password = trim(substring(line,r-index(line," ") + 1))
        .
    // display tt.
end.
input close.

define variable i as integer no-undo.

for each tt:
    if (substring(tt.password,tt.min,1) eq tt.char and substring(tt.password,tt.max,1) ne tt.char)
    or (substring(tt.password,tt.min,1) ne tt.char and substring(tt.password,tt.max,1) eq tt.char)
    then
        i = i + 1.
end.

clipboard:value = string(i).

message  
  i
view-as alert-box.

