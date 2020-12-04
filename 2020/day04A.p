
define temp-table tt no-undo
field nr as integer
field byr as character label "Birth Year"
field iyr as character label "Issue Year"
field eyr as character label "Expiration Year"
field hgt as character label "Height"
field hcl as character label "Hair Color"
field ecl as character label "Eye Color"
field pid as character label "Passport ID"
field cid as character label "Country ID" 
index knr nr
.
define variable line as character   no-undo.
define variable nr as integer no-undo.
define variable i as integer no-undo.

create tt.

input from value("2020/day04Ainput.txt").
repeat:
    import unformatted line.
    if trim(line) eq "" then do:
        create tt.
        nr = nr + 1.
        next.
    end.
        
    tt.nr = nr.
    do i = 1 to num-entries(line," "):
        case entry(1,entry(i,line," "),":"):
            when "byr" then tt.byr = entry(2,entry(i,line," "),":").
            when "iyr" then tt.iyr = entry(2,entry(i,line," "),":").
            when "eyr" then tt.eyr = entry(2,entry(i,line," "),":").
            when "hgt" then tt.hgt = entry(2,entry(i,line," "),":").
            when "hcl" then tt.hcl = entry(2,entry(i,line," "),":").
            when "ecl" then tt.ecl = entry(2,entry(i,line," "),":").
            when "pid" then tt.pid = entry(2,entry(i,line," "),":").
            when "cid" then tt.cid = entry(2,entry(i,line," "),":").
            otherwise 
            do:
                message "Error" skip line
                    view-as alert-box.
            end.
        end case.
    end.
    //display tt.
end.
input close.

i = 0.

for each tt:
    
    if  tt.byr gt ""
    and tt.iyr gt ""
    and tt.eyr gt ""
    and tt.hgt gt ""
    and tt.hcl gt ""
    and tt.ecl gt ""
    and tt.pid gt ""
    //and tt.cid gt "" 
    then
        i = i + 1.
    //display tt.nr pos tt.tree[pos].
end.

clipboard:value = string(i).

message  
  i     
view-as alert-box.

