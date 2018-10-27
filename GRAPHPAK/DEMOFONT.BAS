'********** DemoFont.Bas - demo of the GraphPak Fonts
'

'Copyright (c) 1988 Brian Giedt
'Copyright (c) 1988 Crescent Software

DEFINT A-Z

'These DECLARE statements are for QuickBASIC 4.0.  If you are using QB 2
'or QB 3, add a REMark apostrophe and also remove one of the REMark
'apostrophes from the $INCLUDE lines at the end.

DECLARE SUB GPPause ()
DECLARE SUB SetSpacing (SpacingH%, SpacingV%)
DECLARE SUB SetFont (FontNumber%)
DECLARE SUB LoadFont (FontFile$)
DECLARE SUB DrawText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)
DECLARE SUB SetVideo ()
DECLARE FUNCTION GetTextWidth% (Text$)
DECLARE FUNCTION HercThere%


'$INCLUDE: 'SIMPLE.BAS'

CALL SetVideo   'initiate graphics (SCREEN n) based on monitor detected above

CALL SetSpacing(2, 2)

'--------- the following lines load additional fonts for the font demo

FontFile$ = "HELV12"                 'Use the HELV12.GFN Font file
CALL SetFont(1)                      'We want to make it Font number 2
CALL LoadFont(FontFile$)             'Load the font into FONT$()

FontFile$ = "HELV8"                  'Use the HELV8.GFN Font file
CALL SetFont(2)                      'We want to make it Font number 2
CALL LoadFont(FontFile$)             'Load the font into FONT$()

FontFile$ = "ICON1"                  'Use the ICON1.GFN Font file
CALL SetFont(3)                      'We want to make it Font number 2
CALL LoadFont(FontFile$)             'Load the font into FONT$()

FontFile$ = "ICON2"                  'Use the ICON2.GFN Font file
CALL SetFont(4)                      'We want to make it Font number 2
CALL LoadFont(FontFile$)             'Load the font into FONT$()

DIM Show$(4)
Show$(1) = "Helvetica 12 pt. Font"
Show$(2) = "Helvetica 8 pt. Font"
Show$(3) = "Icon Set 1"
Show$(4) = "Icon Set 2"
LineChange = 0

IF GPDat%(31) = 4 THEN
   SCREEN 2
   PRINT "Sorry!  Can't demonstrate EGA fonts on CGA resolution."
   INPUT "Would you like to use the CGA High Resolution? (Y/N): ", Qu$
   IF INSTR("Yy", LEFT$(Qu$, 1)) THEN
      GPDat%(31) = 6
      CALL SetVideo
   ELSE
      END
   END IF
END IF
IF GPDat%(31) = 6 THEN LineChange = -3

CALL SetFont(1)
FH = GPDat%(36)

FOR S1 = 1 TO 4
   CLS
   CALL SetFont(1)
   CALL DrawText((GPDat%(43) - 2 * GetTextWidth%(Show$(S1))) / 2, 5, Show$(S1), 0, 2, 2#)
   S = 3
   T1 = 0
   FOR T = 32 TO 126
       S$ = RIGHT$(STR$(T), 3) + ":"
       CALL SetFont(1)          'We must use a font that has numbers for this
       CALL DrawText(T1 * FH, S * (FH + LineChange), S$, 0, 7, 1#)
       T1 = T1 + 2
       S$ = CHR$(T)
       CALL SetFont(S1)         'Changing fonts is instantaneous (BCG)
       CALL DrawText(T1 * FH, S * (FH + LineChange), S$, 0, 15, 1#)
       T1 = T1 + 2
       IF T1 > 35 THEN
	   T1 = 0
	   S = S + 1
       END IF
   NEXT
   CALL SetFont(1)
   CALL GPPause
NEXT

'********* End of demo
