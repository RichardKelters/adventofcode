DEFINE VARIABLE Doubles AS INTEGER     NO-UNDO.
DEFINE VARIABLE Triples AS INTEGER     NO-UNDO.
DEFINE VARIABLE LINE AS CHARACTER FORMAT "x(27)"  NO-UNDO.


FUNCTION ContainsMultiple RETURNS LOGICAL (Word AS CHARACTER,COUNT AS INTEGER):
    DEFINE VARIABLE Pos        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE WordLength AS INTEGER     NO-UNDO.

    Word  = TRIM(Word).

    WordLength = LENGTH(Word).
    
    DO Pos = 1 TO WordLength:
        
        IF LENGTH(REPLACE(Word,SUBSTRING(Word,Pos,1),"")) EQ WordLength - COUNT THEN
            RETURN TRUE.

    END.
    RETURN FALSE.
END FUNCTION.

INPUT FROM day2input.txt.
    Loop:
    REPEAT:
        IMPORT UNFORMATTED LINE.
        IF ContainsMultiple(Line,2) THEN Doubles = Doubles + 1.
        IF ContainsMultiple(Line,3) THEN Triples = Triples + 1.
    END.
INPUT CLOSE.

CLIPBOARD:VALUE = STRING(Triples * Doubles).
MESSAGE Triples * Doubles
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
