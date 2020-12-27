
define temp-table mask no-undo
field nr      as integer   format ">>9"
field mask    as character format "x(50)"
index knr nr
.
define temp-table mem no-undo
field nr      as integer   format ">>9"
field address as integer   format ">>>>>9"
field mem     as int64     format ">>>>>>>>>>>>>>"
index knr nr
.

define variable line as character   no-undo.
define variable nr as integer no-undo.
define variable i as decimal no-undo.
define variable mem as int64 no-undo .


input from value("2020/day14Ainput.txt").
repeat:
    import unformatted line.
    line = trim(line).
    if line begins "mask" then do:
        nr = nr + 1.
        create mask.
        assign mask.nr = nr
               mask.mask = substring(line,8).
    end.
    if line begins "mem" then do:
        find first mem where mem.address = integer(substring(line,5,index(line,"]") - 5)) no-error.
        if not available mem then
            create mem.
        assign mem.nr      = nr
               mem.address = integer(substring(line,5,index(line,"]") - 5))
               mem.mem     = int64(trim(entry(2,line,"=")))
               .
    end.
end.
input close.

function ApplyMask returns int64 ( mask as character , mem as int64):
    define variable i1  as integer   no-undo.
    define variable i2  as integer   no-undo.
    define variable i64 as int64     no-undo.
    define variable i   as integer   no-undo.
    define variable bit as character no-undo.
    
    i1 = truncate( mem / exp(2,32) , 0).
    i2 = mem - i1.
    do i = 1 to length(mask):
        bit = substring(mask,37 - i,1).
        if i eq 32 then do:
            if bit eq "1" then
                i64 = exp(2,31) + i2.
            else
                i64 = i2. 
        end.
        else
        if i lt 32 then
            case bit:
                when "1" then put-bits(i2,i,1) = 1.
                when "0" then put-bits(i2,i,1) = 0.
            end case.
        else
            case bit:
                when "1" then put-bits(i1,i - 32,1) = 1.
                when "0" then put-bits(i1,i - 32,1) = 0.
            end case.
    end.
    return int64(exp(2,32) * i1 + i64).
end function.

for each mask:
    for each mem where mem.nr eq mask.nr:
        mem.mem = ApplyMask(mask.mask,mem.mem).
    end.
end.

for each mem:
    mem = mem + mem.mem.
end.


clipboard:value = string(mem).

message
  mem  
view-as alert-box.

