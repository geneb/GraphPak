'********** 2DBars.Bas - subprograms to draw a single "flat" bar

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'This Declare statement is for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE SUB FillPoly (a%, B%, c%, d%, e%, f%, g%, h%, Colr%)

'$INCLUDE: 'Common'

'This subprogram draws a "conventional" flat 2D bar
'
SUB PlotBar (X, Y, Z!, Tile$) STATIC

    'left X value of bar
    Mx1 = X * GPDat%(41) + GPDat%(37) + Y * GPDat%(42) + GPDat%(42) / 2
    Mx2 = Mx1 + GPDat%(42) 'Right X Point of the bar is X Point + Bar Width

    'lower Y value is at the YCenter of the graph
    My1 = GPDat%(38)
    IF GPDat%(6) < 0 THEN
       My1 = GPDat%(38) + (GPDat%(6) / (GPDat%(5) - GPDat%(6))) * GPDat%(40)
    END IF
    My2 = GPDat%(38) - GPDat%(40) * (Z! - GPDat%(6)) / (GPDat%(5) - GPDat%(6))

    LINE (Mx1, My1)-(Mx2, My2), GPDat%(57), BF   'clear the background
    LINE (Mx1, My1)-(Mx2, My2), GPDat%(56), B   'draw box border
    IF My1 <> My2 THEN
       PAINT (Mx1 + 1, My1 - SGN(Z!)), Tile$, GPDat%(56)     'tile inner area
    END IF

END SUB

'This subprogram draws a flat bar with a 3D perspective and depth
'
SUB PlotBar3 (X, Y, Z!, Tile$) STATIC

    FillColr = GPDat%(56) * 16 + GPDat%(57)
    Mx1 = X * GPDat%(41) + GPDat%(37) + Y * GPDat%(42) + GPDat%(42) / 2
    Mx2 = Mx1 + INT(.7 * GPDat%(42) + .5)  'face is 70% of actual bar width
    Mx3 = Mx1 + GPDat%(42)                 'right X value of bar

    'lower Y value is a the YCenter of the graph
    My1 = GPDat%(38)
    IF GPDat%(6) < 0 THEN
       My1 = GPDat%(38) + (GPDat%(6) / (GPDat%(5) - GPDat%(6))) * GPDat%(40)
    END IF
    My2 = GPDat%(38) - GPDat%(40) * (Z! - GPDat%(6)) / (GPDat%(5) - GPDat%(6))

    LINE (Mx1, My1)-(Mx2, My2), GPDat%(57), BF        'clear face area
    LINE (Mx1, My1)-(Mx2, My2), GPDat%(56), B         'box face area
    IF My1 <> My2 THEN
      PAINT (Mx1 + 1, My1 - SGN(Z!)), Tile$, GPDat%(56)     'tile face
    END IF

    Shift = (Mx3 - Mx2)
    'Draw Right Side Polygon
    CALL FillPoly(Mx2, My1, Mx2, My2, Mx3, My1 - Shift, Mx3, My2 - Shift, FillColr)
    'Fix Far Right Line
    LINE (Mx3, My1 - Shift)-(Mx3, My2 - Shift), GPDat%(56)
    IF My1 <> My2 THEN
      IF Z! < 0 THEN
        PAINT (Mx2 + 1, My1 + 1), Tile$, GPDat%(56)   'paint right hand side.
      ELSEIF Z! > 0 THEN
        PAINT (Mx2 + 1, My2 + 1), Tile$, GPDat%(56)   'paint right hand side.
      END IF
    END IF

    'Draw Top Side Polygon
    IF Z! < 0 THEN
        CALL FillPoly(Mx1, My1, Mx1 + Shift, My1 - Shift, Mx2, My1, Mx3, My1 - Shift, FillColr)
        PAINT (Mx2 - 1, My1 - 1), Tile$, GPDat%(56)   'paint top side.
    ELSE
        CALL FillPoly(Mx1, My2, Mx1 + Shift, My2 - Shift, Mx2, My2, Mx3, My2 - Shift, FillColr)
        PAINT (Mx2 - 1, My2 - 1), Tile$, GPDat%(56) 'paint top side.
    END IF

END SUB

SUB PlotBarH (X%, Y%, Z!, Tile$, YBound) STATIC

    'left X value of bar
    Mx1 = X * GPDat%(41) + GPDat%(37) + (GPDat%(41) - GPDat%(42)) / 2
    IF GPDat%(22) THEN
       Mx1 = X * GPDat%(41) + GPDat%(37) + ((GPDat%(41) - GPDat%(42)) * Y) / YBound
    END IF
    Mx2 = Mx1 + GPDat%(42) 'Right X Point of the bar is X Point + Bar Width

    'lower Y value is at the YCenter of the graph
    My1 = GPDat%(38)
    My2 = GPDat%(38) - GPDat%(40) * (Z! - GPDat%(6)) / (GPDat%(5) - GPDat%(6))

    LINE (Mx1, My1)-(Mx2, My2), GPDat%(57), BF   'clear the background
    LINE (Mx1, My1)-(Mx2, My2), GPDat%(56), B   'draw box border
    IF My1 <> My2 THEN
       PAINT (Mx1 + 1, My1 - 1), Tile$, GPDat%(56)     'tile inner area
    END IF

END SUB

'This subprogram draws a "conventional" flat 2D bar for use with
'high-low-close graphs
'
SUB PlotBarHLC (X, Y, High!, Low!, Clos!, Tile$) STATIC

    'left X value of bar
    Mx1 = Y * GPDat%(41) + GPDat%(37) + X * GPDat%(42) + GPDat%(42) / 2
    Mx2 = Mx1 + GPDat%(42)    'right X point is left X point + bar width

    My1 = GPDat%(38) - GPDat%(40) * (Low! - GPDat%(6)) / (GPDat%(5) - GPDat%(6))
    My2 = GPDat%(38) - GPDat%(40) * (High! - GPDat%(6)) / (GPDat%(5) - GPDat%(6))
    My3 = GPDat%(38) - GPDat%(40) * (Clos! - GPDat%(6)) / (GPDat%(5) - GPDat%(6))

    LINE (Mx1, My1)-(Mx2, My2), GPDat%(57), BF       'clear the background
    LINE (Mx1, My1)-(Mx2, My2), GPDat%(56), B        'draw box border
    IF My1 <> My2 THEN
       PAINT (Mx1 + 1, My1 - 1), Tile$, GPDat%(56)      'tile inner area
    END IF

    LINE (Mx1 - 2, My3)-(Mx2 + 2, My3), GPDat%(56), B 'Draw the close tick mark

END SUB

SUB PlotBarS (X%, Y%, Z!, Tile$, YStart%) STATIC

    'left X value of bar
    Mx1 = X * GPDat%(41) + GPDat%(37) + (GPDat%(41) - GPDat%(42)) \ 2
    Mx2 = Mx1 + GPDat%(42) 'Right X Point of the bar is X Point + Bar Width

    'lower Y value is at the YCenter of the graph
    My1 = YStart%     'Start bar at position where the last bar left off
    My2 = My1 - GPDat%(40) * (Z! - GPDat%(6)) / (GPDat%(5) - GPDat%(6))
    YStart% = My2     'Save end position for use with the next bar

    LINE (Mx1, My1)-(Mx2, My2), GPDat%(57), BF    'clear the background
    LINE (Mx1, My1)-(Mx2, My2), GPDat%(56), B     'draw box border
    IF My2 <> My1 THEN
       PAINT (Mx1 + 1, My1 - 1), Tile$, GPDat%(56)   'tile inner area
    END IF

END SUB

