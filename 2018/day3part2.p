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
DEFINE TEMP-TABLE Id NO-UNDO
  FIELD Id        AS INTEGER FORMAT "99999"
  INDEX xy Id
  .
  
INPUT FROM day3input.txt.
    REPEAT:
        IMPORT UNFORMATTED LINE.
        // #28 @ 178,504: 12x28
        ASSIGN Id    = INTEGER(SUBSTRING(LINE,INDEX(LINE,"#") + 1,INDEX(LINE," ") - INDEX(LINE,"#") - 1)).
        CREATE Id.
        ASSIGN Id.Id = Id.
    END.
INPUT CLOSE.

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
            FIND Id WHERE Id.Id EQ Claim.Id NO-ERROR.
            IF AVAILABLE Id THEN
                DELETE Id.
            FIND Id WHERE Id.Id EQ Id NO-ERROR.
            IF AVAILABLE Id THEN
                DELETE Id.
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

OPEN QUERY q PRESELECT EACH Id.
GET FIRST q.
CLIPBOARD:VALUE = STRING(Id.Id).
MESSAGE NUM-RESULTS("q")  SKIP Id.Id
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
