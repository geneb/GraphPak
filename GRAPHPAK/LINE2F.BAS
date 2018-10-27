'********** Line2F.Bas - displays a complete 2-D filled line chart

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'These Declare statements are for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE SUB DrawBackground2 (XTitle$(), YTitle$())
DECLARE SUB PlotLineF (X%, Y%, Z!, ZOld!, Tile$)
DECLARE SUB BarLegend (YTitle$(), YBound%)
DECLARE SUB LineGrouping (XTitle$(), XBound%)
DECLARE SUB DisplayTitle (Title$)

'$INCLUDE: 'Common'

'This program sets up and creates a area line graph of YBound Items
'with XBound groupings
'
SUB Line2F (GraphData!(), XTitle$(), YTitle$(), MainTitle$) STATIC

  Save8 = GPDat%(8)
  GPDat%(8) = 0
  'Upper boundary's of the data
  XBound = UBOUND(GraphData!, 1)
  YBound = UBOUND(GraphData!, 2)
  IF GPDat%(19) > 0 THEN XBound = GPDat%(19)
  IF GPDat%(20) > 0 THEN YBound = GPDat%(20)
  GPDat%(45) = XBound
  GPDat%(46) = YBound

  'Draw the axis and overall titles
  CALL DrawBackground2(XTitle$(), YTitle$())
  'Draw the main title in upper right corner
  CALL DisplayTitle(MainTitle$)

  MaxTileNum = UBOUND(Tile$)

  'Determine the spacing between data points
  IF GPDat%(21) THEN
    GPDat%(42) = GPDat%(39) \ (XBound - 1)
  ELSE
    GPDat%(42) = GPDat%(39) \ XBound
  END IF
  GPDat%(41) = GPDat%(42)

  'Show text to describe the points on the screen
  CALL BarLegend(YTitle$(), YBound)

  'Partition off the graph with text to describe the data points
  CALL LineGrouping(XTitle$(), XBound%)

  'Draw the data
  FOR T3 = 1 TO YBound
    FOR T2 = 1 TO XBound
      'This prevents zero values from being plotted
      IF GPDat%(16) OR GraphData!(T2, T3) > 0 THEN
	CALL PlotLineF(T2 - 1, T3 - 1, GraphData!(T2, T3), GraphData!(T2 - 1, T3), Tile$(((T3 - 1) MOD MaxTileNum) + 1))
      END IF
    NEXT
    FOR T2 = 2 TO XBound
      IF GPDat%(21) THEN
	Mx1 = (T2 - 1) * GPDat%(41) + GPDat%(37)
      ELSE
	Mx1 = (T2 - 1) * GPDat%(41) + GPDat%(37) + GPDat%(41) \ 2
      END IF
      My = GPDat%(38) + (GPDat%(6) / (GPDat%(5) - GPDat%(6))) * GPDat%(40)

      A2 = SGN(GraphData!(T2, T3))
      A3 = My - A2
      WHILE POINT(Mx1 - 1, A3) <> GPDat%(56)
	A3 = A3 - A2
      WEND
      IF A3 < GPDat%(38) AND A3 > GPDat%(38) - GPDat%(40) THEN
	IF POINT(Mx1-1, My-A2) <> GPDat%(56) THEN
          PAINT (Mx1 - 1, My - A2), Tile$(((T3 - 1) MOD MaxTileNum) + 1), GPDat%(56)
        END IF
      END IF

      A2 = SGN(GraphData!(T2 - 1, T3))
      A3 = My - A2
      WHILE POINT(Mx1 - GPDat%(41) + 1, A3) <> GPDat%(56)
	A3 = A3 - A2
      WEND
      IF A3 < GPDat%(38) AND A3 > GPDat%(38) - GPDat%(40) THEN
	IF POINT(Mx1-GPDat%(41)+1, My-A2) <> GPDat%(56) THEN
          PAINT (Mx1 - GPDat%(41) + 1, My - A2), Tile$(((T3 - 1) MOD MaxTileNum) + 1), GPDat%(56)
        END IF
      END IF
     
    NEXT
  NEXT

  GPDat%(37) = 0     'We clear this variable to tell the next graph to
		     'pick its own screen size.  If the user want to alter
		     'it he must do so before each graph

  GPDat%(8) = Save8  'Restore the 3D Bars flag

END SUB

