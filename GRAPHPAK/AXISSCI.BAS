'********** AxisSci.Bas - subprograms to draw 2D Scientific background and
'                         axis patterns

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'These Declare statements are for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE SUB DrawText (Xx, Yy, Text$, Angle, Colr, TextSize#)
DECLARE SUB StepText (Xx, Yy, Text$, Angle, Colr, TextSize#)
DECLARE SUB DrawAxisSci ()
DECLARE FUNCTION GetTextWidth% (Text$)

'$INCLUDE: 'Common'

SUB DrawAxisSci STATIC

    'A Reminder of variables:
    '    GPData(8) is the X Coordinate of the center of the graph
    '    GPData(9) is the Y Coordinate of the center of the graph
    '    GPData(10) is the length of the graph along the X-Axis
    '    GPData(11) is the length of the graph along the Y-Axis

    'Setup the Axis Coordinates and lengths to fit the screen size
    IF GPDat%(37) = 0 THEN
      IF GPDat%(31) = 2 OR GPDat%(31) = 5 THEN   'EGA or Hercules
        GPDat%(37) = 70: GPDat%(38) = 250
        GPDat%(39) = 480: GPDat%(40) = 180
      ELSEIF GPDat%(31) = 8 THEN                  'VGA
        GPDat%(37) = 70: GPDat%(38) = 360
        GPDat%(39) = 480: GPDat%(40) = 280
      ELSEIF GPDat%(31) = 6 THEN                  'CGA 2 color mode
        GPDat%(37) = 50: GPDat%(38) = 135
        GPDat%(39) = 480: GPDat%(40) = 90
      ELSE                                        'CGA 4 color mode
        GPDat%(37) = 50: GPDat%(38) = 140
        GPDat%(39) = 230: GPDat%(40) = 90
      END IF
    END IF

    LINE (GPDat%(37), GPDat%(38) - GPDat%(40))-(GPDat%(37), GPDat%(38)), GPDat%(56)
    LINE -(GPDat%(37) + GPDat%(39), GPDat%(38)), GPDat%(56)

END SUB

SUB DrawBackSci (XTitle$(), YTitle$()) STATIC

    CALL DrawAxisSci

    'draw an enclosed area if called for
    IF GPDat%(4) THEN
       LINE (GPDat%(37), GPDat%(38) - GPDat%(40))-(GPDat%(37) + GPDat%(39), GPDat%(38) - GPDat%(40)), GPDat%(56)
       LINE -(GPDat%(37) + GPDat%(39), GPDat%(38)), GPDat%(56)
    END IF

    Colr = GPDat%(58)
    IF Colr = GPDat%(57) THEN Colr = GPDat%(56)
    T1 = GPDat%(37) + GPDat%(39) + 5
    T2 = GPDat%(38) - (GPDat%(40) + LEN(YTitle$(1)) * GPDat%(36)) \ 2
    CALL StepText(T1, T2, YTitle$(1), -90, Colr, 1#)

    T1 = GPDat%(37) + (GPDat%(39) - GetTextWidth%(XTitle$(1))) \ 2
    T2 = GPDat%(38) - GPDat%(40) - GPDat%(36)
    CALL DrawText(T1, T2, XTitle$(1), 0, Colr, 1#)

END SUB

