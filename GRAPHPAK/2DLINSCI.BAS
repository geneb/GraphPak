'********** 2DLinSci.Bas - subprogram to draw a single line

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software


'$INCLUDE: 'Common'

DEFINT A-Z
SUB PlotLineSci (X!, Y!, Colr, Style, Options) STATIC

'  Options:     1  -  draw a dot at the current location
'               2  -  draw a connected line at the current location
'
' NOTE: If option 2 is used, it is evident that Option 1 was used for the
'       first dot of the line

    IF Options MOD 16 = 1 THEN
    'if first point then start with one pixel to allow for a continued line
	PSET (GPDat%(37) + X!, GPDat%(38) - Y!), Colr
    ELSEIF Options MOD 16 = 2 THEN
    'else continue line from where we left off
	LINE -(GPDat%(37) + X!, GPDat%(38) - Y!), Colr, , Style%
    END IF

    'UpperOptions are used to make points stand out
    UpperOption = Options \ 16
    IF UpperOption = 1 THEN                                     'Box
       LINE -STEP(-2, -2), Colr
       LINE -STEP(4, 4), Colr, BF
       're-center for next LINE command
       PSET (GPDat%(37) + X!, GPDat%(38) - Y!), Colr
    ELSEIF UpperOption = 2 THEN                                 'Circle
       CIRCLE (GPDat%(37) + X!, GPDat%(38) - Y!), 1.5, Colr
       CIRCLE (GPDat%(37) + X!, GPDat%(38) - Y!), 2, Colr
       CIRCLE (GPDat%(37) + X!, GPDat%(38) - Y!), 2.5, Colr
       CIRCLE (GPDat%(37) + X!, GPDat%(38) - Y!), 3, Colr
       CIRCLE (GPDat%(37) + X!, GPDat%(38) - Y!), 3.5, Colr
       CIRCLE (GPDat%(37) + X!, GPDat%(38) - Y!), 4, Colr
    ELSEIF UpperOption = 3 THEN                                 'Asterisk
       LINE -STEP(-3, -3), Colr
       LINE -STEP(6, 6), Colr
       LINE STEP(-6, 0)-STEP(6, -6), Colr
       LINE STEP(-3, 0)-STEP(0, 6), Colr
       LINE STEP(-3, -3)-STEP(6, 0), Colr
       LINE -STEP(-3, 0), Colr           're-center for next LINE statement
    END IF

END SUB

