'********** Bars2H.Bas - draws a complete 2-D bar graph with Stacked Bars

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'These Declare statements are for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE SUB DrawBackground2 (XTitle$(), YTitle$())
DECLARE SUB PlotBarH (X%, Y%, Z!, Tile$, YBound%)
DECLARE SUB BarLegend (YTitle$(), YBound%)
DECLARE SUB BarGrouping (XTitle$(), XBound%)
DECLARE SUB DisplayTitle (Title$)

'$INCLUDE: 'Common'

'This program sets up and creates a bar graph of YBound Items with
'XBound groupings.  Bars are placed in height order behind one another.
'
SUB Bars2H (GraphData!(), XTitle$(), YTitle$(), MainTitle$) STATIC

    Save8 = GPDat%(8)
    GPDat%(8) = 0
    'Upper boundary's for the data
    XBound = UBOUND(GraphData!, 1)
    YBound = UBOUND(GraphData!, 2)
    IF GPDat%(19) > 0 THEN XBound = GPDat%(19)
    IF GPDat%(20) > 0 THEN YBound = GPDat%(20)
    GPDat%(45) = XBound
    GPDat%(46) = YBound

    REDIM TempData!(YBound + 1)   'data for the grouping in height order
    REDIM TempTile$(YBound + 1)

    'Draw the axis and overall title
    CALL DrawBackground2(XTitle$(), YTitle$())
    'Display the title in upper right corner
    CALL DisplayTitle(MainTitle$)

    'Obtain a few more boundary's
    MaxTileNum = UBOUND(Tile$)    'Tiles will loop when the data is used up

    GPDat%(42) = GPDat%(39) \ (XBound + 1)         'Bar Size
    GPDat%(41) = GPDat%(39) \ XBound               'Bar grouping size

    'draw individual bar titles
    CALL BarLegend(YTitle$(), YBound%)

    'Draw the grouping titles below the groups
    CALL BarGrouping(XTitle$(), XBound%)

    'Plot the data
    T2 = 0
    Colr = 0
    FOR S1 = 0 TO XBound - 1
	T3 = YBound + 1
	T2 = T2 + 1
	Colr = Colr + 1
	FOR S2 = 0 TO YBound    'Clear the temporary data array
	    TempData!(S2) = 0
	NEXT
	FOR S2 = 1 TO YBound
	    S3 = 1
	    'Move the data point into the temporay array so that the
	    'array is in height order
	    WHILE S3 <= YBound AND GraphData!(T2, S2) > TempData!(S3)
		S3 = S3 + 1
	    WEND
	    FOR T = 2 TO S3 - 1      'Shift some data down
		TempData!(T - 1) = TempData!(T)
		TempTile$(T - 1) = TempTile$(T)
	    NEXT
	    TempData!(S3 - 1) = GraphData!(T2, S2)    'Position the data
	    TempTile$(S3 - 1) = Tile$(((S2 - 1) MOD MaxTileNum) + 1)
	NEXT
	FOR S2 = 0 TO YBound - 1
	    T3 = T3 - 1
	    IF TempData!(T3) <> 0 THEN
	      CALL PlotBarH(S1, S2, TempData!(T3), TempTile$(T3), YBound)
	    END IF
	NEXT

    NEXT

    GPDat%(37) = 0     'We clear this variable to tell the next graph to
		       'pick its own screen size.  If the user want to alter
		       'it he must do so before each graph
    GPDat%(8) = Save8  'Restore the 3D Bars flag

END SUB

