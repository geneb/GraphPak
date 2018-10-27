'********** DemoBar2.Bas - demo of the GraphPak 2 dimensional bar charts

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
DECLARE FUNCTION MakeBinary% (Bin$)
DECLARE SUB LoadFont (FontFile$)
DECLARE SUB Bars1 (GraphData!(), XTitle$(), MainTitle$)
DECLARE SUB Bars2 (GraphData!(), XTitle$(), YTitle$(), MainTitle$)
DECLARE SUB DrawText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)
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
DATA 72, 70, 100
DATA 20, 42, 74
DATA 34, 32, 70
DATA 42, 34, 60
DATA 22, 12, 37
DATA 10, 37, 52

FOR X = 1 TO 6          'read the data for the pie chart
    READ PieData!(X)
NEXT
DATA 11, -19, 30, -45, 78, 100

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

MainTitle$ = "CRESCENT SALES"           'the underscore forces a line break

CALL SetSpacing(2, 2)
GPDat%(25) = 1
GPDat%(55) = GPDat%(56)

'*****************************************************************************
GPDat%(6) = -50            'Set the minimum value to negative 50
CALL Bars1(PieData!(), PTitle$(), MainTitle$)
'             ^           ^           ^
'             ³           ³           ³
'             ³           ³           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ title at top right
'             ³           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ text array of titles
'             ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of graph data


CALL GPPause
CALL Prepare
GPDat%(6) = 0              'Reset the minimum value to zero
CALL Bars2(GraphData!(), XTitle$(), YTitle$(), MainTitle$)
'               ^           ^          ^           ^
'               ³           ³          ³           ÀÄÄÄ title at top right
'               ³           ³          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of Y-Axis titles
'               ³           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of X-Axis titles
'               ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 2 dimension data array


CALL GPPause
CLS
'********* End of demo