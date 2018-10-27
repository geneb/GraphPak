'********** DrawText.Bas - subprograms to draw a string of text

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'These Declare statements are for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE SUB DrawChar (X%, Y%, Letter%, Colr%, Size#, Expand%)
DECLARE SUB DrawCharA (X%, Y%, SAngle#, CAngle#, Letter%, Colr%, Size#, Expand%)

'$INCLUDE: 'Common'

'This sub-program draws characters horizontally, or at an angle
'
SUB DrawText (Xx, Yy, Text$, Angle, Colr, TextSize#) STATIC

    SColor = GPDat%(14)          'get shadow color

    Size# = TextSize#            'use copies to preserve incoming vars
    X = Xx
    Y = Yy
    Expand = 0

    IF Size# < .001 THEN Size# = 1!
    'Prepare some variables that will be repeatedly used
    SAngle# = SIN((Angle / 180) * (22 / 7))
    CAngle# = COS((Angle / 180) * (22 / 7))
    NewColr = Colr AND 255
    IF NewColr > 127 THEN          'if shadow then calculate size of shadow
	Ofsx = 1 + Size# * .6
	Ofsy = 1 + Size# * .3
    END IF                      'otherwise we don't care about the values
				'  of Ofsx and Ofsy
    IF Angle <> 0 OR GPDat%(24) <> 90 THEN
	IF GPDat%(24) <> 90 THEN
	    SAngle# = 0
	    CAngle# = -COS(((GPDat%(24)) / 180) * (22 / 7))
	    FOR T = 1 TO LEN(Text$)
	      'Give a value 1-95 as an offset into the font set
	      Letter = ASC(MID$(Text$, T, 1)) - 31
	      'If shadowing then draw the shadow first
	      IF NewColr > 127 THEN CALL DrawCharA(X + Ofsx, Y + Ofsy, SAngle#, CAngle#, Letter, SColor, Size#, Expand)
	      'Draw the character
	      CALL DrawCharA(X, Y, SAngle#, CAngle#, Letter, (NewColr MOD 128), Size#, Expand)
	      'Calculate position for next character to be drawn
	      X = X + (FontWidth%(Letter, GPDat%(34)) + GPDat%(48) + GPDat%(59)) * Size#
	    NEXT
	ELSE
	  FOR T = 1 TO LEN(Text$)
	    'Give a value 1-95 as an offset into the font set
	    Letter = ASC(MID$(Text$, T, 1)) - 31
	    'If shadowing then draw the shadow first
	    IF NewColr > 127 THEN CALL DrawCharA(X + Ofsx, Y + Ofsy, SAngle#, CAngle#, Letter, SColor, Size#, Expand)
	    'Draw the character
	    CALL DrawCharA(X, Y, SAngle#, CAngle#, Letter, (NewColr MOD 128), Size#, Expand)
	    'Calculate position for next character to be drawn
	    X = X + CAngle# * (FontWidth%(Letter, GPDat%(34)) + GPDat%(48) + GPDat%(59)) * Size#
	    Y = Y - SAngle# * (FontWidth%(Letter, GPDat%(34)) + GPDat%(48) + GPDat%(59)) * Size#
	  NEXT
	END IF
    ELSE
	FOR T = 1 TO LEN(Text$)
	    'SEE ABOVE FOR COMMENTS
	    Letter = ASC(MID$(Text$, T, 1)) - 31
	    IF NewColr > 127 THEN CALL DrawChar(X + Ofsx, Y + Ofsy, Letter, SColor, Size#, Expand)
	    CALL DrawChar(X, Y, Letter, (NewColr MOD 128), Size#, Expand)
	    X = X + (FontWidth%(Letter, GPDat%(34)) + GPDat%(48) + GPDat%(59)) * Size#
	NEXT
    END IF

END SUB

'This subprogram draws text at angle while always keeping the letters at
'90 degree angles
'
SUB StepText (Xx, Yy, Text$, Angle, Colr, TextSize#) STATIC

    Size# = TextSize#               'use copies (see DrawText above)
    X = Xx
    Y = Yy
    Expand = -1

    IF Size# < .001 THEN Size# = 1!
    IF INT(Size# * 1000) <= 1000 THEN Expand = 0
    MSAngle = SIN((Angle / 180) * (22 / 7)) * GPDat%(36)
    MCAngle = COS((Angle / 180) * (22 / 7)) * GPDat%(35)
    NewColr = Colr AND 255
    IF NewColr > 127 THEN       'if shadow then calculate size of shadow
      Ofsx = 1 + Size# * .6
      Ofsy = 1 + Size# * .3
    END IF                      'otherwise we don't care about the values
				'  of Ofsx and Ofsy
   
    IF GPDat%(24) <> 90 THEN
      SAngle# = 0
      CAngle# = -COS(((GPDat%(24)) / 180) * (22 / 7))
      FOR T = 1 TO LEN(Text$)
	Letter = ASC(MID$(Text$, T, 1)) - 31
	IF NewColr > 127 THEN CALL DrawCharA(X + Ofsx, Y + Ofsy, SAngle#, CAngle#, Letter, SColor, Size#, Expand)
	CALL DrawCharA(X, Y, SAngle#, CAngle#, Letter, (NewColr MOD 128), Size#, Expand)
	X = X + MCAngle
	Y = Y - MSAngle
      NEXT
    ELSE
      FOR T = 1 TO LEN(Text$)
	Letter = ASC(MID$(Text$, T, 1)) - 31
	Offset = (GPDat%(35) - FontWidth%(Letter, GPDat%(34))) \ 2
	IF NewColr > 127 THEN CALL DrawChar(X + Offset + Ofsx, Y + Ofsy, Letter, SColor, Size#, Expand)
	CALL DrawChar(X + Offset, Y, Letter, (NewColr MOD 128), Size#, Expand)
	X = X + MCAngle
	Y = Y - MSAngle
      NEXT
    END IF

END SUB

