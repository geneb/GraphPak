'********** ReadTile.Bas - Read In Tile Formulas from .TIL files

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'----- The SCRN?.TIL files contain the tiling patterns that will be used
'      to paint bars and portions of the pie.  As supplied, they contain
'      solid colors, though you can select any combination of tiles with
'      the tile editor (TILES.EXE).  The ALT?.TIL files contain the tiles
'      that are used for the various background patterns.

'Follow these instructions if you want to eliminate the Alternate Tiles:
'
'  First, make sure GPDat%(2) = 0
'  Second, place an addition comment line before each of the includes below
'    which specify and ALT?.TIL file
'  Third, comment out the last lines of this file
'


'----- read in the appropriate tile files
IF GPDat%(31) = 5 OR GPDat%(31) = 8 THEN
SCRN9.REST:                    
   '$INCLUDE: 'Scrn9.Til'               'sets bars tiles for EGA
   '$INCLUDE: 'Alt9.Til'                'sets alternate tiles for EGA
   RESTORE SCRN9.REST
ELSEIF GPDat%(31) = 6 OR GPDat%(31) = 2 THEN
SCRN2.REST:
   '$INCLUDE: 'Scrn2.Til'               'sets bars tiles for Hi-Res
   '$INCLUDE: 'Alt2.Til'                'sets alternate tiles for Hi-Res
   RESTORE SCRN2.REST
ELSE
SCRN1.REST:
   '$INCLUDE: 'Scrn1.Til'               'sets CGA tiles for bars
   '$INCLUDE: 'Alt1.Til'                'sets alternate tiles for CGA
   RESTORE SCRN1.REST
END IF

REDIM SHARED Tile$(GP.STiles%)          'holds the primary bar and pie tiles
FOR GP.Tile = 1 TO GP.STiles%           'GP.STiles% is defined in Scrn#.Til
    Tile$(GP.Tile) = SPACE$(GP.TilWid%)
    FOR GP.Count = 1 TO GP.TilWid%
        READ GP.Read
        MID$(Tile$(GP.Tile), GP.Count) = CHR$(GP.Read)
    NEXT
NEXT

'If you are eliminating the Alternate tiles you can comment out the rest of
'the lines from here on in this file
REDIM SHARED AltTile$(GP.ATiles%)       'holds the alternate background tiles
FOR GP.Tile = 1 TO GP.ATiles%           'GP.ATiles% is defined in Alt#.Til
    AltTile$(GP.Tile) = SPACE$(GP.TilWid%)
    FOR GP.Count = 1 TO GP.TilWid%
        READ GP.Read
        MID$(AltTile$(GP.Tile), GP.Count) = CHR$(GP.Read)
    NEXT
NEXT

