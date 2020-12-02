    
DEFINE VARIABLE LINE      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE Guard     AS INTEGER     NO-UNDO.
DEFINE VARIABLE Switch    AS DATETIME    NO-UNDO.
DEFINE VARIABLE Asleep    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE Sleep     AS INTEGER     NO-UNDO.
DEFINE VARIABLE Wake      AS INTEGER     NO-UNDO.
DEFINE VARIABLE MaxSleep  AS INTEGER     NO-UNDO.

DEFINE VARIABLE yy AS INTEGER     NO-UNDO.
DEFINE VARIABLE mo AS INTEGER     NO-UNDO.
DEFINE VARIABLE dd AS INTEGER     NO-UNDO.
DEFINE VARIABLE hh AS INTEGER     NO-UNDO.
DEFINE VARIABLE mi AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE Shift NO-UNDO
  FIELD LINE      AS CHARACTER
  FIELD Guard     AS INTEGER FORMAT "99999"
  FIELD Switch    AS DATETIME
  FIELD Asleep    AS LOGICAL
  FIELD Sleep     AS INTEGER 
  FIELD Wake      AS INTEGER
  INDEX Switch Switch
  INDEX Guard Guard Switch
  .
DEFINE TEMP-TABLE Minute NO-UNDO
  FIELD Guard     AS INTEGER FORMAT "99999"
  FIELD Minute AS INTEGER
  FIELD COUNT  AS INTEGER
  INDEX Guard Guard Minute
  INDEX COUNT COUNT
    .

INPUT FROM day4input.txt.
    REPEAT:
        IMPORT UNFORMATTED LINE.
        // #28 @ 178,504: 12x28
        ASSIGN yy     = INTEGER(SUBSTRING(LINE, 2,4))
               mo     = INTEGER(SUBSTRING(LINE, 7,2))
               dd     = INTEGER(SUBSTRING(LINE,10,2))
               hh     = INTEGER(SUBSTRING(LINE,13,2))
               mi     = INTEGER(SUBSTRING(LINE,16,2)) 
               Guard  = IF SUBSTRING(LINE,20,5) EQ "Guard" 
                        THEN INTEGER(TRIM(SUBSTRING(LINE,27,4)))
                        ELSE 0
               Asleep = INDEX(LINE,"asleep") GT 0
               
               .

        CREATE Shift.
        ASSIGN Shift.LINE    = LINE 
               Shift.Guard   = Guard
               Shift.Switch  = DATETIME(mo,dd,yy,hh,mi)
               Shift.Asleep  =  Asleep
               .
        
    END.
INPUT CLOSE.
Guard = 0.
// assign Guard
FOR EACH Shift BY Shift.Switch:
    IF Shift.Guard NE 0 
    THEN Guard = Shift.Guard.
    ELSE Shift.Guard = Guard.
END.

// count sleep per guard
FOR EACH Shift BREAK BY Shift.Guard  DESCENDING 
                     BY Shift.Switch DESCENDING
               :
    IF Shift.asleep THEN 
        ASSIGN Shift.Sleep = INTEGER(ENTRY(2,STRING(Shift.Switch,"99-99-9999 hh:mm"),":"))
               Shift.Wake  = Wake - 1
               Sleep = Sleep + Shift.Wake - Shift.Sleep
               .
    ELSE
        Wake = INTEGER(ENTRY(2,STRING(Shift.Switch,"99-99-9999 hh:mm"),":")).

END.

DEFINE VARIABLE i AS INTEGER     NO-UNDO.
// count minute occurences
FOR EACH Shift:
    IF Shift.Asleep THEN
    DO i = Shift.Sleep TO Shift.Wake:
        FIND Minute WHERE Minute.Guard EQ Shift.Guard
                      AND Minute.Minute EQ i NO-ERROR.
        IF AVAILABLE Minute THEN
            Minute.COUNT = Minute.COUNT + 1.
        ELSE
        DO:
            CREATE Minute.
            ASSIGN Minute.Guard  = Shift.Guard
                   Minute.Minute = i
                   Minute.COUNT  = 1.
        END.
    END.
END.
Minute:
FOR EACH Minute BY Minute.COUNT DESCENDING:
    LEAVE Minute.
    DISPLAY Minute.
END.
CLIPBOARD:VALUE = string(Minute.Guard * Minute.Minute).
MESSAGE 
"Answer=" Minute.Guard * Minute.Minute SKIP 
"Guard=" Minute.Guard SKIP 
"Minute=" Minute.Minute SKIP 
"Count=" Minute.COUNT
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
             
