'********** DemoMove.Bas - demonstrates scrolling up/down/left/right

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software


DEFINT A-Z
DECLARE SUB SetVideo ()
DECLARE SUB CGAMove (X!, Y!, OldX!, OldY!, XDist!, YDist!)

'$INCLUDE: 'GetVideo'

CALL SetVideo

LINE (30, 30)-(230, 130)                'create something to demo
CIRCLE (100, 80), 50
PAINT (101, 80), 4, 15

   LOCATE 1, 1
   PRINT "Select (Up, Down, Left, Right (U/D/L/R): "; A$

Top:
   A$ = UCASE$(INKEY$)
   IF A$ = "" GOTO Top

   A = INSTR("UDLR", A$)' / 2

   IF A = 1 THEN
      CALL CGAMove(30, 30, 230, 130, 0, -30)
   ELSEIF A = 2 THEN
      CALL CGAMove(30, 30, 230, 130, 0, 30)
   ELSEIF A = 3 THEN
      CALL CGAMove(30, 30, 230, 130, -30, 0)
   ELSEIF A = 4 THEN
      CALL CGAMove(30, 30, 230, 130, 30, 0)
   ELSE
      GOTO Top
   END IF
