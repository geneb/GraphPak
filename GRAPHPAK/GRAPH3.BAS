'********** Graph3.Bas - draws a complete 3D bar graph

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'These Declare statements are for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE SUB DrawBackground4 ()
DECLARE SUB PlotPoint (X%, Y%, Z1!, Z2!, Z3!, Z4!, PaintColor%)
DECLARE SUB PlotSurface (X%, Y%, Z!, PaintColor%)
DECLARE SUB SetAspect (Angle1%, Angle2%)
DECLARE SUB DisplayTitle (Title$)

'$INCLUDE: 'Common'

SUB Graph3 (GraphData!(), MainTitle$, Colors(), Surface%) STATIC

    'Upper boundary's of the data
    XBound = UBOUND(GraphData!, 1)
    YBound = UBOUND(GraphData!, 2)
    IF GPDat%(19) > 0 THEN XBound% = GPDat%(19)
    IF GPDat%(20) > 0 THEN YBound% = GPDat%(20)
    GPDat%(45) = XBound%
    GPDat%(46) = YBound%
    CBound = UBOUND(Colors)

    'Set Angles for graph display
    CALL SetAspect(GPDat%(10), GPDat%(11))
    'Draw the background
    CALL DrawBackground4
    'Draw the main title
    CALL DisplayTitle(MainTitle$)

    'Obtain a few more boundarys
    GPDat%(41) = GPDat%(39) \ (XBound)
    GPDat%(42) = GPDat%(39) \ (YBound)

    'Plot the data
    IF NOT Surface THEN
      GPDat%(42) = GPDat%(42) - 1
      GPDat%(41) = GPDat%(41) - 1
      FOR S1 = 1 TO XBound - 1
	FOR S2 = 2 TO YBound
	    PaintColor = Colors(S2 - 1 + (S1 - 1) * (YBound - 1))
	    Point3! = GraphData!(S1 + 1, S2)
	    Point4! = GraphData!(S1 + 1, S2 - 1)
	    CALL PlotPoint(S1, S2, GraphData!(S1, S2), GraphData!(S1, S2 - 1), Point3!, Point4!, PaintColor)
	NEXT
      NEXT
    ELSE
      FOR S1 = 0 TO XBound - 1
	FOR S2 = 0 TO YBound - 1
	    PaintColor = Colors(1 + S2 + S1 * YBound)
	    CALL PlotSurface(S1, S2, GraphData!(S1 + 1, S2 + 1), PaintColor)
	NEXT
      NEXT
    END IF

END SUB

