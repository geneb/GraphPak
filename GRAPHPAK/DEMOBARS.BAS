'********** DemoBarS.Bas - demo of the GraphPak Pro Stacked Bar routine

'Copyright (c) 1988 Brian Giedt
'Copyright (c) 1988 Crescent Software

DEFINT A-Z

'These DECLARE statements are for QuickBASIC 4.0.  If you are using QB 2
'or QB 3, add a REMark apostrophe and also remove one of the REMark
'apostrophes from the $INCLUDE lines at the end.

DECLARE SUB GPPause ()
DECLARE SUB SetSpacing (SpacingH%, SpacingV%)
DECLARE SUB SetFont (FontNumber%)
DECLARE SUB MaxMinValue (GraphData!(), YValue%, Answer!)
DECLARE FUNCTION GetTextWidth% (Text$)
DECLARE SUB LoadFont (FontFile$)
DECLARE SUB Bars2S (GraphData!(), XTitle$(), YTitle$(), MainTitle$)
DECLARE SUB DrawText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)
DECLARE SUB SetVideo ()
DECLARE FUNCTION HercThere%

'$INCLUDE: 'Simple'     'SIMPLE.BAS contains code to determine the current
			'  installed monitor, and load and process the font
			'  and tile string arrays

CALL SetVideo   'initiate graphics (SCREEN n) based on monitor detected above


'----- Set the spacing between characters and sizes for the text demonstration

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

GPDat%(5) = 0
FOR T1 = 1 TO UBOUND(GraphData!, 2)
    AAA! = 0
    CALL MaxMinValue(GraphData!(), T1, AAA!)
    GPDat%(5) = GPDat%(5) + AAA! + .5
NEXT
GPDat%(5) = (INT(GPDat%(5) / 100) + 1) * 100
GPDat%(7) = GPDat%(5) / 10
CALL Bars2S(GraphData!(), XTitle$(), YTitle$(), MainTitle$)
'               ^           ^          ^           ^
'               �           �          �           ���� title at top right
'               �           �          ���������������� array of Y-Axis titles
'               �           ��������������������������� array of X-Axis titles
'               ��������������������������������������� 2 dimension data array
GPDat%(5) = 100
GPDat%(7) = 20


CALL GPPause
CLS
'********* End of demo
