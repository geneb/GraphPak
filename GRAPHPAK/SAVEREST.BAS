'********** SaveRest.Bas - saves and restores portions of the graphics screen

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'$INCLUDE: 'Common'

DEFSNG A-Z
SUB GScrnSaveRest (X, Y, OldX, OldY, Code) STATIC

    STATIC Stored       'prevents an error if a screen isn't already saved

    IF Code = 0 THEN
	F = 4 + INT((OldX * 4 + 7) / 8) * OldY
	IF F > FRE(-1) THEN EXIT SUB
	REDIM Array%(F + 1)
	GET (X, Y)-(X + OldX, Y + OldY), Array%
	Stored = 1
    ELSE
	IF Stored = 1 THEN PUT (X, Y), Array%, PSET
    END IF

END SUB

