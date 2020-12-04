
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

function IsValidHeight returns logical (hgt as character):
    define variable valid  as logical   no-undo.
    define variable length as integer   no-undo.
    define variable unit   as character no-undo.
    
    length = integer(trim(hgt,"incm")) no-error.
    if error-status:error then return false.
    unit   = trim(hgt,"0123456789") no-error.
    if error-status:error then return false.
    
    case unit:
        when "in" then valid = length ge 59 and length le 76.
        when "cm" then valid = length ge 150 and length le 193.
        otherwise valid = false.
    end case.
    return valid.
end function.

function IsValidHairColor returns logical (hcl as character):
    return hcl begins "#" and length(hcl) eq 7 and trim(hcl,"#0123456789abcdef") eq "".
end function.


i = 0.
for each tt on error undo, next:
/*        
byr (Birth Year) - four digits; at least 1920 and at most 2002.
iyr (Issue Year) - four digits; at least 2010 and at most 2020.
eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
hgt (Height) - a number followed by either cm or in:
If cm, the number must be at least 150 and at most 193.
If in, the number must be at least 59 and at most 76.
hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
pid (Passport ID) - a nine-digit number, including leading zeroes.
cid (Country ID) - ignored, missing or not.
*/
    if  tt.byr gt "" and integer(tt.byr) ge 1920 and integer(tt.byr) le 2002
    and tt.iyr gt "" and integer(tt.iyr) ge 2010 and integer(tt.iyr) le 2020
    and tt.eyr gt "" and integer(tt.eyr) ge 2020 and integer(tt.eyr) le 2030
    and tt.hgt gt "" and IsValidHeight(tt.hgt)
    and tt.hcl gt "" and IsValidHairColor(tt.hcl)
    and tt.ecl gt "" and (tt.ecl eq "amb" or 
                          tt.ecl eq "blu" or 
                          tt.ecl eq "brn" or 
                          tt.ecl eq "gry" or 
                          tt.ecl eq "grn" or 
                          tt.ecl eq "hzl" or 
                          tt.ecl eq "oth")
    and tt.pid gt "" and length(tt.pid) eq 9 and trim(tt.pid,"0123456789") eq ""
    //and tt.cid gt "" 
    then
        i = i + 1.
end.

clipboard:value = string(i).

message  
  i     
view-as alert-box.

