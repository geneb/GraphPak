'********** 2DLine.Bas - subprogram to draw a single line

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'This Declare is for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE SUB FillPoly (A%, b%, c%, d%, e%, f%, g%, h%, Colr%)

'$INCLUDE: 'Common'

'This program draws a conventional line for use with 2D line graphs
'
SUB PlotLine (X, Y, Z!, Colr, Style) STATIC

    UpperOption = (Colr \ 256)
    Colr = Colr MOD 256
    'X position of plotted point
    IF GPDat%(21) THEN
        Mx1 = X * GPDat%(41) + GPDat%(37) + 1
    ELSE
        Mx1 = X * GPDat%(41) + GPDat%(37) + GPDat%(41) / 2
    END IF
    'Y position of plotted point
    My1 = GPDat%(38) - GPDat%(40) * (Z! - GPDat%(6)) / (GPDat%(5) - GPDat%(6))

    IF (X = GPDat%(28) - 1) OR (UpperOption MOD 16 > 0) THEN 'If first point then start
       PSET (Mx1, My1), Colr   ' with one pixel to allow for a continued line
    ELSE
       LINE -(Mx1, My1), Colr, , Style% 'Continue line from where we left off
    END IF
       
    'UpperOptions are used to make points stand out
    UpperOption = UpperOption \ 16
    IF UpperOption = 1 THEN                                     'Box
      LINE -STEP(-2, -2), Colr
      LINE -STEP(4, 4), Colr, BF
      LINE -STEP(-2, -2), Colr
    ELSEIF UpperOption = 2 THEN                                 'Circle
      CIRCLE (Mx1, My1), 1.5, Colr
      CIRCLE (Mx1, My1), 2, Colr
      CIRCLE (Mx1, My1), 2.5, Colr
      CIRCLE (Mx1, My1), 3, Colr
      CIRCLE (Mx1, My1), 3.5, Colr
    ELSEIF UpperOption = 3 THEN                                 'Asterisk
      LINE -STEP(-3, -3), Colr
      LINE -STEP(6, 6), Colr
      LINE STEP(-6, 0)-STEP(6, -6), Colr
      LINE STEP(-3, 0)-STEP(0, 6), Colr
      LINE STEP(-3, -3)-STEP(6, 0), Colr
      LINE -STEP(-3, 0), Colr           're-center for next LINE statement
    END IF


END SUB

'This program draws an area chart using lines
'
SUB PlotLineF (X, Y, Z!, ZOld!, Tile$) STATIC

    'Mx1 and My1 represent the point presently being plotted while
    'Mx0 and My0 represent the last point that was plotted

    'X position of plotted point
    IF GPDat%(21) THEN
        Mx1 = X * GPDat%(41) + GPDat%(37)
    ELSE
        Mx1 = X * GPDat%(41) + GPDat%(37) + GPDat%(41) \ 2
    END IF
    Mx0 = Mx1 - GPDat%(41)

    'Y Position of plotted point
    My1 = GPDat%(38) - GPDat%(40) * (Z! - GPDat%(6)) / (GPDat%(5) - GPDat%(6))
    My0 = GPDat%(38) - GPDat%(40) * (ZOld! - GPDat%(6)) / (GPDat%(5) - GPDat%(6))
    My2 = GPDat%(38)
    IF GPDat%(6) < 0 THEN
       My2 = GPDat%(38) + (GPDat%(6) / (GPDat%(5) - GPDat%(6))) * GPDat%(40)
    END IF

    IF X = 0 THEN                       'If first point then start with one
       PSET (Mx1, My1), GPDat%(56)      ' pixel to allow for a continued line
    ELSE
       CALL FillPoly(Mx0, My0, Mx0, My2, Mx1, My1, Mx1, My2, GPDat%(56) * 16 + GPDat%(57))
       IF My2 <> My1 THEN
         IF SGN(Z!) = 0 THEN A2 = SGN(ZOld!) ELSE A2 = SGN(Z!)
         A1 = My2 - A2
         WHILE POINT(Mx1 - 1, A1) <> GPDat%(56)
           PSET (Mx1, A1), GPDat%(56)
           A1 = A1 - A2
         WEND
       END IF
       IF NOT GPDat%(18) AND X > 1 THEN 'Use no line when possible, paint will be done later
           A = My0 + SGN(ZOld!)
           A1 = A
           A2 = POINT(Mx0 - 1, A)
           A3 = POINT(Mx0 + 1, A)
           B2 = 0: B3 = 0
           IF A2 = GPDat%(56) THEN B2 = -1
           IF A3 = GPDat%(56) THEN B3 = -1
           WHILE (NOT B2 OR NOT B3) AND (A * SGN(ZOld!) < (My2 - SGN(ZOld!)) * SGN(ZOld!))
             A = A + SGN(ZOld!)
             A2 = POINT(Mx0 - 1, A)
             A3 = POINT(Mx0 + 1, A)
             IF NOT B2 THEN IF A2 = GPDat%(56) THEN B2 = -1: A1 = A
             IF NOT B3 THEN IF A3 = GPDat%(56) THEN B3 = -1: A1 = A
           WEND
           IF (A * SGN(ZOld!)) >= (My2 - SGN(ZOld!)) * SGN(ZOld!) THEN A = A1
           LINE (Mx0, A)-(Mx0, My2 - SGN(ZOld!)), 0
       END IF
    END IF

