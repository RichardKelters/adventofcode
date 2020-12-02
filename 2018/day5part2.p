// result of day5part1 in a function
FUNCTION ReactPolymer RETURNS INTEGER (Polymer AS LONGCHAR):
    DEFINE VARIABLE i AS INTEGER     NO-UNDO.    
    i = 1.
    React:
    DO WHILE TRUE :
        IF i + 1 GT LENGTH(Polymer) THEN
            LEAVE React.
        IF ABSOLUTE( ASC(STRING(SUBSTRING(Polymer,i,1))) - ASC(STRING(SUBSTRING(Polymer,i + 1,1))) ) EQ 32 THEN
            ASSIGN SUBSTRING(Polymer,i,2) = ""
                   i                      = MAXIMUM(i - 1,1)
                   .
        ELSE
            ASSIGN i = i + 1.
    END.  
    RETURN LENGTH(TRIM(Polymer)).
END FUNCTION.


DEFINE VARIABLE Polymer AS LONGCHAR   NO-UNDO.
COPY-LOB FILE "day5input.txt" TO OBJECT Polymer.
DEFINE VARIABLE SIZE AS INTEGER     NO-UNDO.
SIZE = LENGTH(TRIM(Polymer)).

DEFINE VARIABLE j AS INTEGER     NO-UNDO.
DO j = ASC("a") TO ASC("z") :
    SIZE = MINIMUM(Size,ReactPolymer(REPLACE(Polymer,CHR(j),""))).
END.

CLIPBOARD:VALUE = STRING(SIZE).
MESSAGE SIZE 
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
