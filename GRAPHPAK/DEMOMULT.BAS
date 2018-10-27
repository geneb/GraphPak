'********** DemoMult.Bas - demo of creating multiple graphs on one screen

'Copyright (c) 1988 Brian Giedt
'Copyright (c) 1988 Crescent Software

DEFINT A-Z

'These DECLARE statements are for QuickBASIC 4.0.  If you are using QB 2
'or QB 3, add a REMark apostrophe and also remove one of the REMark
'apostrophes from the $INCLUDE lines at the end.

DECLARE SUB LeftUpper ()
DECLARE SUB RightLower ()
DECLARE SUB LeftLower ()
DECLARE SUB GPPause ()
DECLARE SUB SetSpacing (SpacingH%, SpacingV%)
DECLARE SUB Bars1 (GraphData!(), XTitle$(), MainTitle$)
DECLARE SUB Bars2 (GraphData!(), XTitle$(), YTitle$(), MainTitle$)
DECLARE SUB DrawText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)
DECLARE SUB SetFont (FontNumber%)
DECLARE FUNCTION GetTextWidth% (Text$)
DECLARE SUB LoadFont (FontFile$)
DECLARE SUB SetVideo ()
DECLARE FUNCTION HercThere%

'$INCLUDE: 'Simple'     'SIMPLE.BAS contains code to determine the current
			'  installed monitor, and load and process the font
			'  and tile string arrays

CALL SetVideo   'initiate graphics (SCREEN n) based on monitor detected above

CALL SetSpacing(2, 2)

'----- Dim the arrays that will hold the data for the various graphs

REDIM GraphData!(3, 6), PieData!(6), XTitle$(4), YTitle$(7), PTitle$(7)

RESTORE Here            'the files included earlier contain data statements,
			'  and this guarantees the correct data will be read

FOR Y = 1 TO 6          'read data for the bar and line graphs
    FOR X = 1 TO 3
	READ GraphData!(X, Y)
    NEXT
NEXT

Here:
DATA 72, 70, 98
DATA 20, 42, 74
DATA 34, 32, 70
DATA 42, 34, 60
DATA 22, 12, 37
DATA 10, 37, 52

FOR X = 1 TO 6          'read the data for the pie chart
    READ PieData!(X)
NEXT
DATA 11, 19, 30, 45, 78, 92

FOR X = 1 TO 4          'read the X axis titles
    READ XTitle$(X)     'the first title is the X axis heading
NEXT
DATA SALES, Jan, Feb, Mar

FOR X = 1 TO 7
    READ YTitle$(X)
NEXT
DATA PRODUCTS
DATA Product X, Product Y, Product Z, Product A, Product B, Product C

FOR X = 1 TO 7                          'read the pie chart titles
    READ PTitle$(X)
NEXT
DATA SALES, Jan, Feb, Mar, Apr, May, June



'*****************************************************************************


'=========================== BAR GRAPHS =====================
' The following statements will display 3 bar graphs on one screen.
' Using the information which can be found in Chapter 5 and in
' Appendix D, the screen possition is modified by the subroutines
' LeftUpper, LeftLower, and RightLower.  Text is turned off by various
' uses of the GPDat%() array.

MainTitle$ = "Bar_Graphs"
GPDat%(1) = 0                    'Don't Show Legends
GPDat%(2) = 0                    'Don't Tile the backdrops
GPDat%(8) = 0                    'Use 2D bars for the first graph
GPDat%(27) = 40                  'TextSize = 4  This is a new addition
				 ' to the GPDat%() array. See README.
CALL LeftUpper                   'Set the position to the left upper corner
CALL Bars1(PieData!(), PTitle$(), MainTitle$)
'             ^           ^           ^
'             ³           ³           ³
'             ³           ³           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ title at top right
'             ³           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ text array of titles
'             ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of graph data

GPDat%(27) = 0                   'Use default text size again
GPDat%(12) = 0                   'Don't show MainTitle$ for the rest
GPDat%(8) = -1                   'Use 3D bars for remaining graphs
CALL RightLower                  'Set the position to the right lower corner
CALL Bars1(PieData!(), PTitle$(), MainTitle$)

CALL LeftLower                   'Set the position to the left lower corner
CALL Bars2(GraphData!(), XTitle$(), YTitle$(), MainTitle$)     'same as Line2

GPDat%(12) = -1                  'Return all GPDat%() array variables to
GPDat%(1) = -1                   ' there preferred values so that any
GPDat%(2) = -1                   ' following routines will work properly

CALL GPPause
CLS

'********* End of demo
