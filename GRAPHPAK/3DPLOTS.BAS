'********** 3DPlots.Bas

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'This Declare statement is for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE SUB FillPoly (a%, b%, c%, d%, e%, f%, g%, h%, Colr%)

'$INCLUDE: 'Common'

SUB PlotPoint (X, Y, Z1!, Z2!, Z3!, Z4!, PaintColor) STATIC

    'do some initial calculations for speed
    YaA! = GPDat%(42) * YaAspect#
    YaB! = GPDat%(42) * YbAspect#
    XaA! = GPDat%(41) * XaAspect#
    XaB! = GPDat%(41) * XbAspect#

    Mx! = GPDat%(37) - (XaA! * X) + YaA! * Y       'center point
    Mx1! = Mx! - YaA!                               'previous point on Y-axis

    My! = GPDat%(38) + (XaB! * (X - 1)) + YaB! * Y 'center point
    My1! = My! - YaB!                               'previous point on Y-axis
    My2! = My! - XaB!                               'previous point on X-axis

    M! = My! - (GPDat%(40) * Z1! / 100)            'recalculated height
    M1! = My1! - (GPDat%(40) * Z2! / 100)

    Mx3! = Mx! - XaA!                           'point +1 x-axis
    Mx4! = Mx! - XaA! - YaA!                    'point +1 x-axis -1 y-axis
    My3! = My! + XaB!                           'point +1 x-axis
    My4! = My! + XaB! - YaB!                    'point +1 x-axis -1 y-axis
    M3! = My3! - (GPDat%(40) * Z3! / 100)     'recalculated height
    M4! = My4! - (GPDat%(40) * Z4! / 100)

    'FILL the polygon in color Paintcolor - some parts may be hidden
    CALL FillPoly(CINT(Mx!), CINT(M!), CINT(Mx1!), CINT(M1!), CINT(Mx3!), CINT(M3!), CINT(Mx4!), CINT(M4!), PaintColor)

END SUB

SUB PlotSurface (X, Y, Z!, PaintColor) STATIC

    ' The next 6 variables are initialized for the base of the cube.
    ' Point (Mx1, My1) represents the far left of the base.
    ' Point (Mx2, My2) represents the middle of the base.
    ' Point (Mx3, My3) represents the far right of the base.
    ' Only visible sides of the cube will be drawn.  Drawing will be
    ' done with three calls to the routine FillPoly, one for each visible
    ' face of the cube.

    Mx1 = GPDat%(37) - (XaAspect# * GPDat%(41) * (X + 1)) + GPDat%(42) * Y * YaAspect#
    Mx2 = Mx1 + GPDat%(42) * YaAspect#
    Mx3 = Mx2 + XaAspect# * GPDat%(41)

    My1 = GPDat%(38) + (XbAspect# * GPDat%(41) * X) + GPDat%(42) * Y * YbAspect#
    My2 = My1 + YbAspect# * GPDat%(42)
    My3 = My1 - XbAspect# * GPDat%(41) + GPDat%(42) * YbAspect#

    'Setup these variables for quick calculations below
    d = GPDat%(42) * XbAspect#
    M = GPDat%(40) * Z! / 100 - 1 - d

    'Paint both the inside and border in the same color
    HoldColor = GPDat%(26)
    GPDat%(26) = -1

    'Draw Left Side Face
    CALL FillPoly(Mx1, My1 + d, Mx1, My1 - M, Mx2, My2 + d, Mx2, My2 - M, PaintColor)

    'Draw Right Side Face
    CALL FillPoly(Mx2, My2 + d, Mx2, My2 - M, Mx3, My3 + d, Mx3, My3 - M, PaintColor)

    'Draw the Top Face
    CALL FillPoly(Mx3, My3 - M, Mx3 - CINT(GPDat%(42) * YaAspect#), My3 - M - CINT(GPDat%(42) * YbAspect#), Mx2, My2 - M, Mx1, My1 - M, PaintColor)

    GPDat%(26) = HoldColor
                                   
    IF GPDat%(31) = 2 OR GPDat%(31) = 6 THEN
       LINE (Mx3, My3 - M + d)-(Mx3 - GPDat%(42) * YaAspect#, My3 - M - GPDat%(42) * YbAspect# + d), 0
       LINE -(Mx1, My1 - M + d), 0
    END IF

END SUB

