'****** DemoGPro.Bas - demo of GraphPak Scientific & 3D Surfacing routines

'Copyright (c) 1988 Brian Giedt
'Copyright (c) 1988 Crescent Software

DEFINT A-Z

'These DECLARE statements are for QuickBASIC 4.0

DECLARE SUB GPPause ()
DECLARE SUB Prepare ()
DECLARE SUB Standby ()
DECLARE SUB SetColors (ForeGround%, BackGround%, Headings%, ZeroAxis%)
DECLARE SUB SetSpacing (SpacingH%, SpacingV%)
DECLARE SUB SetFont (FontNumber%)
DECLARE SUB BoxText (Text$, Colr, X, Y, J, T, FS)
DECLARE SUB DrawText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)
DECLARE SUB LineSci (SciData!(), XTitle$(), YTitle$(), MainTitle$, TypeOfGraph, LineType, PointType, Colors%())
DECLARE SUB Graph3 (GraphData!(), MainTitle$, Colors%(), SURFACE%)
DECLARE SUB SetVideo ()
DECLARE FUNCTION GetTextWidth% (Text$)
DECLARE FUNCTION MakeBinary% (Bin$)
DECLARE SUB LoadFont (FontFile$)
DECLARE FUNCTION HercThere%

'=========================================================================
'Setup Screen, Fonts, Tiles, ...
'=========================================================================
'$INCLUDE: 'Simple'             'see DEMOGPAK.BAS

CALL SetVideo                   'initiate graphics using the correct Screen

CALL SetSpacing(2, 2)

'=========================================================================
'Setup GPData% Array for Scientific graphs
'=========================================================================
GPDat%(9) = 9
GPDat%(12) = -1
CALL SetColors(GPDat%(56), 4, 2, 9)
GPDat%(61) = MakeBinary("0011001100110011")
GPDat%(62) = MakeBinary("0100010001000100")

'=========================================================================
'Setup for Scientific graphs - Normal Scientific Graph
'=========================================================================
REDIM XTitle$(4), YTitle$(7)      'Dim arrays to hold data for the graphs
REDIM SciData!(4, 6, 2), Colors%(6)

FOR T = 1 TO UBOUND(Colors)
    Colors%(T) = (T + 8) MOD GPDat%(50)
    IF (T + 8) MOD GPDat%(50) = 0 THEN Colors%(T) = 1
NEXT

RESTORE Here            'the files included earlier contain DATA statements,
			'  and this guarantees the correct data will be read
Here:
DATA -18, -20, -6, 13, -1, 0, 14, 3
DATA -29, 40, -3, -10, 14, -12, 36, 4
DATA -40, -40, 4, -4, 21, 20, 65, 20
DATA -3, -28, 3, 40, 40, -10, 89, -30
DATA -35, 12, -8, 45, 15, 30, 25, 25
DATA -45, 0, -15, 10, 15, 30, 95, 30

FOR Y = 1 TO 6
    FOR X = 1 TO 4
	READ SciData!(X, Y, 1), SciData!(X, Y, 2)
    NEXT
NEXT

XTitle$(1) = "Degrees Celcius"      'the first title is the X axis heading

YTitle$(1) = "Meters"

MainTitle$ = "MY SCIENCE_PROJECT" 'underscore forces a line break

TypeOfGraph = 0         'normal (linear) line graph
LineType = 1            'complete lines drawn when LineType = 1
PointType = 2           '2 means each point plotted is shown as circle

'Draw the normal scientific graph

GPDat%(5) = 100         'Maximum value for X axis
GPDat%(6) = -50         'Minimum value for X axis
GPDat%(7) = 10          'Number of steps for X axis
GPDat%(51) = 50         'Maximum value for Y axis
GPDat%(52) = -50        'Minimum value for Y axis
GPDat%(53) = 4          'Number of steps for Y axis

