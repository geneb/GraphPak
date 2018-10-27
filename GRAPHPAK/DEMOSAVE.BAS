'********** DemoSave.Bas - demonstrates saving/restoring the graphics screen

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software


DEFINT A-Z
DECLARE SUB GScrnSaveRest (X!, Y!, OldX!, OldY!, Code!)
DECLARE SUB SetVideo ()

'$INCLUDE: 'GetVideo'

CALL SetVideo

LINE (30, 30)-(230, 130)                'create something to save/restore
CIRCLE (100, 80), 50
PAINT (101, 80), 4, 15

CALL GScrnSaveRest(30, 30, 200, 100, 0) 'save the screen from 30,30 to 200,100
					'0 means to save the screen contents
LOCATE 20, 1
PRINT "The screen is now saved - press a key to overwrite it"
WHILE INKEY$ = "": WEND

LINE (29, 29)-(231, 131), 2, BF

LOCATE 20, 1
PRINT "Now press another key to prove that the original save worked"
WHILE INKEY$ = "": WEND

CALL GScrnSaveRest(30, 30, 200, 100, 1)      'restore the screen, 1 means restore
