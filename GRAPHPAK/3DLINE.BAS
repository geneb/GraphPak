'********** 3DLine.Bas - subprogram to draw a single line

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'This DECLARE statement is for QuickBASIC 4.0 - See DEMOGPAK.BAS

DECLARE SUB FillPoly (a%, b%, c%, d%, e%, f%, g%, h%, Colr%)

'$INCLUDE: 'Common'

SUB PlotLine3 (X, Y, Z!, ZOld!, Tile$) STATIC

    FillColr = GPDat%(56) * 16 + GPDat%(57)
   
    'Retain a couple variables for quicker and simpler calculations below
    MoveX = GPDat%(41) * XaAspect#
    MoveY = GPDat%(41) * XbAspect#
    NewYCenter = GPDat%(38) + Y * GPDat%(41) * XbAspect# + MoveY

    'X Position of Data Points
    Mx1 = X * GPDat%(42) + GPDat%(37) - MoveX * Y - MoveX
    Mx0 = Mx1 - GPDat%(42)

    'Y Position of Data Points
    My1 = (Y + 1) * MoveY + GPDat%(38) - GPDat%(40) * (Z! - GPDat%(6)) / (GPDat%(5) - GPDat%(6))
    My0 = (Y + 1) * MoveY + GPDat%(38) - GPDat%(40) * (ZOld! - GPDat%(6)) / (GPDat%(5) - GPDat%(6))

    IF X > 0 THEN
       'Draw Top Face
       CALL FillPoly(Mx0, My0, Mx0 + MoveX, My0 - MoveY, Mx1, My1, Mx1 + MoveX, My1 - MoveY, FillColr)
       PAINT (Mx0 + MoveX - 1, My0 - MoveY + 2), Tile$, GPDat%(56)

       'Draw Left Side Face
       IF NewYCenter <> My0 THEN
         CALL FillPoly(Mx0, My0, Mx0, NewYCenter, Mx1, My1, Mx1, NewYCenter, FillColr)
         LINE (Mx1, My1)-(Mx1, NewYCenter), GPDat%(56)  'Fix End of Polygon
         PAINT (Mx0 + 1, NewYCenter - 1), Tile$, GPDat%(56)
       END IF
    END IF

    'Draw Right Side Face
    IF Z! > 0 THEN
      CALL FillPoly(Mx1, My1, Mx1, NewYCenter, Mx1 + MoveX, My1 - MoveY, Mx1 + MoveX, NewYCenter - MoveY, FillColr)
      'Fix Polygon Drawing
      LINE (Mx1 + MoveX, My1 - MoveY)-(Mx1 + MoveX, NewYCenter - MoveY), GPDat%(56)
      IF NewYCenter <> My1 THEN
          PAINT (Mx1 + 1, My1 + 1), Tile$, GPDat%(56)
      END IF
    END IF

END SUB