CALL Prepare
CALL LineSci(SciData!(), XTitle$(), YTitle$(), MainTitle$, TypeOfGraph, LineType, PointType, Colors%())
'               ^           ^          ^           ^
'               ³           ³          ³           ³
'               ³           ³          ³           ÀÄÄÄ title at top right
'               ³           ³          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of Y-Axis titles
'               ³           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of X-Axis titles
'               ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 3 dimension data array
CALL GPPause
Colr = 14 + 1024 * 9
CALL SetColors(GPDat%(56), 3, 0, GPDat%(55))
CALL BoxText("Prepare For_Semi-Log Graph", Colr, 0, 60, 1, 3, 20)
     'see the BoxText subprogram for the meaning of the above parameters

'=========================================================================
'Setup for Scientific graphs - Semi-Log Graph
'=========================================================================
REDIM SciData!(10, 1, 2)

'pick X values as straight numbers  - this case 0.1 .. 1.0
'calculate Y values direct from equation - this case Y = 2e^3X
FOR S1 = 1 TO 10
    SciData!(S1, 1, 1) = S1 * .1                          'values 0.1 to 1.0
    'Equation on next line is same as 2 * EXP(3 * SciData!(S1,1,1))
    SciData!(S1, 1, 2) = 2 * EXP(.3 * S1)                 'values 2.7 to 40.2
NEXT
XTitle$(1) = "This is the X axis"
YTitle$(1) = "The Y axis"
MainTitle$ = "Y = 2e^3X"

TypeOfGraph = 1         'semi-log graph
LineType = 1            '1 means full line
PointType = 1           '1 means plotted points are squares

'You may choose zeros for your maximum and minimum values and the routines
' inside LineSci will find the maximum and minimum values for you.
' You Must however specify the number of steps.  The number of steps shown
' below is a reasonable amount.
GPDat%(5) = 0           'Maximum value for X axis
GPDat%(6) = 0           'Minimum value for X axis
GPDat%(7) = 10          'Number of steps for X axis
GPDat%(51) = 0          'Maximum value for Y axis
GPDat%(52) = 0          'Minimum value for Y axis
GPDat%(53) = 4          'Number of steps for Y axis

CALL LineSci(SciData!(), XTitle$(), YTitle$(), MainTitle$, TypeOfGraph, LineType, PointType, Colors%())
CALL GPPause
Text$ = "You can even_setup semi-log graphs_the other way"
CALL SetColors(GPDat%(56), 5, 2, GPDat%(55))
CALL BoxText(Text$, Colr, 0, 60, 1, 3, 20)

'=========================================================================
'Setup for Scientific graphs - Semi-Log Graph
'=========================================================================
REDIM SciData!(10, 1, 2)

'pick X values as straight numbers  - this case 0.1 .. 1.0
'calculate Y values direct from equation - this case X = 2e^3Y
FOR S1 = 1 TO 10
    SciData!(S1, 1, 2) = S1 * .1                          'values 0.1 to 1.0
    'Equation on next line is same as 2 * EXP(3 * SciData!(S1,1,2))
    SciData!(S1, 1, 1) = 2 * EXP(.3 * S1)                 'values 2.7 to 40.2
NEXT
XTitle$(1) = "This is the Y axis"
YTitle$(1) = "The X axis"
MainTitle$ = "X = 2e^3Y"

TypeOfGraph = 3         'semi-log graph
LineType = 1            '1 means full line
PointType = 1           '1 means plotted points are squares

CALL LineSci(SciData!(), XTitle$(), YTitle$(), MainTitle$, TypeOfGraph, LineType, PointType, Colors%())
CALL GPPause
Text$ = "The next Log-Log graph_shows how complex_they are"
CALL SetColors(GPDat%(56), 1, GPDat%(58), GPDat%(55))
CALL BoxText(Text$, Colr, 0, 60, 1, 3, 20)

'=========================================================================
'Setup for Scientific graphs - Log-Log Graph
'=========================================================================
REDIM SciData!(6, 1, 2)

FOR S1 = 1 TO 6
    SciData!(S1, 1, 1) = S1 * .7 + 1                   'values 1.7 to 5.2
    SciData!(S1, 1, 2) = 2 * SciData!(S1, 1, 1) ^ 3    'values 9.8 to 281.2
NEXT
XTitle$(1) = "This is the X axis"
YTitle$(1) = "The Y axis"
MainTitle$ = "Y = 2X^3"

