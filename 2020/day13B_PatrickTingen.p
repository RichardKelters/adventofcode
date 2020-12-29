
// borrowed from https://github.com/patrickTingen/AdventOfCode/blob/master/2020/Day-13/day-13b.p

DEFINE VARIABLE cTimes  AS CHARACTER NO-UNDO.
DEFINE VARIABLE i       AS INTEGER   NO-UNDO.
DEFINE VARIABLE iTime   AS INT64     NO-UNDO.
DEFINE VARIABLE iFactor AS INT64     NO-UNDO.

DEFINE TEMP-TABLE tt
  FIELD iBusNr AS INT64
  FIELD iLeave AS INT64.
var datetime-tz nu.
nu = now.
INPUT FROM "2020/day13Ainput.txt".
IMPORT ^.
IMPORT cTimes.
INPUT CLOSE. 

DO i = 1 TO NUM-ENTRIES(cTimes):
  IF ENTRY(i,cTimes) <> 'x' THEN 
  DO:
    CREATE tt.
    ASSIGN tt.iBusNr = i
           tt.iLeave = INTEGER(ENTRY(i,cTimes)).
  END.
END.

iFactor = 1.

FOR EACH tt:
  DO WHILE (iTime + tt.iBusNr) MOD tt.iLeave > 0:
    iTime = iTime + iFactor.
  END.
  iFactor = iFactor * tt.iLeave.
END.
clipboard:value = string(iTime + 1).
MESSAGE iTime + 1 skip now - nu VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
