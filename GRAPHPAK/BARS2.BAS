'********** Bars2.Bas - draws a complete 2-D bar graph

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'These Declare statements are for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE SUB DrawBackground2 (XTitle$(), YTitle$())
DECLARE SUB BarLegend (YTitle$(), YBound%)
DECLARE SUB BarGrouping (XTitle$(), XBound%)
DECLARE SUB PlotBar (X%, Y%, Z!, Tile$)
DECLARE SUB PlotBar3 (X%, Y%, Z!, Tile$)
DECLARE SUB DisplayTitle (title$)

'$INCLUDE: 'Common'

'This program sets up and creates a bar graph of YBound Items with
'XBound groupings
'
SUB Bars2 (GraphData!(), XTitle$(), YTitle$(), MainTitle$) STATIC

    XBound = UBOUND(GraphData!, 1)            'Upper boundary of data
    YBound = UBOUND(GraphData!, 2)
    IF GPDat%(19) > 0 THEN XBound = GPDat%(19)
    IF GPDat%(20) > 0 THEN YBound = GPDat%(20)
    GPDat%(45) = XBound
    GPDat%(46) = YBound

    'Draw the axis and overall titles of bar groups
    CALL DrawBackground2(XTitle$(), YTitle$())
    'Display the main title in upper corner
    CALL DisplayTitle(MainTitle$)

    'Obtain a few more boundarys
    MaxTileNum = UBOUND(Tile$)   'Tiles will loop when the data is used up

    GPDat%(42) = GPDat%(39) \ (YBound + 1) \ XBound  'Individual bar size
    GPDat%(41) = GPDat%(42) * (YBound + 1)          'Distance between bar groups calculated
				    ' from left most bar to next left most bar
   
    'draw individual bar titles
    CALL BarLegend(YTitle$(), YBound%)

    'Draw the grouping titles below the groups
    CALL BarGrouping(XTitle$(), XBound%)

    'Plot the data
    FOR T3 = 1 TO YBound
	FOR T2 = 1 TO XBound
	  IF GPDat%(16) OR GraphData!(T2, T3) <> 0 THEN
	    IF GPDat%(8) THEN
		CALL PlotBar3(T2 - 1, T3 - 1, GraphData!(T2, T3), Tile$(((T3 - 1) MOD MaxTileNum) + 1))
	    ELSE
		CALL PlotBar(T2 - 1, T3 - 1, GraphData!(T2, T3), Tile$(((T3 - 1) MOD MaxTileNum) + 1))
	    END IF
	  END IF
	NEXT
    NEXT
    IF GPDat%(54) AND (GPDat%(6) > 0) THEN
	D1 = (GPDat%(6) / (GPDat%(5) - GPDat%(6))) * GPDat%(40)
	LINE (GPDat%(37), GPDat%(38) + D1)-(GPDat%(37) + GPDat%(39), GPDat%(38) + D1), GPDat%(55)
    END IF
   
    GPDat%(37) = 0     'We clear this variable to tell the next graph to
			'pick its own screen size.  If the user want to alter
			'it he must do so before each graph

END SUB

