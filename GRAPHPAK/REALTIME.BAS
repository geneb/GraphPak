'********** Line2.Bas - displays a complete 2-D line chart

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'These Declare statements are for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE SUB DrawBackground2 (XTitle$(), YTitle$())
DECLARE SUB PlotLine (X%, Y%, Z!, Colr%, Style%)
DECLARE SUB LineLegend (YTitle$(), YBound%, GP.LTile%(), Colors%())
DECLARE SUB LineGrouping (XTitle$(), XBound%)
DECLARE SUB DisplayTitle (Title$)
DECLARE FUNCTION MakeBinary% (Bin$)

'$INCLUDE: 'Common'

'
SUB RealTime (GraphData!(), XTitle$(), YTitle$(), MainTitle$, Colors%(), Action) STATIC
   
    IF Action < 1 THEN
     
      'Upper boundary's of the data
      Save8 = GPDat(8)
      GPDat(8) = 0
      XBound = UBOUND(XTitle$) - 1  'Number of x points to plot
      YBound = UBOUND(YTitle$) - 1  'Number of lines to plot
      Redraw = Action = -1          'Scanning plot, clear window before redraw
      Retrace = Action = -2         'Scanning plot, clear only what we need to
      IF Redraw OR Retrace THEN GPDat(2) = 0 'Don't allow tiling of background
      GPDat(21) = -1
      REDIM LastPoint(YBound)       'Dim array to hold last point plotted
     
      IF GPDat%(19) > 0 THEN XBound = GPDat%(19)
      IF GPDat%(20) > 0 THEN YBound = GPDat%(20)
      GPDat%(45) = XBound
      GPDat%(46) = YBound
     
      '$INCLUDE: 'LineTile'
   
      IF GPDat%(37) = 0 THEN
	IF GPDat%(31) = 2 OR GPDat%(31) = 5 THEN    'EGA or Hercules
	  GPDat%(37) = 54: GPDat%(38) = 260
	  GPDat%(39) = 540: GPDat%(40) = 180
	ELSEIF GPDat%(31) = 8 THEN                   'VGA
	  GPDat%(37) = 60: GPDat%(38) = 380
	  GPDat%(39) = 480: GPDat%(40) = 300'5
	ELSEIF GPDat%(31) = 6 THEN                   'CGA 2 Color Mode
	  GPDat%(37) = 50: GPDat%(38) = 120
	  GPDat%(39) = 480: GPDat%(40) = 90
	ELSE                                         'CGA 4 Color Mode
	  GPDat%(37) = 50: GPDat%(38) = 130
	  GPDat%(39) = 230: GPDat%(40) = 90
	END IF
      END IF
      OldWidth = GPDat(39)
     
      GPDat%(42) = GPDat%(39) \ (XBound - 1)
     
      GPDat(41) = GPDat(42)
      GPDat%(39) = GPDat(42) * (XBound - 1)
     
      StepSize = GPDat%(40) \ ((GPDat%(5) - GPDat%(6)) \ GPDat%(7))
      Steps = GPDat%(40) \ StepSize
     
      GPDat%(40) = Steps * StepSize
      'Draw the main title in upper right corner
      CALL DisplayTitle(MainTitle$)
     
      'Draw the axis and overall titles
      CALL DrawBackground2(XTitle$(), YTitle$())
     
      'Show text to describe the points on the screen
      CALL LineLegend(YTitle$(), YBound, GPLTile%(), Colors%())

      'Partition off the graph with text to describe the data points
      CALL LineGrouping(XTitle$(), XBound)
   
      RightSide = GPDat(37) + GPDat(39) - 1
      LeftSide = GPDat(37)
      
      ZeroLine = GPDat(38) + (GPDat%(6) / (GPDat%(5) - GPDat%(6))) * GPDat%(40)
      Mx1 = LeftSide + 1
      LastMx1 = Mx1
     
      XPoint = 1
      Action = 2
      EXIT SUB
   
    END IF
     
    IF Action = 2 THEN
      FOR i = 1 TO YBound
	LastPoint(i) = GPDat%(38) - GPDat%(40) * (GraphData!(i) - GPDat%(6)) / (GPDat%(5) - GPDat%(6))
      NEXT
      Action = 3
    END IF
   
    IF Retrace THEN
      LINE (LastMx1 + 1, GPDat(38) - 1)-(Mx1, GPDat(38) - GPDat(40) + 1), GPDat(57), BF
      IF GPDat(6) < 0 AND GPDat(54) THEN LINE (LastMx1 + 1, ZeroLine)-(Mx1, ZeroLine), GPDat%(55)
    END IF
   
    T4 = 0
    FOR i = 1 TO YBound
      IF Colors(i MOD UBOUND(Colors)) = Colors(1) THEN T4 = T4 MOD MaxTileNum + 1
      My1 = GPDat%(38) - GPDat%(40) * (GraphData!(i) - GPDat%(6)) / (GPDat%(5) - GPDat%(6))
      Colr = Colors%((i - 1) MOD UBOUND(Colors) + 1)
      IF Colr = GPDat%(57) THEN Colr = GPDat%(56)
      LINE (LastMx1, LastPoint(i))-(Mx1, My1), Colr, , GPLTile%(T4)
      LastPoint(i) = My1
    NEXT
  
    LastMx1 = Mx1
    Mx1 = LeftSide + XPoint * GPDat(42)
    IF Mx1 > RightSide THEN Mx1 = RightSide
   
    XPoint = XPoint + 1
   
    IF XPoint = XBound + 1 THEN
      LINE (GPDat(37), GPDat(38))-(GPDat(37) + GPDat(39), GPDat(38)), GPDat%(56)
      LINE (GPDat(37), GPDat(38) - GPDat(40))-(GPDat(37) + GPDat(39), GPDat(38) - GPDat(40)), GPDat%(56)
      GPDat%(8) = Save8  'Restore the 3D Bars flag
      Mx1 = LeftSide + 1
      LastMx1 = Mx1
      Action = 2
      XPoint = 1
      IF Redraw THEN
	LINE (GPDat(37) + 1, GPDat(38) - 1)-STEP(GPDat(39) - 2, -GPDat(40) + 2), GPDat(57), BF
	IF GPDat(6) < 0 AND GPDat(54) THEN LINE (GPDat(37), ZeroLine)-(GPDat%(37) + GPDat%(39), ZeroLine), GPDat%(55)
      END IF
    END IF

END SUB

