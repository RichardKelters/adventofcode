// Day 8: Seven Segment Search

define temp-table signal no-undo
field length as integer
field pattern as character
index kline length
.

var char line , patterns , outputvalues ,a,b,c,d,e,f, digit , fourdigitoutputvalue.
var int answer , i .
var datetime-tz nu.
nu = now.


input from value("2021/day08input.txt").
repeat:
    import unformatted line.
    assign
        a = ""
        b = ""
        c = ""
        d = ""
        e = ""
        f = ""
        .
    patterns     = substring(line,1,58).
    outputvalues = substring(line,62).
    
    /*************************************/
    /*   determine each segment value    */
    /*************************************/
    
    do i =  asc("a") to asc("g"):
        // segments. number of appearances in the 'ten unique signal patterns'
        // a=8 , b=6 , c=8 , d=7 , e=4 , f=9 , g=7
        case num-entries(patterns,chr(i)) - 1:
            when 6  then b  = chr(i).
            when 4  then e  = chr(i).
            when 9  then f  = chr(i).
            when 8  then a += chr(i). // misuse variable a to contain a and c
            when 7  then d += chr(i). // misues variable d to contain d and g
        end case.
    end.
    
    // read all the ten unique signal patterns
    empty temp-table signal.
    do i = 1 to 10:
        create signal.
        assign signal.pattern = entry(i,patterns," ")
               signal.length = length(signal.pattern)
               .
    end.
    
    // number 1 of the unique patterns only contains two segments: c and f
    // f has been determined because appears 9 times (see above)
    find signal where signal.length eq 2.
    c = replace(signal.pattern,f,""). // remove f, leaves c
    a = replace(a,c,""). // remove value c from misused variable a to leave correct value of a

    // number 4 of the unique patterns only contains four segments: b, c, d and f
    // b has been determined because appears 6 times (see above)
    // f has been determined because appears 9 times (see above)
    // c has been determined with the number 1 of the unique patterns (see above)
    find signal where signal.length eq 4.
    d = replace(signal.pattern,c,"").
    d = replace(d,b,"").
    d = replace(d,f,"").


    /*************************************/
    /* all segment values are determined */
    /*************************************/
    
    
    /*************************************/
    /* determine four digit output value */
    /*************************************/

    // based on the above we can determine each value of the four digit output value
    fourdigitoutputvalue = "".
    do i = 1 to 4:
        digit = entry(i,outputvalues," ").
        case length(digit):
            // knowlegde of first part of the puzzle
            when 2 then fourdigitoutputvalue += '1'.
            when 4 then fourdigitoutputvalue += '4'.
            when 3 then fourdigitoutputvalue += '7'.
            when 7 then fourdigitoutputvalue += '8'.
            when 5 
            then do:
                // for length of 5 there are three possible value; 2, 5 or 3
                // if the digit contains an 'e' it is number 2
                // if the digit contains a 'b' it is number 5
                // else it must be number 3
                if index(digit,e) gt 0 
                then fourdigitoutputvalue += '2'.
                else if index(digit,b) gt 0 
                then fourdigitoutputvalue += '5'.
                else fourdigitoutputvalue += '3'.
            end.
            when 6 
            then do:
                // for length of 6 there are three possible value; 0, 6 or 9
                // if the digit does not contains a 'd' it is number 0
                // if the digit does not contains a 'c' it is number 6
                // else it must be number 9
                if index(digit,d) eq 0 
                then fourdigitoutputvalue += '0'.
                else if index(digit,c) eq 0 
                then fourdigitoutputvalue += '6'.
                else fourdigitoutputvalue += '9'.
            end.
        end case.
    end.
    
    // add the result to the ultimate answer and read the next line
    answer += integer(fourdigitoutputvalue ).

end.
input close.

clipboard:value = string(answer).

message  
  "ms:" now - nu skip
  "answer; " answer
view-as alert-box.

