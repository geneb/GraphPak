'********** Bars1.Bas - draws a complete 1-D bar graph

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'These Declare statements are for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE SUB DrawBackground2 (XTitle$(), YTitle$())
DECLARE SUB BarGrouping (XTitle$(), XBound%)
DECLARE SUB PlotBar (X%, Y%, Z!, Tile$)
DECLARE SUB PlotBar3 (X%, Y%, Z!, Tile$)
DECLARE SUB DisplayTitle (Title$)

'$INCLUDE: 'Common'

'This program sets up and creates a bar graph of XBound Items with no data
'groupings
'
SUB Bars1 (GraphData!(), XTitle$(), MainTitle$) STATIC

    'Upper boundary of data
    XBound = UBOUND(GraphData!)
    IF GPDat%(19) > 0 THEN XBound = GPDat%(19)
    GPDat%(45) = XBound
    GPDat%(46) = 1

    REDIM YTitle$(1)  'DrawBackground2 needs this parameter even though empty

    'Draw the Axis and overall title
    CALL DrawBackground2(XTitle$(), YTitle$())
    'Display the title in upper corner
    CALL DisplayTitle(MainTitle$)

    'Obtain a few more boundarys
    MaxTileNum = UBOUND(Tile$)      'Tiles will loop when the data is used up

    GPDat%(42) = GPDat%(39) \ 2 \ XBound   'Bar Size
    GPDat%(41) = GPDat%(42) * 2            'Distance between bars
					       '(Left side to next left side)

    'loop through and draw the individual bar titles
    CALL BarGrouping(XTitle$(), XBound%)

    'Plot the data
    FOR T2 = 1 TO XBound
	IF GPDat%(8) THEN
	    CALL PlotBar3(T2 - 1, 0, GraphData!(T2), Tile$(((T2 - 1) MOD MaxTileNum) + 1))
	ELSE
	    CALL PlotBar(T2 - 1, 0, GraphData!(T2), Tile$(((T2 - 1) MOD MaxTileNum) + 1))
	END IF
    NEXT
    IF GPDat%(54) AND (GPDat%(6) > 0) THEN
	D1 = (GPDat%(6) / (GPDat%(5) - GPDat%(6))) * GPDat%(40)
	LINE (GPDat%(37), GPDat%(38) + D1)-(GPDat%(37) + GPDat%(39), GPDat%(38) + D1), GPDat%(55)
    END IF

    GPDat%(37) = 0     'We clear this variable to tell the next graph to
			'pick its own screen size.  If the user want to alter
			'it he must do so before each graph

END SUB

