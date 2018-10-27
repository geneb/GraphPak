'********** DemoHiLo.Bas - demo of the GraphPak Pro 2 dimensional
'                          High-Low-Close graph

'Copyright (c) 1988 Brian Giedt
'Copyright (c) 1988 Crescent Software

DEFINT A-Z

'These DECLARE statements are for QuickBASIC 4.0.  If you are using QB 2
'or QB 3, add a REMark apostrophe and also remove one of the REMark
'apostrophes from the $INCLUDE lines at the end.

DECLARE SUB GPPause ()
DECLARE SUB Prepare ()
DECLARE SUB SetFont (FontNumber%)
DECLARE SUB SetSpacing (SpacingH%, SpacingV%)
DECLARE FUNCTION GetTextWidth% (Text$)
DECLARE SUB LoadFont (FontFile$)
DECLARE SUB HighLow (GraphData!(), XTitle$(), YTitle$(), MainTitle$, Colors())
DECLARE SUB DrawText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)
DECLARE SUB SetVideo ()
DECLARE FUNCTION HercThere%

'$INCLUDE: 'Simple'     'SIMPLE.BAS contains code to determine the current
			'  installed monitor, and load and process the font
			'  and tile string arrays

CALL SetVideo   'initiate graphics (SCREEN n) based on monitor detected above

CALL SetSpacing(2, 2)

'----- Dim the arrays that will hold the data for the various graphs

REDIM GraphData!(3, 6), XTitle$(4), YTitle$(7)

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

FOR X = 1 TO 4          'read the X axis titles
    READ XTitle$(X)     'the first title is the X axis heading
NEXT
DATA SALES, Jan, Feb, Mar

FOR X = 1 TO 7
    READ YTitle$(X)
NEXT
DATA PRODUCTS
DATA Product X, Product Y, Product Z, Product A, Product B, Product C

MainTitle$ = "CRESCENT_SALES"           'the underscore forces a line break



'*****************************************************************************
REDIM Colors(7)
FOR T = 1 TO 7
    Colors(T) = T
NEXT
CALL HighLow(GraphData!(), XTitle$(), YTitle$(), MainTitle$, Colors())
'               ^           ^          ^           ^
'               ³           ³          ³           ÀÄÄÄ title at top right
'               ³           ³          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of Y-Axis titles
'               ³           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of X-Axis titles
'               ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 2 dimension data array

CALL GPPause
CALL Prepare
GPDat%(13) = 0                        'Use Lines to show High-Low graph
GPDat%(2) = 0                         'Don't tile in the background
CALL HighLow(GraphData!(), XTitle$(), YTitle$(), MainTitle$, Colors())


CALL GPPause
CLS
'********* End of demo
