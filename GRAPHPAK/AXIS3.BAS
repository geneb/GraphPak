'********** Axis3.Bas - subprograms to draw 3D background and axis patterns

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'These Declare statements are for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE SUB DrawAxis3 ()
DECLARE SUB DrawPercent (ThreeDimensional%)

'$INCLUDE: 'Common'

'This sub-program sets up the axis information for 3D graphs
'
SUB DrawAxis3 STATIC

    'A Reminder of variables:
    '    GPData(8) is the X Coordinate of the center of the graph
    '    GPData(9) is the Y Coordinate of the center of the graph
    '    GPData(10) is the length of the graph along the X and Y Axis
    '    GPData(11) is the Height of the graph along the Z-Axis

    IF GPDat%(37) = 0 THEN     'User has not specified his coordinates so...
      'Setup the Axis Coordinates and lengths to fit the screen size
      IF GPDat%(31) = 2 OR GPDat%(31) = 5 THEN   'EGA or Hercules
	GPDat%(37) = 320: GPDat%(38) = 150
	GPDat%(39) = 190: GPDat%(40) = 100
      ELSEIF GPDat%(31) = 8 THEN                  'VGA
	GPDat%(37) = 320: GPDat%(38) = 200
	GPDat%(39) = 220: GPDat%(40) = 170
      ELSEIF GPDat%(31) = 6 THEN                  'CGA 2 color mode
	GPDat%(37) = 320: GPDat%(38) = 80
	GPDat%(39) = 140: GPDat%(40) = 70
      ELSE                                         'CGA 4 color mode
	GPDat%(37) = 175: GPDat%(38) = 90
	GPDat%(39) = 95: GPDat%(40) = 70
      END IF
    END IF

    'draw general axis
    LINE (GPDat%(37), GPDat%(38))-(GPDat%(37), GPDat%(38) - GPDat%(40)), GPDat%(56)
    LINE (GPDat%(37), GPDat%(38))-(GPDat%(37) + GPDat%(39) * YaAspect#, GPDat%(38) + GPDat%(39) * YbAspect#), GPDat%(56)
    LINE (GPDat%(37), GPDat%(38))-(GPDat%(37) - GPDat%(39) * XaAspect#, GPDat%(38) + GPDat%(39) * XbAspect#), GPDat%(56)

END SUB

'This sub-program handles the extra things for the 3D graphs
'
SUB DrawBackground3 (XTitle$(), YTitle$()) STATIC

    'draw the general axis
    CALL DrawAxis3
   
    'draw hash marks along back walls if called for
    IF GPDat%(3) THEN
	FOR T = GPDat%(40) TO 0 STEP -GPDat%(40) \ ((GPDat%(5) - GPDat%(6)) \ GPDat%(7)) 'draw hash marks along side wall
	    LINE (GPDat%(37) - GPDat%(39) * XaAspect#, GPDat%(38) + GPDat%(39) * XbAspect# - T)-(GPDat%(37), GPDat%(38) - T), GPDat%(56)
	    LINE -(GPDat%(37) + GPDat%(39) * YaAspect#, GPDat%(38) + GPDat%(39) * YbAspect# - T), GPDat%(56)
	NEXT
    END IF

    'draw the percentages along the Z-axis
    CALL DrawPercent(-1)

    'draw outlines to walls if called for
    IF GPDat%(4) THEN
	LINE (GPDat%(37), GPDat%(38) - GPDat%(40))-(GPDat%(37) + GPDat%(39) * YaAspect#, GPDat%(38) + GPDat%(39) * YbAspect# - GPDat%(40)), GPDat%(56)
	LINE -(GPDat%(37) + GPDat%(39) * YaAspect#, GPDat%(38) + GPDat%(39) * YbAspect#), GPDat%(56)
	LINE -(GPDat%(37) + GPDat%(39) * (YaAspect# - XaAspect#) - 1, GPDat%(38) + GPDat%(39) * (YbAspect# + XbAspect#)), GPDat%(56)
	LINE -(GPDat%(37) - GPDat%(39) * XaAspect#, GPDat%(38) + GPDat%(39) * XbAspect#), GPDat%(56)
	LINE -(GPDat%(37) - GPDat%(39) * XaAspect#, GPDat%(38) + GPDat%(39) * XbAspect# - GPDat%(40)), GPDat%(56)
	LINE -(GPDat%(37), GPDat%(38) - GPDat%(40)), GPDat%(56)
    END IF

    'tile Hashmarks if called for
    IF GPDat%(4) AND GPDat%(2) THEN
      T3 = GPDat%(38) - 2
      IF GPDat%(3) THEN           ' fill in hash marks along back walls
	 NewStep = GPDat%(40) \ ((GPDat%(5) - GPDat%(6)) \ GPDat%(7))
	 FOR T = T3 - GPDat%(40) + NewStep TO T3 STEP NewStep
	     PAINT (GPDat%(37) + 1, T), AltTile$(1), GPDat%(56)
	     PAINT (GPDat%(37) - 1, T), AltTile$(1), GPDat%(56)
	 NEXT
      ELSE                           ' fill in back walls
	 PAINT (GPDat%(37) + 1, T3), AltTile$(1), GPDat%(56)
	 PAINT (GPDat%(37) - 1, T3), AltTile$(1), GPDat%(56)
      END IF
    END IF

    'Paint Lower Plane if called for
    IF GPDat%(4) AND GPDat%(2) THEN
	PAINT (GPDat%(37), GPDat%(38) + 5), AltTile$(2), GPDat%(56)
    END IF

END SUB

