'********** Bars3.Bas

'Copyright (c) 1987 Brian Giedt & Crescent Software

DEFINT A-Z

'These Declare statements are for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE SUB DrawText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)
DECLARE SUB DrawBackground3 (XTitle$(), YTitle$())
DECLARE SUB PlotCube (X%, Y%, Z!, tile$)
DECLARE SUB DisplayTitle (Title$)
DECLARE SUB SetAspect (Angle1, Angle2)
DECLARE FUNCTION GetTextWidth% (Text$)

'$INCLUDE: 'Common'

'This program creates a 3D graph of cubes of YBound items with
'XBound groupings
'
SUB Bars3 (GraphData!(), XTitle$(), YTitle$(), MainTitle$) STATIC

    'Upper Boundary's of the data
    XBound = UBOUND(GraphData!, 1)
    YBound = UBOUND(GraphData!, 2)
    IF GPDat%(19) > 0 THEN XBound = GPDat%(19)
    IF GPDat%(20) > 0 THEN YBound = GPDat%(20)
    GPDat%(45) = XBound
    GPDat%(46) = YBound

    'Set the angles to show a three dimensional graph
    CALL SetAspect(GPDat%(10), GPDat%(11))
    'Draw the Axis
    CALL DrawBackground3(XTitle$(), YTitle$())
    'Draw the Main title in upper right corner
    CALL DisplayTitle(MainTitle$)

    '$INCLUDE: 'TextColr.Bas'

    IF XBound > YBound THEN             'set bar sizes
	GPDat%(42) = (GPDat%(39) \ XBound) - 1
	GPDat%(41) = (GPDat%(39) \ YBound) - 1
	IF NOT GPDat%(60) THEN
	    GPDat%(41) = GPDat%(42)         'make bar sizes equal
	END IF
    ELSE
	GPDat%(41) = (GPDat%(39) \ YBound) - 1
	GPDat%(42) = (GPDat%(39) \ XBound) - 1
	IF NOT GPDat%(60) THEN
	    GPDat%(42) = GPDat%(41)         'make bar sizes equal
	END IF
    END IF
  
    IF GPDat%(1) THEN  'If Ok to Draw Legend Text
      'draw headings along top walls
      T3 = GetTextWidth%(XTitle$(1))
      T1 = GPDat%(37) - (GPDat%(39) + T3) * XaAspect# / 2 - GPDat%(36) * XbAspect#
      T2 = GPDat%(38) + (GPDat%(39) + T3) * XbAspect# / 2 - GPDat%(40) - GPDat%(36) * XaAspect#
      CALL DrawText(T1, T2, XTitle$(1), 90 - GPDat%(10), GPDat%(58), 1#)

      T3 = GetTextWidth%(YTitle$(1))
      T1 = GPDat%(37) + (GPDat%(39) - T3) * YaAspect# / 2 + GPDat%(36) * YbAspect#
      T2 = GPDat%(38) + (GPDat%(39) - T3) * YbAspect# / 2 - GPDat%(40) - GPDat%(36) * YaAspect#
      CALL DrawText(T1, T2, YTitle$(1), GPDat%(11) - 90, GPDat%(58), 1#)

      'position and draw all titles at angles corresponding to their cubes
      IF GPDat%(46) > 1 THEN
	  Yd = (GPDat%(39) - GPDat%(46) * GPDat%(41)) / (GPDat%(46) - 1)
      ELSE
	  Yd = 0
      END IF
      FOR S2 = 0 TO YBound - 1
	   L = GetTextWidth(YTitle$(S2 + 2))
	   T1 = GPDat%(37) - (GPDat%(39) + L) * XaAspect# + S2 * (GPDat%(41) + Yd) * YaAspect# + 2
	   T2 = GPDat%(38) + (GPDat%(39) + L + GPDat%(36)) * XbAspect# + S2 * (GPDat%(41) + Yd) * YbAspect# + 2
	   CALL DrawText(T1, T2, YTitle$(S2 + 2), 90 - GPDat%(10), TxtColor(S2 MOD MaxTileNum + 1), 1#)
      NEXT

      IF GPDat%(45) > 1 THEN
	  Xd = (GPDat%(39) - GPDat%(45) * GPDat%(42)) / (GPDat%(45) - 1)
      ELSE
	  Xd = 0
      END IF
      FOR S2 = 0 TO XBound - 1
	   T1 = GPDat%(37) + GPDat%(39) * YaAspect# - S2 * (GPDat%(42) + Xd) * XaAspect#
	   T2 = GPDat%(38) + (GPDat%(39) + GPDat%(36)) * YbAspect# + S2 * (GPDat%(42) + Xd) * XbAspect#
	   CALL DrawText(T1, T2, XTitle$(S2 + 2), GPDat%(11) - 90, GPDat%(58), 1#)
      NEXT
    END IF

    'step through GraphData!() array and plot each cube
    FOR s1 = 0 TO YBound - 1
	FOR S2 = 0 TO XBound - 1
	    CALL PlotCube(S2, s1, GraphData!(S2 + 1, s1 + 1), tile$((s1 MOD MaxTileNum) + 1))
	NEXT
    NEXT

    GPDat%(37) = 0     'We clear this variable to tell the next graph to
			'pick its own screen size.  If the user want to alter
			'it he must do so before each graph

END SUB

