'********** DemoPie.Bas - demo of the GraphPak pie drawing routines

'Copyright (c) 1988 Brian Giedt
'Copyright (c) 1988 Crescent Software

DEFINT A-Z

'These DECLARE statements are for QuickBASIC 4.0.  If you are using QB 2
'or QB 3, add a REMark apostrophe and also remove one of the REMark
'apostrophes from the $INCLUDE lines at the end.

DECLARE SUB Prepare ()
DECLARE SUB GPPause ()
DECLARE SUB SetSpacing (SpacingH%, SpacingV%)
DECLARE SUB SetFont (FontNumber%)
DECLARE FUNCTION GetTextWidth% (Text$)
DECLARE SUB LoadFont (FontFile$)
DECLARE SUB DrawText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)
DECLARE SUB Pie (graphdata!(), XTitle$(), MainTitle$)
DECLARE SUB SetVideo ()
DECLARE FUNCTION HercThere%


'$INCLUDE: 'Simple'     'SIMPLE.BAS contains code to determine the current
			'  installed monitor, and load and process the font
			'  and tile string arrays

CALL SetVideo   'initiate graphics (SCREEN n) based on monitor detected above

CALL SetSpacing(2, 2)

'----- Dim the arrays that will hold the data for the various graphs

REDIM PieData!(6), PTitle$(7)

RESTORE Here            'the files included earlier contain data statements,
			'  and this guarantees the correct data will be read

FOR X = 1 TO 6          'read the data for the pie chart
    READ PieData!(X)
NEXT
Here:
DATA 11, 19, 30, 45, 78, 92

FOR X = 1 TO 7                          'read the pie chart titles
    READ PTitle$(X)
NEXT
DATA SALES, Jan, Feb, Mar, Apr, May, June

MainTitle$ = "CRESCENT_SALES"           'the underscore forces a line break


CLS
'*****************************************************************************

GPDat%(17) = 1                              'Pull out last piece of pie
GPDat%(10) = 0                              'Make a 2 dimensional pie chart
CALL Pie(PieData!(), PTitle$(), MainTitle$)

CALL GPPause
CALL Prepare
GPDat%(17) = 0                              'Don't pull out any pieces
GPDat%(10) = 60                             'Angle of 3 dimensional pie chart
CALL Pie(PieData!(), PTitle$(), MainTitle$)

CALL GPPause
CALL Prepare
GPDat%(17) = 2                              'Pull out all pieces
GPDat%(10) = 70                             'Angle of 3 dimensional pie chart
CALL Pie(PieData!(), PTitle$(), MainTitle$)

CALL GPPause
CLS
'********* End of demo
