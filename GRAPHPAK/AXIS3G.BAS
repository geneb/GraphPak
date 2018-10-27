'********** Axis3G.Bas - subprograms to draw 3D background and axis patterns

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'This Declare statement is for QuickBASIC 4.0 - see DEMO.BAS

DECLARE SUB DrawAxis3G ()

'$INCLUDE: 'Common'

'This sub-program sets up the axis information for 3D surface graphs
'
SUB DrawAxis3G STATIC

    'A Reminder of variables:
    '    GPData(8) is the X Coordinate of the center of the graph
    '    GPData(9) is the Y Coordinate of the center of the graph
    '    GPData(10) is the length of the graph along the X and Y Axis
    '    GPData(11) is the Height of the graph along the Z-Axis

    'Setup the Axis Coordinates and lengths to fit the screen size
    IF GPDat%(31) = 2 OR GPDat%(31) = 5 THEN    'EGA or Hercules
	GPDat%(37) = 320: GPDat%(38) = 150
	GPDat%(39) = 190: GPDat%(40) = 100
    ELSEIF GPDat%(31) = 8 THEN                   'VGA
	GPDat%(37) = 320: GPDat%(38) = 210
	GPDat%(39) = 240: GPDat%(40) = 170
    ELSEIF GPDat%(31) = 6 THEN                   'CGA 2 color mode
	GPDat%(37) = 320: GPDat%(38) = 90
	GPDat%(39) = 140: GPDat%(40) = 70
    ELSE                                          'CGA 4 color mode
	GPDat%(37) = 175: GPDat%(38) = 100
	GPDat%(39) = 95: GPDat%(40) = 70
    END IF

    'Do some initial calculations
    LeftX = GPDat%(37) - GPDat%(39) * XaAspect#
    LeftY = GPDat%(38) + GPDat%(39) * XbAspect#

    'Draw small simulated axis on left side
    LINE (LeftX, LeftY)-(LeftX, LeftY - 10), GPDat%(56)
    LINE (LeftX, LeftY)-(LeftX + 10 * YaAspect#, LeftY + 10 * YbAspect#), GPDat%(56)
    LINE (LeftX, LeftY)-(LeftX + 10 * XaAspect#, LeftY - 10 * XbAspect#), GPDat%(56)

END SUB

'This sub-program sets up the extra information for 3D surface graphs
'
SUB DrawBackground4 STATIC

    'Draw a general axis indicator
    CALL DrawAxis3G

    'draw full outlines to walls if called for
    IF GPDat%(4) THEN
	LINE (GPDat%(37), GPDat%(38))-(GPDat%(37), GPDat%(38) - GPDat%(40)), GPDat%(56)
	LINE (GPDat%(37), GPDat%(38))-(GPDat%(37) + GPDat%(39) * YaAspect#, GPDat%(38) + GPDat%(39) * YbAspect#), GPDat%(56)
	LINE (GPDat%(37), GPDat%(38))-(GPDat%(37) - GPDat%(39) * XaAspect#, GPDat%(38) + GPDat%(39) * XbAspect#), GPDat%(56)
	LINE (GPDat%(37), GPDat%(38) - GPDat%(40))-(GPDat%(37) + GPDat%(39) * YaAspect#, GPDat%(38) + GPDat%(39) * YbAspect# - GPDat%(40)), GPDat%(56)
	LINE -(GPDat%(37) + GPDat%(39) * YaAspect#, GPDat%(38) + GPDat%(39) * YbAspect#), GPDat%(56)
	LINE -(GPDat%(37) + GPDat%(39) * (YaAspect# - XaAspect#) - 1, GPDat%(38) + GPDat%(39) * (YbAspect# + XbAspect#)), GPDat%(56)
	LINE -(GPDat%(37) - GPDat%(39) * XaAspect#, GPDat%(38) + GPDat%(39) * XbAspect#), GPDat%(56)
	LINE -(GPDat%(37) - GPDat%(39) * XaAspect#, GPDat%(38) + GPDat%(39) * XbAspect# - GPDat%(40)), GPDat%(56)
	LINE -(GPDat%(37), GPDat%(38) - GPDat%(40)), GPDat%(56)
    END IF

END SUB

