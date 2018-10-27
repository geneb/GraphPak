'********** Axis2.Bas - subprograms to draw 2D background and axis patterns

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'These Declare statements are for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE SUB DrawAxis2 ()
DECLARE SUB DrawPercent (ThreeDimensional%)

'$INCLUDE: 'Common'

'This sub-program sets up the axis information for 2D graphs
'
SUB DrawAxis2 STATIC

    'A Reminder of variables:
    '    GPData(8) is the X Coordinate of the center of the graph
    '    GPData(9) is the Y Coordinate of the center of the graph
    '    GPData(10) is the length of the graph along the X-Axis
    '    GPData(11) is the length of the graph along the Y-Axis

    'Setup the Axis Coordinates and lengths to fit the screen size
    IF GPDat%(37) = 0 THEN
      IF GPDat%(31) = 2 OR GPDat%(31) = 5 THEN    'EGA or Hercules
	GPDat%(37) = 54: GPDat%(38) = 260
	GPDat%(39) = 540: GPDat%(40) = 180
      ELSEIF GPDat%(31) = 8 THEN                   'VGA
	GPDat%(37) = 60: GPDat%(38) = 380
	GPDat%(39) = 480: GPDat%(40) = 305
      ELSEIF GPDat%(31) = 6 THEN                   'CGA 2 Color Mode
	GPDat%(37) = 50: GPDat%(38) = 120
	GPDat%(39) = 480: GPDat%(40) = 90
      ELSE                                         'CGA 4 Color Mode
	GPDat%(37) = 50: GPDat%(38) = 130
	GPDat%(39) = 230: GPDat%(40) = 90
      END IF
    END IF

    'Draw the General Axis Outline
    LINE (GPDat%(37), GPDat%(38) - GPDat%(40))-(GPDat%(37), GPDat%(38)), GPDat%(56)
    LINE -(GPDat%(37) + GPDat%(39), GPDat%(38)), GPDat%(56)

END SUB

'This sub-program handles the extra things for the 2D graphs
'
SUB DrawBackground2 (XTitle$(), YTitle$()) STATIC

    'Draw the general axis
    CALL DrawAxis2

    Shift = 0
    'Draw the Outline of graph area and paint it if called for
    IF GPDat%(4) THEN
	IF GPDat%(8) THEN
	    GPDat%(42) = GPDat%(39) \ (GPDat%(46) + 1) \ GPDat%(45)  'Individual bar size
	    Shift = GPDat%(42) - INT(.7 * GPDat%(42) + .5)
	    PSET (GPDat%(37), GPDat%(38) - GPDat%(40)), GPDat%(56)
	    LINE -STEP(Shift, -Shift), GPDat%(56)
	    LINE -STEP(GPDat%(39), 0), GPDat%(56)
	    LINE -STEP(0, GPDat%(40)), GPDat%(56)
	    LINE -STEP(-Shift, Shift), GPDat%(56)
	    PSET (GPDat%(37), GPDat%(38)), GPDat%(56)
	    LINE -STEP(Shift, -Shift), GPDat%(56)
	    LINE -STEP(0, -GPDat%(40)), GPDat%(56)
	    PSET (GPDat%(37) + Shift, GPDat%(38) - Shift), GPDat%(56)
	    LINE -STEP(GPDat%(39), 0), GPDat%(56)
	    LINE -STEP(0, -GPDat%(40)), GPDat%(56)
	    PSET (GPDat%(37) + GPDat%(39) + Shift, GPDat%(38) - Shift), GPDat%(56)
	    LINE -STEP(-Shift, Shift), GPDat%(56)
	    IF GPDat%(2) THEN
	       PAINT (GPDat%(37) + GPDat%(39) / 2, GPDat%(38) - 1), AltTile$(2), GPDat%(56)
	       PAINT (GPDat%(37) + 1, GPDat%(38) - GPDat%(40) / 2), AltTile$(2), GPDat%(56)
	    END IF
	ELSE
	    LINE (GPDat%(37), GPDat%(38) - GPDat%(40))-(GPDat%(37) + GPDat%(39), GPDat%(38) - GPDat%(40)), GPDat%(56)
	    LINE -(GPDat%(37) + GPDat%(39), GPDat%(38)), GPDat%(56)
	END IF
	IF GPDat%(2) THEN PAINT (GPDat%(37) + GPDat%(39) / 2, GPDat%(38) - GPDat%(40) / 2), AltTile$(1), GPDat%(56)
    END IF

    'Draw the Tick Marks if called for
    IF GPDat%(3) THEN
      IF GPDat%(15) = 0 OR GPDat%(15) = 2 THEN
	'draw hash marks along left side wall
	FOR T = GPDat%(40) TO 0 STEP -GPDat%(40) \ ((GPDat%(5) - GPDat%(6)) \ GPDat%(7))
	    LINE (GPDat%(37) - 5, GPDat%(38) - T)-(GPDat%(37), GPDat%(38) - T), GPDat%(56)
	    LINE -STEP(GPDat%(39), 0), GPDat%(56), , GPDat%(62)
	    IF GPDat%(8) AND GPDat%(4) AND GPDat%(62) THEN
	       LINE -STEP(Shift, -Shift), GPDat%(56), , GPDat%(62)
	       LINE -STEP(-GPDat%(39), 0), GPDat%(56), , GPDat%(62)
	       LINE -STEP(-Shift, Shift), GPDat%(56), , GPDat%(62)
	    END IF
	NEXT
      END IF
      IF GPDat%(15) = 1 OR GPDat%(15) = 2 THEN
	T2 = GPDat%(37) + GPDat%(39) + Shift
	'draw hash marks along right side wall
	FOR T = GPDat%(40) TO 0 STEP -GPDat%(40) \ ((GPDat%(5) - GPDat%(6)) \ GPDat%(7))
	    LINE (T2 + 5, GPDat%(38) - T - Shift)-(T2, GPDat%(38) - T - Shift), GPDat%(56)
	    LINE -STEP(-GPDat%(39), 0), GPDat%(56), , GPDat%(62)
	    IF GPDat%(8) AND GPDat%(4) AND GPDat%(62) THEN
	       LINE -STEP(-Shift, Shift), GPDat%(56), , GPDat%(62)
	       LINE -STEP(GPDat%(39), 0), GPDat%(56), , GPDat%(62)
	       LINE -STEP(Shift, -Shift), GPDat%(56), , GPDat%(62)
	    END IF
	NEXT
      END IF
    END IF

    'Draw the Percentages along the Y-Axis
    CALL DrawPercent(0)

    'Draw then X-Axis Zero Line
    IF GPDat%(54) AND (GPDat%(6) < 0) THEN
	D1 = (GPDat%(6) / (GPDat%(5) - GPDat%(6))) * GPDat%(40)
	LINE (GPDat%(37), GPDat%(38) + D1)-(GPDat%(37) + GPDat%(39), GPDat%(38) + D1), GPDat%(55)
	IF GPDat%(8) AND GPDat%(4) THEN
	   LINE -STEP(Shift, -Shift), GPDat%(55)
	   LINE -STEP(-GPDat%(39), 0), GPDat%(55)
	   LINE -STEP(-Shift, Shift), GPDat%(55)
	END IF
    END IF

END SUB

