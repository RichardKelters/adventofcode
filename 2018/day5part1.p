DEFINE VARIABLE Polymer AS LONGCHAR   NO-UNDO.
COPY-LOB FILE "day5input.txt" TO OBJECT Polymer.

//Polymer = "dabAcCaCBAcCcaDA".
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
CLIPBOARD:VALUE = STRING(LENGTH(TRIM(Polymer))).
MESSAGE LENGTH(TRIM(Polymer)) SKIP STRING(Polymer)
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
