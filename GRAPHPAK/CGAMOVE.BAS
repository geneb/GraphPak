'********** CGAMove.Bas - scrolls the CGA

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

'$INCLUDE: 'Common'

SUB CGAMove (X, Y, OldX, OldY, XDist, YDist) STATIC

    F = 4 + INT((OldX * 4 + 7) / 8) * OldY
    IF F > FRE(-1) THEN EXIT SUB

    IF GPDat%(31) = 5 THEN
	MaxColumn = 639
	MaxRow = 349
    ELSEIF GPDat%(31) = 4 THEN
	MaxColumn = 319
	MaxRow = 199
    ELSEIF GPDat%(31) = 6 THEN
	MaxColumn = 639
	MaxRow = 199
    ELSEIF GPDat%(31) = 2 THEN
	MaxColumn = 719
	MaxRow = 349
    ELSEIF GPDat%(31) = 8 THEN
	MaxColumn = 639
	MaxRow = 479
    END IF

    A = X + XDist
    B = Y + YDist
    IF A < 0 OR A > MaxColumn - OldX THEN EXIT SUB
    IF B < 0 OR B > MaxRow - OldY THEN EXIT SUB

    REDIM Array%(F + 1)
    GET (X, Y)-(X + OldX, Y + OldY), Array%
    PUT (X + XDist, Y + YDist), Array%
    PUT (X, Y), Array%
    ERASE Array%

END SUB

