'********** ScrnDump.Bas - demos dumping any screen to any printer
'Copyright (c) 1988 Brian Giedt and Crescent Software


DEFINT A-Z
DECLARE SUB ScrnDump (SizeCode$, LPTNumber%, XLate%)
DECLARE SUB LocateLJet (Row%, Col%, LptNo%)
DECLARE FUNCTION HercThere%
'SizeCode is:

'   "300" = print to LaserJet at 300 dots per inch resolution (smallest image)
'   "150" = print to LaserJet at 150 dots per inch resolution (medium image)
'   "100" = print to LaserJet at 100 dots per inch resolution (larger image)
'   " 75" = print to LaserJet at  75 dots per inch resolution (largest image)
'      "" = print to Epson/IBM standard dot-matrix printer
'
'IMPORTANT NOTE:
'
'When using the 75 DPI resolution, you MUST provide a leading blank
'space as shown above.
'
'LPTNumber% is either 1, 2, or 3
'
'XLate% is either -1 to indicate that different colors are to be translated
'and printed as tile patterns, or 0 which means don't translate the colors.


CLS
LOCATE , , 1
PRINT "Enter the type of monitor - CGA, EGA/VGA, or Hercules (C/E/H): ";
DO
    Mon$ = UCASE$(INKEY$)
LOOP UNTIL Mon$ = "C" OR Mon$ = "E" OR Mon$ = "H"

IF Mon$ = "H" THEN                      'check if QBHERC.COM has been loaded
   IF NOT HercThere% THEN
      PRINT "Please run QBHERC.COM and start QuickBASIC again."
      END
   END IF
END IF

PRINT "Enter the type of printer (in LPT1:) - Epson/IBM or LaserJet (E/L): ";
DO
    Prn$ = UCASE$(INKEY$)
LOOP UNTIL Prn$ = "E" OR Prn$ = "L"

LptNo = 1               'send the screen to LPT1:
XLate = -1              'translate the colors into tile patterns

IF Prn$ = "L" THEN      'LaserJet or compatible printer
   DPI$ = "150"         'print it in medium resolution
ELSE
   DPI$ = ""            'Epson/IBM or compatible printer
END IF
 
IF Prn$ = "L" THEN      'print a legend
   CALL LocateLJet(57, 22, LptNo)
   OPEN "LPT" + MID$(STR$(LptNo), 2) + ":" FOR OUTPUT AS #1
   PRINT #1, "These prints were done at "; DPI$; " Dpi";
   CLOSE #1
END IF

IF Mon$ = "E" THEN      'EGA or VGA
   SCREEN 9
   LINE (0, 0)-(639, 349), 15, B
   FOR T = 0 TO 1
       FOR S = 0 TO 7
           LINE (S * 65 + 30, T * 150 + 20)-(S * 65 + 80, T * 150 + 90), S + T * 8, BF
           LINE (S * 65 + 30, T * 150 + 20)-(S * 65 + 80, T * 150 + 90), 15, B
       NEXT
   NEXT
   LOCATE 9, 5
   PRINT "Black    Blue   Green    Cyan    Red    Purple   Brown    Grey"

   LOCATE 20, 5
   PRINT "BLACK    BLUE    GREEN   CYAN    RED    PURPLE   BROWN    GREY"
  
   IF Prn$ = "L" THEN   'Prints in center of page
      CALL LocateLJet(18, 20, LptNo)
   END IF

   CALL ScrnDump(DPI$, LptNo, XLate)
   IF LptNo = -1 GOTO ErrExit
   IF Prn$ = "E" THEN GOSUB PMsg
END IF

IF Mon$ <> "H" THEN     'if it isn't a Hercules
   SCREEN 1, 0
   LINE (0, 0)-(319, 199), 3, B
   T = 0
   FOR S = 0 TO 3
       LINE (S * 65 + 30, T * 150 + 20)-(S * 65 + 80, T * 150 + 90), S + T * 8, BF
       LINE (S * 65 + 30, T * 150 + 20)-(S * 65 + 80, T * 150 + 90), 15, B
   NEXT
   LOCATE 13, 5
   PRINT "Black    Cyan     Red    White   "
  
   IF Prn$ = "L" THEN   'Prints in lower left of page
      CALL LocateLJet(35, 1, LptNo)
   END IF

   CALL ScrnDump(DPI$, LptNo, XLate)
   IF LptNo = -1 GOTO ErrExit
   IF Prn$ = "E" THEN GOSUB PMsg
END IF

