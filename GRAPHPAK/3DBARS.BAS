'********** 3DBars.Bas - subprograms to draw individual 3D bars with depth

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'This Declare is for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE SUB FillPoly (a%, b%, c%, d%, e%, f%, g%, h%, Colr%)

'$INCLUDE: 'Common'

'This sub-program draws an un-conventional 3D Cube
'
SUB PlotCube (x, y, Z!, Tile$) STATIC

    FillColr = GPDat%(56) * 16 + GPDat%(57)

    ' The next 6 variables are initialized for the base of the cube.
    ' Point (Mx1, My1) represents the far left of the base.
    ' Point (Mx2, My2) represents the middle of the base.
    ' Point (Mx3, My3) represents the far right of the base.
    ' Only visible sides of the cube will be drawn.  Drawing will be
    ' done with three calls to the routine FillPoly, one for each visible
    ' face of the cube.

    IF GPDat%(45) > 1 THEN
	 xd = (GPDat%(39) - GPDat%(45) * GPDat%(42)) / (GPDat%(45) - 1)
    ELSE
	 xd = 0
    END IF
    IF GPDat%(46) > 1 THEN
	 yd = (GPDat%(39) - GPDat%(46) * GPDat%(41)) / (GPDat%(46) - 1)
    ELSE
	 yd = 0
    END IF

    Mx1 = GPDat%(37) - (XaAspect# * GPDat%(42) * (x + 1)) + (GPDat%(41) + yd) * y * YaAspect# - xd * x * XaAspect#
    Mx2 = Mx1 + GPDat%(41) * YaAspect#
    Mx3 = Mx2 + XaAspect# * GPDat%(42)

    My1 = GPDat%(38) + (XbAspect# * (GPDat%(42) + xd) * x) + GPDat%(41) * y * YbAspect# + yd * y * YbAspect#
    My2 = My1 + YbAspect# * GPDat%(41)
    My3 = My1 - XbAspect# * GPDat%(42) + GPDat%(41) * YbAspect#

    'Setup these variables for quick calculations below
    d = GPDat%(42) * XbAspect#
    M = GPDat%(40) * (Z! - GPDat%(6)) / (GPDat%(5) - GPDat%(6)) - 1 - d
   
    'Draw Left Side Face
    CALL FillPoly(Mx1, My1 + d, Mx1, My1 - M, Mx2, My2 + d, Mx2, My2 - M, FillColr)

    'Draw Right Side Face
    CALL FillPoly(Mx2, My2 + d, Mx2, My2 - M, Mx3, My3 + d, Mx3, My3 - M, FillColr)
    LINE (Mx3, My3 + d)-(Mx3, My3 - M), GPDat%(56)

    'Draw the Top Face
    CALL FillPoly(Mx3, My3 - M, Mx3 - CINT(GPDat%(41) * YaAspect#), My3 - M - CINT(GPDat%(41) * YbAspect#), Mx2, My2 - M, Mx1, My1 - M, FillColr)
				       
    IF INSTR(STRING$(4, 0), Tile$) < 1 THEN  'if tile$ exists and ins't null
	IF M > 0 THEN
	  PAINT (Mx2 - 1, My2 - M + 1), Tile$, GPDat%(56)
	  PAINT (Mx2 + 1, My2 - M + 1), Tile$, GPDat%(56)
	END IF
	PAINT (Mx2, My2 - M - 2), Tile$, GPDat%(56)
    END IF

END SUB

