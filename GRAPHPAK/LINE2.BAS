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

'This program sets up and creates a line graph of YBound Items with
'XBound groupings
'
SUB Line2 (GraphData!(), XTitle$(), YTitle$(), MainTitle$, Colors%()) STATIC

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

    '$INCLUDE: 'LineTile'

    'Determine the spacing between data points
    IF GPDat%(21) THEN
	GPDat%(42) = GPDat%(39) \ (XBound - 1)
    ELSE
	GPDat%(42) = GPDat%(39) \ XBound
    END IF
    GPDat%(41) = GPDat%(42)

    'Show text to describe the points on the screen
    CALL LineLegend(YTitle$(), YBound, GPLTile%(), Colors%())

    'Partition off the graph with text to describe the data points
    CALL LineGrouping(XTitle$(), XBound)

    'Draw the data
    T4 = 0 'Start with tile 1 (NOTE: Automatically incrmented once)
    FOR T3 = 1 TO YBound
	IF Colors%((T3 - 1) MOD UBOUND(Colors) + 1) = Colors%(1) THEN T4 = T4 MOD MaxTileNum + 1
	FOR T2 = 1 TO XBound
	    'This prevents zero values from being plotted
	    IF (GPDat%(16) OR GraphData!(T2, T3) > 0) AND (T2 >= GPDat%(28) AND T2 <= GPDat%(29)) THEN
		Colr = Colors%((T3 - 1) MOD UBOUND(Colors) + 1)
		IF Colr = GPDat%(57) THEN Colr = GPDat%(56)
		CALL PlotLine(T2 - 1, T3 - 1, GraphData!(T2, T3), Colr, GPLTile%(T4))
	    END IF
	NEXT
    NEXT

    GPDat%(37) = 0     'We clear this variable to tell the next graph to
		       'pick its own screen size.  If the user want to alter
		       'it he must do so before each graph
    GPDat%(8) = Save8  'Restore the 3D Bars flag

END SUB

