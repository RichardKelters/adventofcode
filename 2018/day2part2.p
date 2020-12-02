
DEFINE VARIABLE LINE AS CHARACTER FORMAT "x(27)"  NO-UNDO.
DEFINE VARIABLE Word AS CHARACTER   NO-UNDO.


DEFINE TEMP-TABLE WordTable NO-UNDO
  FIELD Word AS CHARACTER

FUNCTION CompareWords RETURNS CHARACTER (FirstWord AS CHARACTER,SecondWord AS CHARACTER):
    DEFINE VARIABLE Pos        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE WordLength AS INTEGER     NO-UNDO.

    FirstWord  = TRIM(FirstWord).
    SecondWord = TRIM(SecondWord).

    WordLength = LENGTH(FirstWord).
    
    DO Pos = 1 TO WordLength:
        
        IF SUBSTRING(FirstWord,Pos,1) NE SUBSTRING(SecondWord,Pos,1) THEN
        DO:
            SUBSTRING(FirstWord,Pos,1)  = "".
            SUBSTRING(SecondWord,Pos,1) = "".
            IF FirstWord EQ SecondWord THEN
                RETURN FirstWord.
            ELSE
                RETURN "".

        END.

    END.
    RETURN "".
END FUNCTION.

INPUT FROM day2input.txt.
    Loop:
    REPEAT:
        IMPORT UNFORMATTED LINE.
        FOR EACH WordTable:
            Word = CompareWords(WordTable.Word,LINE). 
            IF Word GT "" THEN
                LEAVE Loop.
        END.
        CREATE WordTable.
        ASSIGN WordTable.Word = LINE.
    END.
INPUT CLOSE.

CLIPBOARD:VALUE = Word.
MESSAGE Word
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
