'****** DemoSur1.Bas - demo of GraphPak's 3D Wire-Figure Surfacing routines

'Copyright (c) 1988 Brian Giedt
'Copyright (c) 1988 Crescent Software

DEFINT A-Z

'These DECLARE statements are for QuickBASIC 4.0

DECLARE SUB GPPause ()
DECLARE SUB Prepare ()
DECLARE SUB Standby ()
DECLARE SUB SetSpacing (SpacingH%, SpacingV%)
DECLARE SUB SetFont (FontNumber%)
DECLARE SUB Graph3 (GraphData!(), MainTitle$, Colors%(), Surface%)
DECLARE SUB DrawText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)
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
'Setup GPData% Array for Wire-Figure Surface Plots
'=========================================================================
GPDat%(10) = 80             'X-Axis Angle
GPDat%(11) = 60             'Y-Axis Angle
IF GPDat%(31) <> 4 AND GPDat%(31) <> 6 AND GPDat%(31) <> 2 THEN
  GPDat%(26) = -1             'Make borders of polygons same color as filled
  GPDat%(57) = 1
END IF

CALL SetSpacing(2, 2)


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

CALL Prepare
MainTitle$ = "The_Twister"
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
GPDat%(4) = 0            'Surface plots don't require the extra boundary
FOR Y = 1 TO 16          'create the data for graph
    FOR X = 1 TO 13
	GraphData!(X, Y) = .8 * (-20 - ABS(Y - 8) ^ 2 + ABS(X - 7) ^ 3)
    NEXT
NEXT

CALL Prepare
MainTitle$ = "One Sheet"
CALL Graph3(GraphData!(), MainTitle$, Colors(), 0)
CALL GPPause

'=========================================================================
'Setup for surface plot
'=========================================================================
CALL Standby
GPDat%(26) = 0           'Make borders of polygons white
FOR Y = 1 TO 16          'create the data for graph
    FOR X = 1 TO 13
	GraphData!(X, Y) = 75 + 50 * (SIN(7.14 * (Y / 16) - 2) + SIN(7.14 * (X / 13) - 2))
    NEXT
NEXT

CALL Prepare
MainTitle$ = "Sine Wave"
CALL Graph3(GraphData!(), MainTitle$, Colors(), 0)



CALL GPPause

'********* End of demo
