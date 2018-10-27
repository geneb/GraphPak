'********** Line3.Bas - draws a complete 3D line graph

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'These Declare statements are for QuickBASIC 4.0 - see DEMO.BAS

DECLARE SUB DrawBackground3 (XTitle$(), YTitle$())
DECLARE SUB DrawText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)
DECLARE SUB DisplayTitle (Title$)
DECLARE FUNCTION GetTextWidth% (Text$)
DECLARE SUB SetAspect (Angle1%, Angle2%)
DECLARE SUB PlotLine3 (X%, Y%, Z!, ZOld!, tile$)
DECLARE SUB StepText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)

'$INCLUDE: 'Common'

'This program creates a 3D line graph of XBound Items with YBound groupings
'
SUB Line3 (GraphData!(), XTitle$(), YTitle$(), MainTitle$) STATIC

    'Upper Boundary's of the data
    XBound = UBOUND(GraphData!, 1)
    YBound = UBOUND(GraphData!, 2)
    IF GPDat%(19) > 0 THEN XBound = GPDat%(19)
    IF GPDat%(20) > 0 THEN YBound = GPDat%(20)
    GPDat%(45) = XBound
    GPDat%(46) = YBound
   
    'Set the angles to show a three dimensional graph
    GPDat%(11) = 90
    CALL SetAspect(GPDat%(10), GPDat%(11))

    'Here we can set the size and position of the graph.  Because we set these
    'variables before the call to DrawAxis3, these settings will be used
    'instead of the presets.
    IF GPDat%(37) = 0 THEN
      IF GPDat%(31) = 2 OR GPDat%(31) = 5 THEN          'EGA or Hercules
	GPDat%(37) = 240: GPDat%(38) = 150
	GPDat%(39) = 190: GPDat%(40) = 100
      ELSEIF GPDat%(31) = 8 THEN                         'VGA
	GPDat%(37) = 240: GPDat%(38) = 200
	GPDat%(39) = 220: GPDat%(40) = 170
      ELSEIF GPDat%(31) = 6 THEN                         'CGA 2 color mode
	GPDat%(37) = 240: GPDat%(38) = 80
	GPDat%(39) = 120: GPDat%(40) = 58
      ELSE                                                'CGA 4 color mode
	GPDat%(37) = 132: GPDat%(38) = 90
	GPDat%(39) = 95: GPDat%(40) = 70
      END IF
    END IF
    'Draw the Axis
    CALL DrawBackground3(XTitle$(), YTitle$())
    'Draw the Main title in upper right corner
    CALL DisplayTitle(MainTitle$)

    '$INCLUDE: 'TextColr.Bas'           'this gives text an appropriate color
					'  based on the corresponding tile

    GPDat%(41) = GPDat%(39) \ YBound - 1
    GPDat%(42) = GPDat%(39) \ (XBound - 1) - 1

    IF GPDat%(1) THEN
      'draw group heading along top wall
      T3 = GetTextWidth%(YTitle$(1))
      T1 = GPDat%(37) - (GPDat%(39) + T3) * XaAspect# / 2 - GPDat%(36) * XbAspect#
      T2 = GPDat%(38) + (GPDat%(39) + T3) * XbAspect# / 2 - GPDat%(40) - GPDat%(36) * XaAspect#
      CALL DrawText(T1, T2, YTitle$(1), 90 - GPDat%(10), GPDat%(58), 1#)

      'draw heading along side wall
      T3 = GetTextWidth%(XTitle$(1))
      T1 = GPDat%(37) + (GPDat%(39) - T3) / 2
      T2 = GPDat%(38) - GPDat%(40) - GPDat%(36)
      CALL DrawText(T1, T2, XTitle$(1), GPDat%(11) - 90, GPDat%(58), 1#)

      FOR S2 = 1 TO YBound
	  T1 = GPDat%(37) + GPDat%(39) - (S2 - .5) * GPDat%(41) * XaAspect# + 5
	  T2 = GPDat%(38) + (S2 - .5) * GPDat%(41) * XbAspect#
	  CALL DrawText(T1, T2, YTitle$(S2 + 1), 0, TxtColor((S2 - 1) MOD MaxTileNum + 1), 1#)
      NEXT

      FOR S2 = 1 TO XBound
	  T1 = GPDat%(37) - GPDat%(39) * XaAspect# + (S2 - 1) * GPDat%(42)
	  T2 = GPDat%(38) + GPDat%(39) * XbAspect# + GPDat%(36)
	  CALL StepText(T1, T2, XTitle$(S2 + 1), -90, GPDat%(58), 1#)
      NEXT

    END IF

    'step through GraphData!() array and plot individual 3d lines
    FOR T3 = 1 TO YBound
      FOR T2 = 1 TO XBound
	CALL PlotLine3(T2 - 1, T3 - 1, GraphData!(T2, T3), GraphData!(T2 - 1, T3), tile$(((T3 - 1) MOD MaxTileNum) + 1))
      NEXT
    NEXT

    GPDat%(37) = 0     'We clear this variable to tell the next graph to
			'pick its own screen size.  If the user want to alter
			'it he must do so before each graph

END SUB

