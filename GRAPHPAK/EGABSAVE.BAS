'EGABSave.Bas

'Copyright (c) 1988 Crescent Software


DEFINT A-Z
DECLARE SUB EGABSave (FileName$)
DECLARE SUB EGABLoad (FileName$)

SCREEN 9
LOCATE 25, 1
PRINT "Press a key to stop the show, and save the screen to disk.";

WHILE INKEY$ = ""
    T = (T MOD 150) + 1
    C = (C + 1) MOD 16
    LINE (T, T)-(300 - T, 300 - T), C, B
    LINE (300 + T, T)-(600 - T, 300 - T), C, B
WEND

LOCATE 25, 1
PRINT "Thank You!"; TAB(75);
CALL EGABSave("Test")

CLS
LOCATE 25, 1
PRINT "Now press a key to read the screen back in from disk.";
WHILE INKEY$ = "": WEND
LOCATE 25, 1
PRINT TAB(75);

'EGABLoad is set up to load a screen to page 1 to prevent the loading from
'showing.  The PCOPY below then copies the hidden page 1 to page 0 to quickly
'display the image.  If you want the screen loaded into page zero, change the
'32767 address to 0 in EGABLoad.

CALL EGABLoad("Test")
PCOPY 1, 0

SUB EGABLoad (FileName$) STATIC

    F$ = FileName$
    X = INSTR(F$, ".")
    IF F THEN F$ = LEFT$(F$, X - 1)

    'UnREM each KILL below to erase the images after loading

    DEF SEG = &HA000
    OUT &H3C4, 2: OUT &H3C5, 1: BLOAD F$ + ".BLU", 32768  'change 32768 to 0
    'KILL F$ + ".BLU"                                     '  to load page 0
    OUT &H3C4, 2: OUT &H3C5, 2: BLOAD F$ + ".GRN", 32768
    'KILL F$ + ".GRN"
    OUT &H3C4, 2: OUT &H3C5, 4: BLOAD F$ + ".RED", 32768
    'KILL F$ + ".RED"
    OUT &H3C4, 2: OUT &H3C5, 8: BLOAD F$ + ".INT", 32768
    'KILL F$ + ".INT"
    OUT &H3C4, 2: OUT &H3C5, 15

END SUB

SUB EGABSave (FileName$) STATIC

    F$ = FileName$
    X = INSTR(F$, ".")
    IF F THEN F$ = LEFT$(F$, X - 1)

    DEF SEG = &HA000
    OUT &H3CE, 4: OUT &H3CF, 0: BSAVE F$ + ".BLU", 0, 28000 'Use 38400 for VGA
    OUT &H3CE, 4: OUT &H3CF, 1: BSAVE F$ + ".GRN", 0, 28000
    OUT &H3CE, 4: OUT &H3CF, 2: BSAVE F$ + ".RED", 0, 28000
    OUT &H3CE, 4: OUT &H3CF, 3: BSAVE F$ + ".INT", 0, 28000
    OUT &H3CE, 4: OUT &H3CF, 0

END SUB

