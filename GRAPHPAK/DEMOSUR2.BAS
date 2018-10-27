'****** DemoSur2.Bas - demo of GraphPak's Plaster Casting Surfacing routines

'Copyright (c) 1988 Brian Giedt
'Copyright (c) 1988 Crescent Software

DEFINT A-Z

'These DECLARE statements are for QuickBASIC 4.0

DECLARE SUB GPPause ()
DECLARE SUB Standby ()
DECLARE SUB Prepare ()
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
'Setup GPData% Array for Plaster Casting Surface Plots
'=========================================================================
GPDat%(4) = 0       'Turn off extra boundary
GPDat%(10) = 80     'X-Axis angle
GPDat%(11) = 60     'Y-Axis angle

CALL SetSpacing(2, 2)

'=========================================================================
'Setup for surface plot
'=========================================================================
CALL Standby
REDIM GraphData!(40, 40), Colors(1600), Colr(6)
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
	Colors(Y + (X - 1) * 40) = Colr((Value! / 9) + 1)
	Value! = ABS(Value! + RND * (40 - X) / 3.5 - ((40 - X) / 7))
    NEXT
NEXT

CALL Prepare
MainTitle$ = "The Beach Front"
CALL Graph3(GraphData!(), MainTitle$, Colors(), -1)

CALL GPPause

'********* End of demo
