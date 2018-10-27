'********** HighLow.Bas - draws a complete 2-D High-Low graph using bars
'                         or lines depending on the variable GPDat%(13)

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'These Declare statements are for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE FUNCTION MakeBinary% (Bin$)
DECLARE SUB DrawBackground2 (XTitle$(), YTitle$())
DECLARE SUB PlotBarHLC (X%, Y%, High!, Low!, Clos!, Tile$)
DECLARE SUB PlotLineHLC (X%, Y%, High!, Low!, Clos!, Colr%, Style%)
DECLARE SUB BarLegend (YTitle$(), YBound%)
DECLARE SUB BarGrouping (XTitle$(), XBound%)
DECLARE SUB LineLegend (YTitle$(), YBound%, GP.LTile%(), Colors%())
DECLARE SUB LineGrouping (XTitle$(), XBound%)
DECLARE SUB DisplayTitle (title$)

'$INCLUDE: 'Common'

SUB HighLow (GraphData!(), XTitle$(), YTitle$(), MainTitle$, Colors%()) STATIC

    Save8 = GPDat%(8)
    GPDat%(8) = 0
    'Upper boundary of data
    XBound = UBOUND(GraphData!, 1) \ 3 'For High Low Graph 3 Data points exist
				       'for each graph point
    YBound = UBOUND(GraphData!, 2)
    IF GPDat%(19) > 0 THEN XBound = GPDat%(19)
    IF GPDat%(20) > 0 THEN YBound = GPDat%(20)

    'Draw the axis and overall titles of bar groups
    CALL DrawBackground2(XTitle$(), YTitle$())
    'Display the main title in upper corner
    CALL DisplayTitle(MainTitle$)

    '$INCLUDE: 'LineTile'

    'Obtain a few more boundarys
    MaxTileNum = UBOUND(Tile$)   'Tiles will loop when the data is used up

    GPDat%(42) = GPDat%(39) \ 2 \ YBound  'Individual bar size
    GPDat%(41) = GPDat%(42) * 2           'Distance between bar groups calculated
				    ' from left most bar to next left most bar
   
    'draw individual bar titles
    IF GPDat%(13) THEN
       CALL BarLegend(YTitle$(), YBound)
    ELSE
       CALL LineLegend(YTitle$(), YBound, GPLTile%(), Colors%())
    END IF

    'Plot the data
    T4 = 0  'Start with Tile 1 (Automatically incremented below)
    FOR T3 = 1 TO YBound
	IF Colors%((T3 - 1) MOD UBOUND(Colors%) + 1) = Colors%(1) THEN T4 = T4 MOD MaxTileNum + 1
	FOR T2 = 1 TO XBound * 3 STEP 3
	    IF GraphData!(T2, T3) > 0 THEN
	       'Organize the data into a high low close order
	       A! = GraphData!(T2, T3)
	       B! = GraphData!(T2 + 1, T3)
	       C! = GraphData!(T2 + 2, T3)
	       IF A! > B! THEN      'A is not the lowest
		  IF A! > C! THEN   'A is highest
		     High! = A!
		     IF B! > C! THEN
			Low! = C!: Clos! = B!
		     ELSE
			Low! = B!: Clos! = C!
		     END IF
		  ELSE              'C is highest
		     High! = C!
		     Low! = B!
		     Clos! = A!
		  END IF
	       ELSE                 'B is not the lowest
		  IF B! > C! THEN   'B is highest
		     High! = B!
		     IF C! > A! THEN
			Low! = A!: Clos! = C!
		     ELSE
			Low! = C!: Clos! = A!
		     END IF
		  ELSE              'C is highest
		     High! = C!
		     Low! = A!
		     Clos! = B!
		  END IF
	       END IF
	       IF GPDat%(13) THEN
		  CALL PlotBarHLC(T2 - 1, T3 - 1, High!, Low!, Clos!, Tile$(((T3 - 1) MOD MaxTileNum) + 1))
	       ELSE
		  Colr = Colors%((T3 - 1) MOD UBOUND(Colors%) + 1)
		  IF Colr = GPDat%(57) THEN Colr = GPDat%(56)
		  CALL PlotLineHLC(T2 - 1, T3 - 1, High!, Low!, Clos!, Colr, GPLTile(T4))
	       END IF
	    END IF
	NEXT
    NEXT

    GPDat%(37) = 0     'We clear this variable to tell the next graph to
		       'pick its own screen size.  If the user want to alter
		       'it he must do so before each graph
    GPDat%(8) = Save8  'Restore 3D Bars flag

END SUB

