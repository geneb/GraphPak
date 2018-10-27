'********** TextColr.Bas

'Extracts color to use for text that accompanies bars and lines.  Color is
'derived from first pixel of associated tile.  If color is black or near
'black, white is substituted.

'Copyright (c) 1987 Brian Giedt and Crescent Software

MaxTileNum = UBOUND(tile$)
REDIM TxtColor(MaxTileNum)
IF GPDat%(31) = 5 OR GPDat%(31) = 8 THEN
   FOR TxtColorf = 1 TO MaxTileNum
       TxtColor(TxtColorf) = 0
       FOR GP.t = 1 TO 4
	   TxtColor(TxtColorf) = TxtColor(TxtColorf) + SGN(ASC(MID$(tile$(TxtColorf), GP.t, 1)) AND 128) * (2 ^ (GP.t - 1))
       NEXT
       IF (TxtColor(TxtColorf) MOD 8) = (GPDat%(57) MOD 8) THEN TxtColor(TxtColorf) = GPDat%(56)
   NEXT
ELSEIF GPDat%(31) = 6 THEN
   FOR TxtColorf = 1 TO MaxTileNum
       TxtColor(TxtColorf) = 1
   NEXT
ELSE
   FOR TxtColorf = 1 TO MaxTileNum
       TxtColor(TxtColorf) = (ASC(MID$(tile$(TxtColorf), 1, 1)) AND 192) \ 64
       IF TxtColor(TxtColorf) = GPDat%(57) THEN TxtColor(TxtColorf) = GPDat%(56)
   NEXT
END IF