TypeOfGraph = 2         'Log-Log
LineType = 1            '1 means fill in the line
PointType = 0           '0 means add no extras to plotted points

CALL LineSci(SciData!(), XTitle$(), YTitle$(), MainTitle$, TypeOfGraph, LineType, PointType, Colors%())
CALL GPPause

'********** demo of GraphPak 3D Surfacing routines
'=========================================================================
'Setup GPData% Array for Surface Plots
'=========================================================================
GPDat%(4) = 0       'Turn off extra boundary
GPDat%(5) = 100     'Reset the graphing range
GPDat%(6) = 0       '
GPDat%(10) = 80     'X-Axis angle
GPDat%(11) = 60     'Y-Axis angle

'=========================================================================
'Setup for surface plot
'=========================================================================
CALL Standby
REDIM GraphData!(13, 16), Colors(208)
FOR X = 1 TO 208
     Colors(X) = ((X - 1) MOD 14) + 1
     IF GPDat%(31) < 5 THEN Colors(X) = 2
NEXT

FOR Y = 1 TO 16          'create the data for graph
    FOR X = 1 TO 13
	GraphData!(X, Y) = (16 - Y) * 2 + (13 - X) * 3
	IF X > 7 AND Y > 7 THEN GraphData!(X, Y) = (35 - GraphData!(X, Y)) * 3
    NEXT
NEXT

MainTitle$ = "The_Twister"
CALL SetColors(GPDat%(56), 2, GPDat%(58), GPDat%(55))
CALL Prepare
CALL Graph3(GraphData!(), MainTitle$, Colors(), 0)
'                ^            ^          ^      ^
'                ³            ³          ³      ÀÄÄÄÄÄÄ Graphtype
'                ³            ³          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄ Color Array
'                ³            ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Title
'                ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Data
CALL GPPause


'=========================================================================
'Setup for surface plot
'=========================================================================
CALL Standby
FOR Y = 1 TO 16          'create the data for graph
    FOR X = 1 TO 13
	GraphData!(X, Y) = .8 * (-20 - ABS(Y - 8) ^ 2 + ABS(X - 7) ^ 3)
    NEXT
NEXT
MainTitle$ = "One Sheet"
CALL SetColors(GPDat%(56), 1, GPDat%(58), GPDat%(55))
CALL Prepare
CALL Graph3(GraphData!(), MainTitle$, Colors(), 0)
CALL GPPause

'=========================================================================
'Setup for surface plot
'=========================================================================
CALL Standby
FOR Y = 1 TO 16          'create the data for graph
    FOR X = 1 TO 13
	GraphData!(X, Y) = 75 + 50 * (SIN(7.14 * (Y / 16) - 2) + SIN(7.14 * (X / 13) - 2))
    NEXT
NEXT

MainTitle$ = "Sine Wave"
CALL SetColors(GPDat%(56), 4, GPDat%(58), GPDat%(55))
CALL Prepare
CALL Graph3(GraphData!(), MainTitle$, Colors(), 0)
CALL GPPause

'=========================================================================
'Setup for surface plot type-2
'=========================================================================
CALL Standby
REDIM GraphData!(40, 40), Colors(1600), Colr(6)

'The Colr() Array is used to randomly pick colors for "The Beach Front"
Colr(1) = 1       'blue for sea water
Colr(2) = 2       'green for grass on waters edge
Colr(3) = 8       'dark gray for mineral deposits on beach front
Colr(4) = 6       'brown for dirt
Colr(5) = 10      'another green
Colr(6) = 11      'red clay in hills

FOR Y = 1 TO 40   'create the data for graph
    Value! = 3
    FOR X = 40 TO 1 STEP -1
	GraphData!(X, Y) = Value!
	Colors(Y + (X - 1) * 40) = Colr(INT((Value! / 9) + 1))
	Value! = ABS(Value! + RND * (40 - X) / 3.5 - ((40 - X) / 7))
    NEXT
NEXT

MainTitle$ = "The Beach Front"
CALL SetColors(GPDat%(56), 0, GPDat%(58), GPDat%(55))
CALL Prepare
CALL Graph3(GraphData!(), MainTitle$, Colors(), -1)
CALL GPPause

'********* End of demo
