'********** DemoLinF.Bas - demo of the GraphPak Pro 2 dimensional area chart

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
DECLARE SUB MaxMinValue (GraphData!(), YValue%, Answer!)
DECLARE FUNCTION GetTextWidth% (Text$)
DECLARE SUB LoadFont (FontFile$)
DECLARE SUB Line2F (GraphData!(), XTitle$(), YTitle$(), MainTitle$)
DECLARE SUB Line2S (GraphData!(), XTitle$(), YTitle$(), MainTitle$)
DECLARE SUB DrawText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)
DECLARE SUB SetVideo ()
DECLARE FUNCTION HercThere%

'$INCLUDE: 'Simple'     'SIMPLE.BAS contains code to determine the current
			'  installed monitor, and load and process the font
			'  and tile string arrays

CALL SetVideo   'initiate graphics (SCREEN n) based on monitor detected above

CALL SetSpacing(2, 2)

'----- Dim the arrays that will hold the data for the various graphs

REDIM GraphData!(9, 2), XTitle$(10), YTitle$(3)

RESTORE Here            'the files included earlier contain data statements,
			'  and this guarantees the correct data will be read

FOR Y = 1 TO 2          'read data for the bar and line graphs
    FOR X = 1 TO 9
	READ GraphData!(X, Y)
    NEXT
NEXT

Here:
DATA 46, 41, 32, 24, 26, 30, 34, 62, 80
DATA 42, 34, 30, 22, 12, 27, 10, 57, 72

FOR X = 1 TO 10          'read the X axis titles
    READ XTitle$(X)     'the first title is the X axis heading
NEXT
DATA SALES, Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep


FOR X = 1 TO 3
    READ YTitle$(X)
NEXT
DATA PRODUCTS
DATA Product X, Product Y

MainTitle$ = "CRESCENT_SALES"           'the underscore forces a line break

GPDat%(58) = 2
'*****************************************************************************

GPDat%(21) = -1                       'Use Full Graph Area
GPDat%(18) = -1                       'Show Area Graph's Inner Lines
CALL Line2F(GraphData!(), XTitle$(), YTitle$(), MainTitle$)
'               ^           ^          ^           ^
'               ³           ³          ³           ÀÄÄÄ title at top right
'               ³           ³          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of Y-Axis titles
'               ³           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of X-Axis titles
'               ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 2 dimension data array

CALL GPPause
CALL Prepare
GPDat%(5) = 0
FOR T1 = 1 TO UBOUND(GraphData!, 2)
    AAA! = 0
    CALL MaxMinValue(GraphData!(), T1, AAA!)
    GPDat%(5) = GPDat%(5) + AAA! + .5
NEXT
GPDat%(5) = (INT(GPDat%(5) / 100) + 1) * 100
GPDat%(7) = GPDat%(5) / 10

GPDat%(18) = -1                        'Remove Area Graph's Inner Lines
CALL Line2S(GraphData!(), XTitle$(), YTitle$(), MainTitle$)
GPDat%(5) = 100
GPDat%(7) = 25

'The lines directly below show how to create a single area graph
'
REDIM GraphData!(5, 1), XTitle$(6), YTitle$(2)
GraphData!(1, 1) = 20
GraphData!(2, 1) = -30
GraphData!(3, 1) = 80
GraphData!(4, 1) = 20
GraphData!(5, 1) = 50
XTitle$(1) = "SALES"
XTitle$(2) = "January"
XTitle$(3) = "February"
XTitle$(4) = "March"
XTitle$(5) = "April"
XTitle$(6) = "May"
YTitle$(2) = "PRODUCT X"
GPDat%(6) = -50

GPDat%(21) = 0                        'Use Full Graph Area
GPDat%(18) = -1                       'Show Area Graph's Inner Lines
CALL GPPause
CALL Prepare
CALL Line2F(GraphData!(), XTitle$(), YTitle$(), MainTitle$)
'               ^           ^          ^           ^
'               ³           ³          ³           ÀÄÄÄ title at top right
'               ³           ³          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of Y-Axis titles
'               ³           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of X-Axis titles
'               ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 2 dimension data array

CALL GPPause
CALL Prepare
GPDat%(21) = -1
GPDat%(18) = 0                        'Remove Area Graph's Inner Lines
CALL Line2F(GraphData!(), XTitle$(), YTitle$(), MainTitle$)


CALL GPPause
CLS
'********* End of demo
