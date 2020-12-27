
define variable line as character   no-undo.
define variable ticket as integer no-undo.
define variable i as integer no-undo .
define variable rate as integer no-undo .
define variable minticket as integer no-undo initial 1000.
define variable maxticket as integer no-undo initial 1.


input from value("2020/day16Ainput.txt").
repeat:
    import unformatted line.
    line = trim(line).
    if line matches "*or*" then do:
        line = replace(line," or ",":").
        minticket = minimum(minticket,integer(trim(entry(1,entry(2,line,":"),"-"))) ).
        maxticket = maximum(maxticket,integer(trim(entry(2,entry(3,line,":"),"-"))) ).
    end.
    
    if line begins "nearby tickets" then do while line gt "":
        import unformatted line.
        do i = 1 to num-entries(line):
            ticket = integer(trim(entry(i,line))).
            if ticket lt minticket
            or ticket gt maxticket then
                rate = rate + ticket.
        end.
    end.
    
end.
input close.


clipboard:value = string(rate).

message
  rate 
view-as alert-box.

