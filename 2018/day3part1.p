DEFINE VARIABLE LINE AS CHARACTER   NO-UNDO.
DEFINE VARIABLE Id        AS INTEGER NO-UNDO.
DEFINE VARIABLE xPosStart AS INTEGER NO-UNDO.
DEFINE VARIABLE yPosStart AS INTEGER NO-UNDO.
DEFINE VARIABLE xLength   AS INTEGER NO-UNDO.
DEFINE VARIABLE yLength   AS INTEGER NO-UNDO.
DEFINE VARIABLE xPosEnd   AS INTEGER NO-UNDO.
DEFINE VARIABLE yPosEnd   AS INTEGER NO-UNDO.
DEFINE VARIABLE w AS INTEGER     NO-UNDO.
DEFINE VARIABLE l AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE Claim NO-UNDO
  FIELD Id        AS INTEGER FORMAT "99999"
  FIELD xPosStart AS INTEGER
  FIELD yPosStart AS INTEGER
  FIELD xLength   AS INTEGER
  FIELD yLength   AS INTEGER
  FIELD xPosEnd   AS INTEGER
  FIELD yPosEnd   AS INTEGER
  .
DEFINE TEMP-TABLE Square NO-UNDO
  FIELD xPos      AS INTEGER
  FIELD yPos      AS INTEGER
  FIELD Occupied  AS INTEGER
  INDEX xy xPos yPos
  .
  
INPUT FROM day3input.txt.
    REPEAT:
        IMPORT UNFORMATTED LINE.
        // #28 @ 178,504: 12x28
        ASSIGN Id         = INTEGER(SUBSTRING(LINE,INDEX(LINE,"#") + 1,INDEX(LINE," ") - INDEX(LINE,"#") - 1))
               xPosStart  = INTEGER(SUBSTRING(LINE,INDEX(LINE,"@") + 2,INDEX(LINE,",") - INDEX(LINE,"@") - 2))
               yPosStart  = INTEGER(SUBSTRING(LINE,INDEX(LINE,",") + 1,INDEX(LINE,":") - INDEX(LINE,",") - 1))
               xLength    = INTEGER(SUBSTRING(LINE,INDEX(LINE,":") + 2,INDEX(LINE,"x") - INDEX(LINE,":") - 2))
               yLength    = INTEGER(TRIM(SUBSTRING(LINE,INDEX(LINE,"x") + 1))) 
               xPosEnd    = xLength + xPosStart
               yPosEnd    = yLength + yPosStart
               .

        FOR EACH Claim WHERE Claim.xPosStart  LT xPosEnd
                         AND Claim.yPosStart  LT yPosEnd
                         AND Claim.xPosEnd    GT xPosStart
                         AND Claim.yPosEnd    GT yPosStart:
                    /*
                    MESSAGE 
                    SKIP Claim.xPosStart   xPosEnd
                    SKIP Claim.yPosStart   yPosEnd
                    SKIP Claim.xPosEnd     xPosStart
                    SKIP Claim.yPosEnd     yPosStart
                    SKIP xPosEnd   - Claim.xPosStart 
                    SKIP yPosEnd   - Claim.yPosStart
                    SKIP Claim.xPosEnd    - xPosStart
                    SKIP Claim.yPosEnd    - yPosStart
                    SKIP(2)  MAXIMUM(Claim.xPosStart,xPosStart) MINIMUM(Claim.xPosEnd,xPosEnd)                    
                    SKIP     MAXIMUM(Claim.yPosStart,yPosStart) MINIMUM(Claim.yPosEnd,yPosEnd)
                    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                    */
            DO w = MAXIMUM(Claim.xPosStart,xPosStart) + 1 TO MINIMUM(Claim.xPosEnd,xPosEnd):
                DO l = MAXIMUM(Claim.yPosStart,yPosStart) + 1 TO MINIMUM(Claim.yPosEnd,yPosEnd):
                    FIND Square WHERE Square.xPos = w
                                  AND Square.yPos = l NO-ERROR.
                    IF NOT AVAILABLE Square THEN
                    DO:
                        CREATE Square.
                        ASSIGN Square.xPos = w
                               Square.yPos = l
                               .
                    END.
                    Square.Occupied = Square.Occupied + 1.
                    //MESSAGE Square.xPos   Square.yPos  
                    //VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
                    
                END.
            END.
                 
        END.

        CREATE Claim.
        ASSIGN Claim.Id         = Id
               Claim.xPosStart  = xPosStart
               Claim.yPosStart  = yPosStart
               Claim.xLength    = xLength
               Claim.yLength    = yLength 
               Claim.xPosEnd    = xPosEnd
               Claim.yPosEnd    = yPosEnd
               .
        //DISPLAY Claim.Id  Claim.xPosStart  Claim.yPosStart  Claim.xPosEnd  Claim.yPosEnd.
    END.
INPUT CLOSE.

OPEN QUERY q PRESELECT EACH Square.

CLIPBOARD:VALUE = STRING(NUM-RESULTS("q")).
MESSAGE NUM-RESULTS("q")
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
