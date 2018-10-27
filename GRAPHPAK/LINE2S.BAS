'********** Line2S.Bas - displays a complete 2-D filled line chart

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'These Declare statements are for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE SUB DrawBackground2 (XTitle$(), YTitle$())
DECLARE SUB PlotLineS (X%, Y%, Z!, ZOld!, ZLow!, ZLowOld!, Tile$)
DECLARE SUB BarLegend (YTitle$(), YBound%)
DECLARE SUB LineGrouping (XTitle$(), XBound%)
DECLARE SUB DisplayTitle (Title$)

'$INCLUDE: 'Common'

'This program sets up and creates a area line graph of YBound Items
'with XBound groupings
'
SUB Line2S (GraphData!(), XTitle$(), YTitle$(), MainTitle$) STATIC

    Save8 = GPDat%(8)
    GPDat%(8) = 0
    'Upper boundary's of the data
    XBound = UBOUND(GraphData!, 1)
    YBound = UBOUND(GraphData!, 2)
    IF GPDat%(19) > 0 THEN XBound = GPDat%(19)
    IF GPDat%(20) > 0 THEN YBound = GPDat%(20)

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
	    SendData3! = 0
	    SendData4! = 0
	    FOR T4 = 1 TO T3 - 1
		SendData3! = SendData3! + GraphData!(T2, T4)
		SendData4! = SendData4! + GraphData!(T2 - 1, T4)
	    NEXT
	    SendData1! = SendData3! + GraphData!(T2, T3)
	    SendData2! = SendData4! + GraphData!(T2 - 1, T3)
	    IF GPDat%(16) OR GraphData!(T2, T3) > 0 THEN
		CALL PlotLineS(T2 - 1, T3 - 1, SendData1!, SendData2!, SendData3!, SendData4!, Tile$(((T3 - 1) MOD MaxTileNum) + 1))
	    END IF
	NEXT
	FOR T2 = 2 TO XBound
	    SendData3! = 0
	    SendData4! = 0
	    FOR T4 = 1 TO T3 - 1
		SendData3! = SendData3! + GraphData!(T2, T4)
		SendData4! = SendData4! + GraphData!(T2 - 1, T4)
	    NEXT
	    IF GPDat%(21) THEN
		Mx1 = (T2 - 1.5) * GPDat%(41) + GPDat%(37)
	    ELSE
		Mx1 = (T2 - 1.5) * GPDat%(41) + GPDat%(37) + GPDat%(41) \ 2
	    END IF
	    MidAv! = (SendData3! + SendData4!) / 2
	    HighAv! = (GraphData!(T2, T3) + GraphData!(T2 - 1, T3)) / 4
	    IF HighAv! <> 0 THEN
		My1 = GPDat%(38) - GPDat%(40) * ((MidAv! + HighAv! - GPDat%(6)) / (GPDat%(5) - GPDat%(6)))
		IF POINT(Mx1, My1) <> GPDat%(56) THEN
		  PAINT (Mx1, My1), Tile$(((T3 - 1) MOD MaxTileNum) + 1), GPDat%(56)
		END IF
	    END IF
	NEXT
    NEXT

    GPDat%(37) = 0     'We clear this variable to tell the next graph to
		       'pick its own screen size.  If the user want to alter
		       'it he must do so before each graph
    GPDat%(8) = Save8  'Restore the 3D Bars flag

END SUB

