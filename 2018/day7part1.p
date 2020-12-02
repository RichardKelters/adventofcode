    
DEFINE VARIABLE LINE  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i AS INTEGER     NO-UNDO.
DEFINE TEMP-TABLE Step NO-UNDO
    FIELD Finish AS CHARACTER
    FIELD Before AS CHARACTER
    INDEX Finish Finish
    INDEX Before Before
    .
DEFINE TEMP-TABLE Alphabet NO-UNDO
    FIELD Letter AS CHARACTER
    FIELD Place  AS INTEGER
    INDEX Letter Letter
    INDEX Place Place
    .
INPUT FROM day7input.txt.
    REPEAT:
        IMPORT UNFORMATTED LINE.
        CREATE Step.
        ASSIGN Step.Finish   = SUBSTRING(LINE,6,1)
               Step.Before   = SUBSTRING(LINE,37,1) 
               .
        FIND Alphabet WHERE Alphabet.Letter EQ Step.Finish NO-ERROR.
        IF NOT AVAILABLE Alphabet THEN
        DO:
            CREATE Alphabet.
            ASSIGN Alphabet.Letter = Step.Finish
                   .
        END.

        FIND Alphabet WHERE Alphabet.Letter EQ Step.Before NO-ERROR.
        IF NOT AVAILABLE Alphabet THEN
        DO:
            CREATE Alphabet.
            ASSIGN Alphabet.Letter = Step.Before
                   .
        END.
    END.
INPUT CLOSE.
DO i = 1 TO 6:
    FOR EACH Alphabet BY Place BY Letter : 
        FOR EACH Step WHERE Step.Before EQ Alphabet.Letter:
            Alphabet.Place = Alphabet.Place + 1.
        END.      
        Alphabet.Place = Alphabet.Place + 1.
    END.
END.
/*
FOR EACH Alphabet BY Place DESCENDING BY Letter:
    LINE = LINE + Alphabet.Letter.  
END.
*/
LINE = "".
FOR EACH Alphabet BY Place BY Letter:
    DISPLAY Alphabet.
    LINE = LINE + Alphabet.Letter.  
END.

CLIPBOARD:VALUE = LINE.
MESSAGE 
"LINE="  LINE
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
             
