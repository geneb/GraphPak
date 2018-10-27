'***** DEMOPCX.BAS - This file demostrates saving an EGA screen to a file
'                    using the .PCX format used in PC Paintbrush

'Copyright (c) 1988 Crescent Software and Brian C. Giedt

DEFINT A-Z

'The following DECLARE statements are for QB4.0

DECLARE SUB PCXSaveFile (FileName$)
DECLARE SUB PCXLoadFile (FileName$)

SCREEN 9

FOR T = 1 TO 100                        'Draw some boxes on the screen
    u = RND * 640
    v = RND * 350
    w = RND * 400
    x = RND * 200
    C = (C MOD 15) + 1
    LINE (u, v)-(u + w, v + x), C, BF
NEXT

CIRCLE (200, 200), 200, 15               'And a circle for good measure
PAINT (200, 200), 1, 15

FileName$ = "Test.PCX"                   'Store in the file TEST.PCX

CALL PCXSaveFile(FileName$)              'Save the screen
LOCATE 25, 27                            'Pause for a keystroke
PRINT "Press Any Key To Continue";
WHILE INKEY$ = "": WEND
CLS

CALL PCXLoadFile(FileName$)              'Restore the screen
WHILE INKEY$ = "": WEND
