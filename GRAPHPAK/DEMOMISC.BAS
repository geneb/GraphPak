'********** DemoMisc.Bas

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software


'This program demonstrates some clever graphic techniques.  The first demo
'shows Brian's multi-tasking technique that displays a text stream with word
'wrap, while continually flashing a border on the screen.  The second shows
'an effective way to draw 3-D spheres.  The third illustrates technique for
'saving/restoring screens using the PCOPY command.
'
'These programs have nothing whatsoever to do with GraphPak, and are
'included purely for fun.  They do, however, require an EGA or VGA display.


DEFINT A-Z
DECLARE SUB Sphere (X%, Y%, Colr%, Radius%)

MaxColor = 15
MaxBorder = 31
MaxColumn = 640
MaxRow = 350

SCREEN 9
C = 2
COLOR C

    LM = 10
    RM = 60
    S = LM + 5
    T = 6

WHILE INKEY$ = ""
    IF T$ = "" THEN READ T$: S = S + 2
    a$ = LEFT$(T$, 1)
    T$ = MID$(T$, 2)
    IF POS(0) > RM AND a$ = " " THEN
       T = T + 1
       IF T > 19 THEN T = 6
       S = LM - 1
    END IF
    LOCATE T, S
    PRINT a$;
    S = S + 1
    GOSUB Multi.Border
    IF a$ = "-" THEN
       T = T + 2
       IF T > 19 THEN T = 6
       S = LM + 5
       RESTORE
       C = (C MOD 15) + 1
       COLOR C
    END IF
WEND

CLS
WHILE INKEY$ = ""               'draw random spheres until a keypress
    X = RND * 640               'use random X/Y axis
    Y = RND * 350
    R = RND * 100               'use random radius
    C = RND * 15 + 1            'and random color
    CALL Sphere(X, Y, C, R)
WEND

COLOR 7
CLS
LOCATE 25, 1
PRINT "Press a key to stop the show, and save the screen to page 1";

WHILE INKEY$ = ""
    T = (T MOD 150) + 1
    C = (C + 1) MOD 16
    LINE (T, T)-(300 - T, 300 - T), C, B
    LINE (300 + T, T)-(600 - T, 300 - T), C, B
WEND

PCOPY 0, 1
CLS
PRINT "Press a key to redisplay the saved screen"
WHILE INKEY$ = "": WEND
PCOPY 1, 0

END

Multi.Border:
   Border = Border - 1
   IF Border < 1 THEN Border = MaxBorder
   LINE (Border, Border)-(MaxColumn - Border, MaxRow - Border), BorderClr + 1, B
   BorderClr = (BorderClr + 1) MOD MaxColor
   RETURN

DATA "This is some sample text, being displayed while the background is changing."
DATA "This is due to a unique multitasking capability built into the BASIC language."
DATA "The program can work with me (this text) without disrupting the flow of the border by using a proper timeslice."
DATA "Press any key to continue to the next demonstration -"

SUB Sphere (X, Y, Colr, Radius) STATIC

   CIRCLE (X, Y), Radius, Colr, , , .07
   FOR I = 2 TO 10
      CIRCLE (X, Y), Radius, Colr, , , I * .1
   NEXT

   B# = .2
   C# = 1.3

   FOR I = 1 TO 7
       CIRCLE (X, Y), Radius, Colr, , , C#
       C# = C# + B#
       B# = B# + .2 * C#
   NEXT

END SUB

