    
DEFINE VARIABLE LINE  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE Score AS INTEGER     NO-UNDO.
DEFINE VARIABLE Region AS INTEGER     NO-UNDO.
DEFINE VARIABLE MaxX  AS INTEGER     NO-UNDO.
DEFINE VARIABLE MaxY  AS INTEGER     NO-UNDO.
DEFINE VARIABLE X     AS INTEGER     NO-UNDO.
DEFINE VARIABLE Y     AS INTEGER     NO-UNDO.


DEFINE TEMP-TABLE Coordinates NO-UNDO
    FIELD X AS INTEGER   FORMAT ">>>9"
    FIELD Y AS INTEGER    FORMAT ">>>9"
    INDEX k1 X Y
    INDEX k2 Y X
    .
    
INPUT FROM day6input.txt.
    REPEAT:
        IMPORT UNFORMATTED LINE.
        CREATE Coordinates.
        ASSIGN Coordinates.X    = INTEGER(TRIM(ENTRY(1,LINE))) 
               Coordinates.Y    = INTEGER(TRIM(ENTRY(2,LINE))) 
               MaxX             = MAXIMUM(MaxX,Coordinates.X)
               MaxY             = MAXIMUM(MaxY,Coordinates.Y)
               .
    END.
INPUT CLOSE.

DO X = 0 TO MaxX:
    DO Y = 0 TO MaxY:
        Score = 0.
        FOR EACH Coordinates:
            ASSIGN Score = Score + ABSOLUTE(Coordinates.X - X) + ABSOLUTE(Coordinates.Y - Y).
        END.
        IF Score LT 10000 THEN
            Region = Region + 1.
    END.
END.



CLIPBOARD:VALUE = STRING(Region).
MESSAGE 
"Region=" Region
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
             