IF Mon$ = "E" THEN
   SCREEN 7
   LINE (0, 0)-(319, 199), 15, B
   FOR T = 0 TO 1
       FOR S = 0 TO 7
           LINE (S * 35 + 30, T * 100 + 20)-(S * 35 + 50, T * 100 + 60), S + T * 8, BF
           LINE (S * 35 + 30, T * 100 + 20)-(S * 35 + 50, T * 100 + 60), 15, B
       NEXT
   NEXT
  
   LOCATE 9, 5
   PRINT "Blk Blu Grn Cyan Red Purp Brn Grey";
  
   LOCATE 22, 5
   PRINT "Blk Blu Grn Cyan Red Purp Brn Grey";

   IF Prn$ = "L" THEN   'Prints in upper left
      CALL LocateLJet(1, 3, LptNo)
   END IF

   CALL ScrnDump(DPI$, LptNo, XLate)
   IF LptNo = -1 GOTO ErrExit
   IF Prn$ = "E" THEN GOSUB PMsg
END IF

IF Mon$ <> "H" THEN
   SCREEN 2
   LINE (0, 0)-(639, 199), 3, B
   T = 0
   FOR S = 0 TO 1
       LINE (S * 65 + 30, T * 150 + 20)-(S * 65 + 80, T * 150 + 90), S + T * 8, BF
       LINE (S * 65 + 30, T * 150 + 20)-(S * 65 + 80, T * 150 + 90), 15, B
   NEXT
   LOCATE 13, 5
   PRINT "Black    White   "
  
   IF Prn$ = "L" THEN   'Prints in upper right of page
      CALL LocateLJet(5, 35, LptNo)
   END IF

   CALL ScrnDump(DPI$, LptNo, XLate)
   IF LptNo = -1 GOTO ErrExit
   IF Prn$ = "E" THEN GOSUB PMsg
END IF

IF Mon$ = "E" THEN
   SCREEN 8
   LINE (0, 0)-(639, 199), 15, B
   FOR T = 0 TO 1
       FOR S = 0 TO 7
           LINE (S * 65 + 30, T * 100 + 20)-(S * 65 + 80, T * 100 + 60), S + T * 8, BF
           LINE (S * 65 + 30, T * 100 + 20)-(S * 65 + 80, T * 100 + 60), 15, B
       NEXT
   NEXT
   LOCATE 9, 6
   PRINT "Black   Blue    Green   Cyan     Red    Purple   Brown   Grey"

   LOCATE 22, 6
   PRINT "BLACK   BLUE    GREEN   CYAN     RED    PURPLE   BROWN   GREY"
  
   IF Prn$ = "L" THEN   'Prints in lower right of page
      CALL LocateLJet(45, 30, LptNo)
   END IF

   CALL ScrnDump(DPI$, LptNo, XLate)
   IF LptNo = -1 GOTO ErrExit
   IF Prn$ = "E" THEN GOSUB PMsg
END IF

IF Mon$ = "H" THEN
   SCREEN 3 '*********
   LINE (0, 0)-(719, 347), 1, B
   FOR T = 0 TO 1
       LINE (S * 65 + 30, T * 150 + 20)-(S * 65 + 80, T * 150 + 90), S + T * 8, BF
       LINE (S * 65 + 30, T * 150 + 20)-(S * 65 + 80, T * 150 + 90), 15, B
   NEXT
   CIRCLE (320, 175), 200
  
   IF Prn$ = "L" THEN   'Prints in center of page
      CALL LocateLJet(18, 20, LptNo)
   END IF

   CALL ScrnDump(DPI$, LptNo, XLate)
   IF LptNo = -1 GOTO ErrExit
   IF Prn$ = "E" THEN GOSUB PMsg
END IF

IF Prn$ = "L" THEN GOSUB PMsg

END

ErrExit:
   SCREEN 0
   PLAY "L32GEC"
   PRINT "The printer is not ready!  Press any key to end ";
   X$ = INPUT$(1)
   END

PMsg:
   OPEN "LPT" + MID$(STR$(LptNo), 2) + ":" FOR OUTPUT AS #1 'formfeed printer
   PRINT #1, CHR$(12);
   CLOSE #1

   LOCATE 25, 1
   PRINT "Press any key: ";
   WHILE INKEY$ = "": WEND
RETURN
DEFSNG A-Z


SUB LocateLJet (Row%, Col%, LptNo%)
'send laserjet codes to position cursor
   Position$ = CHR$(27) + "&a" + LTRIM$(STR$(Row%)) + "r" + LTRIM$(STR$(Col%)) + "C"
   OPEN "LPT" + MID$(STR$(LptNo%), 2) + ":" FOR OUTPUT AS #1 'send esc codes
   PRINT #1, Position$;
   CLOSE #1
'Open - Print #1, - Close statements can be replaced by a simple
'Lprint if you only need LPT1:, like this -- LPRINT Position$;
END SUB

