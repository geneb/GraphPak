'********** Bars2S.Bas - draws a complete 2-D bar graph with Stacked Bars

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'These Declare statements are for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE SUB DrawBackground2 (XTitle$(), YTitle$())
DECLARE SUB PlotBarS (X%, Y%, Z!, Tile$, YStart%)
DECLARE SUB BarLegend (YTitle$(), YBound%)
DECLARE SUB BarGrouping (XTitle$(), XBound%)
DECLARE SUB DisplayTitle (Title$)

'$INCLUDE: 'Common'

'This program sets up and creates a bar graph of YBound Items with in
'XBound groupings.  Bars are stacked and size porportionally to graph
'
SUB Bars2S (GraphData!(), XTitle$(), YTitle$(), MainTitle$) STATIC

    Save8 = GPDat%(8)
    GPDat%(8) = 0
    'Upper boundary's of data
    XBound = UBOUND(GraphData!, 1)
    YBound = UBOUND(GraphData!, 2)
    IF GPDat%(19) > 0 THEN XBound = GPDat%(19)
    IF GPDat%(20) > 0 THEN YBound = GPDat%(20)
    GPDat%(45) = XBound
    GPDat%(46) = YBound

    'Draw the axis and overall title
    CALL DrawBackground2(XTitle$(), YTitle$())
    'Display the title in upper right corner
    CALL DisplayTitle(MainTitle$)

    'Obtain a few more boundarys
    MaxTileNum = UBOUND(Tile$)   'Tile will loop when the data is used up

    GPDat%(42) = GPDat%(39) \ (XBound + 1)        'Bar size
    GPDat%(41) = GPDat%(39) \ XBound              'Bar grouping size

    'draw individual bar titles
    CALL BarLegend(YTitle$(), YBound%)

    'Draw the grouping titles below the groups
    CALL BarGrouping(XTitle$(), XBound%)

    'Plot the data
    T2 = 0
    Colr = 0
    FOR S1 = 0 TO XBound - 1
	YStart = GPDat%(38)
	T3 = 0
	T2 = T2 + 1
	Colr = Colr + 1
	FOR S2 = 0 TO YBound - 1
	    T3 = T3 + 1
	    'Proportionalize the data to the graph by the number of data
	    'points to be plotted
	    IF GraphData!(T2, T3) <> 0 THEN
	      CALL PlotBarS(S1, S2, GraphData!(T2, T3), Tile$(((T3 - 1) MOD MaxTileNum) + 1), YStart)
	    END IF
	NEXT

    NEXT

    GPDat%(37) = 0     'We clear this variable to tell the next graph to
		       'pick its own screen size.  If the user want to alter
		       'it he must do so before each graph
    GPDat%(8) = Save8  'Restore 3D Bars flag

END SUB

