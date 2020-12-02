    
DEFINE VARIABLE LINE  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i     AS INTEGER     NO-UNDO.
DEFINE VARIABLE MaxX  AS INTEGER     NO-UNDO.
DEFINE VARIABLE MaxY  AS INTEGER     NO-UNDO.
DEFINE VARIABLE X     AS INTEGER     NO-UNDO.
DEFINE VARIABLE Y     AS INTEGER     NO-UNDO.
DEFINE VARIABLE Score AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE Coordinates NO-UNDO
    FIELD ID AS INTEGER  FORMAT ">>>9"
    FIELD X AS INTEGER   FORMAT ">>>9"
    FIELD Y AS INTEGER    FORMAT ">>>9"
    FIELD COUNT AS INTEGER FORMAT ">>>9"
    INDEX k1 X Y
    INDEX k2 Y X
    .
DEFINE TEMP-TABLE Score NO-UNDO
    FIELD X AS INTEGER FORMAT ">>>9"
    FIELD Y AS INTEGER FORMAT ">>>9"
    FIELD ID    AS INTEGER FORMAT ">>>9"
    FIELD Score AS INTEGER FORMAT ">>>9"
    INDEX ID ID
    INDEX k1 X Y
    .
    
INPUT FROM day6input.txt.
    REPEAT:
        IMPORT UNFORMATTED LINE.
        CREATE Coordinates.
        ASSIGN i                =  i + 1
               Coordinates.ID   = i
               Coordinates.X    = INTEGER(TRIM(ENTRY(1,LINE))) 
               Coordinates.Y    = INTEGER(TRIM(ENTRY(2,LINE))) 
               MaxX             = MAXIMUM(MaxX,Coordinates.X)
               MaxY             = MAXIMUM(MaxY,Coordinates.Y)
               .
    END.
INPUT CLOSE.

DO X = 0 TO MaxX:
    DO Y = 0 TO MaxY:
        FOR EACH Coordinates:
        
            FIND Score WHERE Score.X EQ X 
                         AND Score.Y EQ Y NO-ERROR.
            IF NOT AVAILABLE Score THEN
            DO:
                CREATE Score.
                ASSIGN Score.X     = X
                       Score.Y     = Y
                       Score.Score =  MaxX + MaxY
                       .
            END.
            
            ASSIGN Score = ABSOLUTE(Coordinates.X - X) + ABSOLUTE(Coordinates.Y - Y).

            IF Score EQ Score.Score THEN
                ASSIGN Score.ID    = 0.
            IF Score LT Score.Score THEN
                ASSIGN Score.ID    = Coordinates.ID
                       Score.Score = Score
                       .
        END.
    END.
END.

FOR EACH Score BY Score.ID:
    FIND Coordinates WHERE Coordinates.ID EQ Score.ID NO-ERROR.
    IF AVAILABLE Coordinates THEN
    DO:     
        IF Score.X EQ 0 
        OR Score.Y EQ 0 
        OR Score.X EQ MaxX 
        OR Score.Y EQ Maxy THEN
            DELETE Coordinates.
        ELSE
            ASSIGN Coordinates.COUNT = Coordinates.COUNT + 1.
    END.
    
END.

FOR EACH Coordinates BY Coordinates.COUNT DESCENDING:
    LEAVE.
END.

CLIPBOARD:VALUE = string(Coordinates.COUNT).
MESSAGE 
"MaxX=" MaxX SKIP 
"MaxY=" MaxY SKIP 
"Coordinates.COUNT=" Coordinates.COUNT SKIP
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
             
