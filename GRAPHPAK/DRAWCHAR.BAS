'********** DrawChar.Bas - draws a single character

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'$INCLUDE: 'Common'

SUB DrawChar (X, Y, Letter, Colr, size#, Expand) STATIC

  Shift = INT(size# - .1)
  IF GPDat%(23) THEN
     Shift = Shift + INT(size#) \ 3 + 1
  END IF
  I = 1
  Char$ = Font$(Letter, GPDat%(34))    'Obtain the font in a local variable
  l = LEN(Char$)                        'and length of the string
  WHILE I < l
      P = ASC(MID$(Char$, I, 1))        'Break the first byte into two 4 bit
      X1 = (P MOD 16) * size#           'values showing x,y positioning of
      Y1 = (P \ 16) * size#             'the first point on a grid 16x16
      Q = ASC(MID$(Char$, I + 1, 1))    'Do the same with the second number
      X2 = (Q MOD 16) * size#
      Y2 = (Q \ 16) * size#
      'Draw the connecting line
      LINE (X1 + X, Y1 + Y)-(X2 + Shift + X, Y2 + Shift + Y), Colr, BF
      'position two bytes forward in the font string
      I = I + 2
  WEND

END SUB

SUB DrawCharA (X, Y, SAngle#, CAngle#, Letter, Colr, size#, Expand) STATIC

  'SEE DRAWCHAR FOR COMMENTS
  Shift# = INT(size# - .5)
  IF GPDat%(23) THEN
     Shift# = Shift# + INT(size#) \ 3 + 1
  END IF
  IF Expand THEN Shift# = Shift# + 1 + INT(size# / 10)
  I = 1
  Char$ = Font$(Letter, GPDat%(34))
  l = LEN(Char$)
  WHILE I < l
      P = ASC(MID$(Char$, I, 1))
      P1 = (P MOD 16) * size#
      P2 = (P \ 16) * size#
      Q = ASC(MID$(Char$, I + 1, 1))
      Q1 = (Q MOD 16) * size#
      Q2 = (Q \ 16) * size#
      IF GPDat%(24) <> 90 THEN
	X1 = P1 + P2 * CAngle# + X 'These calculations will tilt the character
	X2 = Q1 + Q2 * CAngle# + X
	Y1 = P2 + Y
	Y2 = Q2 + Y
      ELSE
	X1 = P1 * CAngle# + P2 * SAngle# + X 'These calculations will tilt the character
	X2 = Q1 * CAngle# + Q2 * SAngle# + X
	Y1 = P2 * CAngle# - P1 * SAngle# + Y
	Y2 = Q2 * CAngle# - Q1 * SAngle# + Y
      END IF
      Shift1# = Shift# * SAngle#
      'The section below will fill in the font depending on whether
      'the line is horizontal or vertical
      IF P1 <> Q1 THEN            'line is horizontal
	 FOR T = 0 TO Shift#
	     Part = T * SAngle#
	     LINE (X1 + Part, Y1 + T - Part)-(X2 + Part + Shift1# + Shift#, Y2 + T - Shift1# - Part), Colr
	 NEXT
      ELSEIF P2 = Q2 THEN         'just one pixel to be plotted
	 FOR T = 0 TO Shift#
	     Part = T * SAngle#
	     LINE (X1 + Part, Y1 + T - Part)-(X2 + Shift1# + Shift# + Part, Y2 + T - Shift1# - Part), Colr
	 NEXT
      ELSE                        'Line is vertical
	 FOR T = 0 TO Shift#
	     Part = T * SAngle#
	     LINE (X1 + T + Part, Y1 - Part)-(X2 + T + Shift1# + Part, Y2 - Part + Shift# - Shift1#), Colr
	 NEXT
      END IF
      I = I + 2
  WEND

END SUB

