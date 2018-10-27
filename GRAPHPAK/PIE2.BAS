'********** Pie2.Bas - draws a complete 2D pie chart or with a 3D perspective

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'These Declare statements are for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE SUB DrawText (Xx, Yy, Text$, Angle, Colr, TextSize#)
DECLARE SUB Doline (X1, Y1, X2, Y2, Colr)
DECLARE SUB DisplayTitle (Title$)
DECLARE FUNCTION GetTextWidth% (Text$)

'$INCLUDE: 'Common'

'This program draws a 2D or 3D pie chart
'
SUB Pie (GraphData!(), XTitle$(), MainTitle$) STATIC

    Angle = GPDat%(10)        'Get Angle From XAngle location
    'If Angle is greater than 40 then create a 3D pie chart

    'This is how Pie.Bas utilizes the default aspect ratio.  Circles will use
    'this automatically, but the lines drawn with use of the SIN function need
    'this value to be known to them.
    Turn# = GPDat%(49) / 1000

    IF GPDat%(31) = 5 OR GPDat%(31) = 8 THEN  'EGA / VGA
       Colr = 9
    ELSE        'CGA / HERC
       Colr = 1
    END IF

    IF GPDat%(37) = 0 THEN
       IF GPDat%(31) = 2 OR GPDat%(31) = 5 THEN  'EGA
	  PieSize = 164            'radius of circle in pixels
	  Lr = 188                 'radius of pie piece removed from pie
	  Cx = 300                 'center for X position
	  Cy = 180                 'center for Y position
       ELSEIF GPDat%(31) = 8 THEN                 'VGA
	  PieSize = 210
	  Lr = 234
	  Cx = 300
	  Cy = 240
       ELSEIF GPDat%(31) = 6 THEN                 'CGA
	  PieSize = 120                 'radius of circle in pixels
	  Lr = 140                      'radius of pie piece removed from pie
	  Cx = 300                      'center for X position
	  Cy = 100                      'center for Y position
       ELSE
	  PieSize = 80
	  Lr = 94
	  Cx = 140
	  Cy = 100
       END IF
    ELSE
       Cx = GPDat%(37)
       Cy = GPDat%(38)
       Lr = GPDat%(39)
       PieSize = GPDat%(40)
    END IF
    GPDat%(37) = 0

    PieIs# = 3.1415926#
    Sum! = 0
    N = UBOUND(XTitle$) - 1

    REDIM Radians#(N)                   'N pieces of the pie

    IF Angle > 40 THEN
       Turn# = COS(Angle * (22 / 7) / 180)
       Height = PieSize \ 5
    ELSE
       Angle = 0
    END IF

    FOR I = 1 TO N                              'proportionalize pie to the
	Sum! = Sum! + GraphData!(I)             '  sum of its parts
    NEXT
    FOR I = 1 TO N
	Radians#(I) = GraphData!(I) / Sum!
    NEXT

    CALL DisplayTitle(MainTitle$)

    '$INCLUDE: 'TextColr.Bas'

    TextSize# = 1!
    Angle2# = 0                                 'Angle2# initialized to 0

    FOR C = 1 TO N
	Angle1# = Angle2#                              'retain last angle
	Angle2# = Angle2# + Radians#(C) * 2 * PieIs#   'add radians
	IF Angle2# > 2 * PieIs# THEN Angle2# = 2 * PieIs#
	AvgAngle# = (Angle1# + Angle2#) / 2

	'The Following lines will cause the program not to attempt to paint
	'a pie piece whos size is too small.
	TooSmall = 0
	IF (Angle2# - Angle1#) < .1 THEN TooSmall = -1

	IF Angle > 0 THEN                       'do a three dimensional pie
	   OldCx = Cx
	   OldCy = Cy
	   IF (C = N AND GPDat%(17) = 1) OR GPDat%(17) = 2 THEN                        'remove last piece of the pie
	      Cx = Cx + COS(AvgAngle#) * (Lr - PieSize)
	      Cy = Cy - SIN(AvgAngle#) * (Lr - PieSize) * Turn#
	   END IF
	   IF Radians#(C) > .0001 THEN
	       CIRCLE (Cx, Cy), PieSize, GPDat%(56), (-1) * (Angle1# + .001), (-1) * Angle2#, Turn#
	   END IF
	   PAngle1# = Angle1# + .001
	   PAngle2# = Angle2#

	   IF PAngle1# < PieIs# THEN
	      IF PAngle2# > PieIs# THEN
		 PAngle1# = PieIs#
	      ELSE
		 PAngle2# = -1
	      END IF
	   END IF
	   IF PAngle2# > 0 THEN         'working with the front pie pieces
					'first draw the other circle
	      IF Radians#(C) > .0001 THEN
		  CIRCLE (Cx, Cy + Height), PieSize, GPDat%(56), PAngle1#, PAngle2#, Turn#
	      END IF
	      Pr = PieSize
	      P1# = ABS(PAngle1#)
	      P2# = ABS(PAngle2#)

					'now draw the connecting lines
	      LINE (Cx + COS(P1#) * Pr, Cy - SIN(P1#) * Pr * Turn#)-(Cx + COS(P1#) * Pr, Cy - SIN(P1#) * Pr * Turn# + Height), GPDat%(56)
	      LINE (Cx + COS(P2#) * Pr, Cy - SIN(P2#) * Pr * Turn#)-(Cx + COS(P2#) * Pr, Cy - SIN(P2#) * Pr * Turn# + Height), GPDat%(56)

	      IF (C = N AND GPDat%(17) = 1) OR GPDat%(17) = 2 THEN
		 'this is the piece we have to pull away from the pie
		 IF PAngle1# > PieIs# * 3 / 2 THEN
					'these next 2 lines don't always get
					'completed so call a special routine
		    CALL Doline(CINT(Cx + COS(P1#) * Pr), CINT(Cy - SIN(P1#) * Pr * Turn# + Height), CINT(Cx), CINT(Cy + Height), GPDat%(56))
		    CALL Doline(CINT(Cx), CINT(Cy), CINT(Cx), CINT(Cy + Height), GPDat%(56))
					'paint inner pie piece
		    IF NOT TooSmall AND (P1# > (1.5 * PieIs# + .1) OR P1# < (1.5 * PieIs# - .1)) THEN
		      PAINT (Cx + COS(P1#) * Pr - 1, Cy - SIN(P1#) * Pr * Turn# + Height \ 2), tile$(((C - 1) MOD MaxTileNum) + 1), GPDat%(56)
		    END IF
		 END IF
	      END IF

	      PAvgAngle# = (PAngle1# + PAngle2#) / 2
					'finally paint area between circles
	      'Use A REM on the next line (containing PAINT) if you have
	      'the version of buggy QB 4.0 that draws circles incorrectly
	      IF NOT TooSmall THEN
		PAINT (Cx + COS(PAvgAngle#) * PieSize, Cy - SIN(PAvgAngle#) * PieSize * Turn# + Height \ 2), tile$(((C - 1) MOD MaxTileNum) + 1), GPDat%(56)
	      END IF
	   END IF

	   IF NOT TooSmall THEN
	      PAINT (Cx + COS(AvgAngle#) * .8 * PieSize, Cy - SIN(AvgAngle#) * .8 * PieSize * Turn#), tile$(((C - 1) MOD MaxTileNum) + 1), GPDat%(56)
	   END IF

	   IF COS(AvgAngle#) > 0 THEN
	      Lx = Cx + COS(AvgAngle#) * PieSize + 8
	      IF AvgAngle# > PieIs# THEN
		  Lx = Lx + Height
	      ELSE
		  Lx = Lx + Height * COS(AvgAngle#)
	      END IF
	   ELSE
	      Lx = Cx + COS(AvgAngle#) * (PieSize) - GetTextWidth%(XTitle$(C + 1))
	   END IF

	   Ly = Cy - SIN(AvgAngle#) * (PieSize + GPDat%(36) / 2) * Turn#
	   IF AvgAngle# > PieIs# THEN
	      Ly = Ly + Height
	   ELSE
	      Ly = Ly - Height * SIN(AvgAngle#)
	   END IF
	   Cx = OldCx
	   Cy = OldCy
	ELSE                                    'do a normal pie chart
	   OldCx = Cx
	   OldCy = Cy
	   IF (C = N AND GPDat%(17) = 1) OR GPDat%(17) = 2 THEN
	      'remove last piece of the pie
	      Cx = Cx + COS(AvgAngle#) * (Lr - PieSize)
	      Cy = Cy - SIN(AvgAngle#) * (Lr - PieSize)
	   END IF
	   IF Radians#(C) > .0001 THEN
	       CIRCLE (Cx, Cy), PieSize, GPDat%(56), -1 * (Angle1# + .001), -1 * Angle2#
	   END IF
	   IF NOT TooSmall THEN
	     PAINT (Cx + COS(AvgAngle#) * .4 * PieSize, Cy - Turn# * SIN(AvgAngle#) * .4 * PieSize), tile$(((C - 1) MOD MaxTileNum) + 1), GPDat%(56)
	   END IF

	   IF COS(AvgAngle#) > 0 THEN
	      Lx = Cx + COS(AvgAngle#) * PieSize + 8
	   ELSE
	      Lx = Cx + COS(AvgAngle#) * (PieSize) - GetTextWidth%(XTitle$(C + 1)) - 8
	   END IF
	   Ly = Cy - Turn# * SIN(AvgAngle#) * (PieSize + GPDat%(36) / 2)
	   IF SIN(AvgAngle#) > 0 THEN Ly = Ly - 12
	   Cx = OldCx
	   Cy = OldCy
	END IF

	'draw titles - the variables lx and ly will position them
	IF GPDat%(1) THEN
	  CALL DrawText((Lx), (Ly), XTitle$(C + 1), 0, TxtColor((C - 1) MOD MaxTileNum + 1), TextSize#)
	  'unREM the following line to display the percentages
'          CALL DrawText(Lx + LEN(XTitle$(C + 1)), Ly + 14, STR$(INT(Radians#(C) * 1000) / 10) + "%", 0, 9, TextSize#)
	END IF
    NEXT C

END SUB

