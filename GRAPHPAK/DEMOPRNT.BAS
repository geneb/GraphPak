'********** DemoPrnt.Bas - demonstrates calling EGAPrint

'Copyright (c) 1987 Ethan Winer


DEFINT A-Z
DECLARE SUB EGAPrint ()

SCREEN 9                                        'display a color test pattern
FOR X = 1 TO 150 STEP 2.5
    LINE (X + 300, X)-(300 - X, 300 - X), RND(1) * 6 + 1, B
NEXT

CALL EGAPrint                                   'print screen, ignore colors
LPRINT CHR$(12);                                'send CRLF to eject the page
