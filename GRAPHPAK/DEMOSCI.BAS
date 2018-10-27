'****** DemoSci.Bas - demo of GraphPak's Scientific routines

'Copyright (c) 1988 Brian Giedt
'Copyright (c) 1988 Crescent Software

DEFINT A-Z

'These DECLARE statements are for QuickBASIC 4.0

DECLARE SUB GPPause ()
DECLARE SUB Prepare ()
DECLARE SUB SetSpacing (SpacingH%, SpacingV%)
DECLARE SUB SetFont (FontNumber%)
DECLARE SUB LineSci (SciData!(), XTitle$(), YTitle$(), MainTitle$, TypeOfGraph, LineType, PointType, Colors())
DECLARE SUB DrawText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)
DECLARE SUB BoxText (Text$, Colr, X, Y, J, T, FS)
DECLARE SUB SetVideo ()
DECLARE FUNCTION GetTextWidth% (Text$)
DECLARE SUB LoadFont (FontFile$)
DECLARE FUNCTION HercThere%

'=========================================================================
'Setup Screen, Fonts, Tiles, ...
'=========================================================================
'$INCLUDE: 'Simple'             'see DEMOGPAK.BAS

CALL SetVideo                   'initiate graphics using the correct Screen

'=========================================================================
'Setup GPData% Array for Scientific graphs
'=========================================================================
CALL SetSpacing(2, 2)

'=========================================================================
'Setup for Scientific graphs - Normal Scientific Graph
'=========================================================================
REDIM XTitle$(5), YTitle$(6)      'Dim arrays to hold data for the graphs
REDIM SciData!(4, 5, 2), Colors(4)

Colors(1) = 1 + 256 * (2 + 16 * 1)
Colors(2) = 2 + 256 * (2 + 16 * 3)
Colors(3) = 3 + 256 * (2 + 16 * 2)
Colors(4) = 4 + 256 * (2 + 16 * 3)

IF GPDat%(50) = 2 THEN
  FOR T = 1 TO UBOUND(Colors)
    Colors(T) = (Colors(T) \ 256) * 256 + 1
  NEXT
END IF

RESTORE Here            'the files included earlier contain DATA statements,
			'  and this guarantees the correct data will be read
Here:
DATA -29, 40, -3, -10, 14, -12, 36, 4
DATA -40, -40, 4, -4, 21, 20, 65, 20
DATA -3, -28, 3, 40, 40, -10, 89, -30
DATA -35, 12, -8, 45, 20, 30, 25, 25
DATA -45, 0, -15, 10, 15, 30, 95, 30

FOR Y = 1 TO 5
    FOR X = 1 TO 4
	READ SciData!(X, Y, 1), SciData!(X, Y, 2)
    NEXT
NEXT

XTitle$(1) = "Degrees Celcius"      'the first title is the X axis heading

YTitle$(1) = "Meters"
YTitle$(2) = "Subject A"
YTitle$(3) = "Subject B"
YTitle$(4) = "Subject C"
YTitle$(5) = "Subject D"
YTitle$(6) = "Subject E"

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
CALL LineSci(SciData!(), XTitle$(), YTitle$(), MainTitle$, TypeOfGraph, LineType, PointType, Colors())
'               ^           ^          ^           ^
'               ³           ³          ³           ³
'               ³           ³          ³           ÀÄÄÄ title at top right
'               ³           ³          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of Y-Axis titles
'               ³           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of X-Axis titles
'               ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 3 dimension data array
CALL GPPause
Colr = 14 + 1024 * 9
CALL BoxText("Prepare For_Semi-Log Graph", Colr, 0, 60, 1, 3, 10)
     'see the BoxText subprogram for the meaning of the above parameters

'=========================================================================
'Setup for Scientific graphs - Semi-Log Graph
'=========================================================================
Colors%(1) = 1   'let the below PointType statements take effect


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

CALL LineSci(SciData!(), XTitle$(), YTitle$(), MainTitle$, TypeOfGraph, LineType, PointType, Colors())
CALL GPPause
Text$ = "You can even_switch the graph_to read another way"
CALL BoxText(Text$, Colr, 0, 60, 1, 3, 18)

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

CALL LineSci(SciData!(), XTitle$(), YTitle$(), MainTitle$, TypeOfGraph, LineType, PointType, Colors())
CALL GPPause
Text$ = "The next Log-Log graph_shows how tricky_they are"
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
PointType = 3           '3 means use asterisks


CALL LineSci(SciData!(), XTitle$(), YTitle$(), MainTitle$, TypeOfGraph, LineType, PointType, Colors())



CALL GPPause
'********* End of demo