END SUB

'This sub-program draws a High-Low-Close Graph Using Lines
'
SUB PlotLineHLC (X, Y, High!, Low!, Clos!, Colr, Style) STATIC

    'X Point Position. All parts use the same x position
    Mx1 = Y * GPDat%(41) + GPDat%(37) + X * GPDat%(42) + GPDat%(41) \ 2

    'Y Point Positions
    My1 = GPDat%(38) - GPDat%(40) * (Low! - GPDat%(6)) / (GPDat%(5) - GPDat%(6))
    My2 = GPDat%(38) - GPDat%(40) * (High! - GPDat%(6)) / (GPDat%(5) - GPDat%(6))
    My3 = GPDat%(38) - GPDat%(40) * (Clos! - GPDat%(6)) / (GPDat%(5) - GPDat%(6))

    LINE (Mx1, My2)-(Mx1, My1), Colr, , Style%    'Draw Line from High to Low

    LINE (Mx1 - 2, My3)-(Mx1 + 2, My3), Colr      'Draw Close tick mark

END SUB

SUB PlotLineS (X, Y, Z!, ZOld!, ZLow!, ZLowOld!, Tile$) STATIC

    'Mx1 and My1 represent the point presently being plotted while
    'Mx0 and My0 represent the last point that was plotted

    'X position of plotted point
    IF GPDat%(21) THEN
        Mx1 = X * GPDat%(41) + GPDat%(37)
    ELSE
        Mx1 = X * GPDat%(41) + GPDat%(37) + GPDat%(41) \ 2
    END IF
    Mx0 = Mx1 - GPDat%(41)

    'Y Position of plotted point
    My1 = GPDat%(38) - GPDat%(40) * (Z! - GPDat%(6)) / (GPDat%(5) - GPDat%(6))
    My0 = GPDat%(38) - GPDat%(40) * (ZOld! - GPDat%(6)) / (GPDat%(5) - GPDat%(6))
    My2 = GPDat%(38) - GPDat%(40) * (ZLow! - GPDat%(6)) / (GPDat%(5) - GPDat%(6))
    My3 = GPDat%(38) - GPDat%(40) * (ZLowOld! - GPDat%(6)) / (GPDat%(5) - GPDat%(6))
    IF GPDat%(6) < 0 THEN
       My2 = GPDat%(38) + (GPDat%(6) / (GPDat%(5) - GPDat%(6))) * GPDat%(40)
    END IF

    IF X = 0 THEN                       'If first point then start with one
       PSET (Mx1, My1), GPDat%(56)      ' pixel to allow for a continued line
    ELSE
       Colr = GPDat%(56) * 16 + GPDat%(57)
       CALL FillPoly(Mx0, My0, Mx0, My3, Mx1, My1, Mx1, My2, Colr)
       IF (NOT GPDat%(18)) AND (X > 1) THEN 'Keep Line in the graph so paint individual section
             'Use no line when possible, paint will be done later
           IF ZLowOld! <> ZOld! THEN
               A1 = My0 + SGN(ZOld!)
               IF ZOld! > ZOlder! THEN
                 A1 = My0
                 WHILE POINT(Mx0 - 1, A1) <> GPDat%(56)
                   A1 = A1 + SGN(ZOld!)
                 WEND
                 IF A1 = My0 THEN A1 = My0 + SGN(ZOld!)
               END IF
               A2 = My3 - SGN(ZOld!)
               IF ZLowOld! < ZLowOlder! THEN
                 A2 = My3
                 WHILE POINT(Mx0 - 1, A2) <> GPDat%(56)
                   A2 = A2 - SGN(ZOld!)
                 WEND
                 IF A2 = My3 THEN A2 = My3 - SGN(ZOld!)
               END IF
               IF A1 <= A2 THEN LINE (Mx0, A1)-(Mx0, A2), GPDat%(57)
           END IF
       END IF
    END IF
   
    ZLowOlder! = ZLowOld!
    ZOlder! = ZOld!
END SUB

