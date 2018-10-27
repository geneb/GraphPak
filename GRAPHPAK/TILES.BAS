'********** Tiles.Bas - GraphPak tile editor

'Copyright (c) 1988 Brian Giedt
'Copyright (c) 1988 Crescent Software


'compile and link with QuickBASIC 4.0 as follows:
'
'   BC TILES /O;
'   LINK /E /NOE TILES NOCOM , , NUL, GRAPHPAK


DEFINT A-Z

DECLARE SUB Highprint (A$)
DECLARE SUB Show.Help ()
DECLARE SUB Selectv (SaveDone)
DECLARE SUB GetFileName (File$)
DECLARE SUB SetVideo ()

'$INCLUDE: 'GetVideo'

IF GPDat%(31) <> 5 AND GPDat%(31) <> 8 THEN
   PRINT "This program requires an EGA or VGA display"
   END
END IF

SCREEN 9

Tile$ = SPACE$(32)
DIM SaveTile$(48)

Start:
    CLS
    LINE INPUT "Enter the .GPK tile file name: ", TileFile$
    T = INSTR(TileFile$, ".")
    IF T THEN TileFile$ = LEFT$(TileFile$, T - 1)
    IF TileFile$ = "" THEN TileFile$ = "TILEFILE"

    CALL GPExist(TileFile$ + ".GPK", There)
    IF NOT There THEN
       PRINT "File not found - press a key"
       WHILE INKEY$ = "": WEND
       GOTO Start
    END IF

    LOCATE 1, 1: PRINT SPC(79);
    OPEN TileFile$ + ".GPK" FOR INPUT AS #1
    FOR T = 1 TO 48
	FOR S = 1 TO 32
	    INPUT #1, P
	    SaveTile$(T) = SaveTile$(T) + CHR$(P)
	NEXT
    NEXT
    CLOSE 1
    SaveDone = 1

Cl$ = SPACE$(23)

COLOR 2
LOCATE 1, 28: PRINT "GraphPak Tile Generator"
LOCATE 3, 30: PRINT "Available Commands"
COLOR 7
LOCATE 5, 30: CALL Highprint("    Get tile   ")
LOCATE 6, 30: CALL Highprint("    Put tile   ")
LOCATE 7, 30: CALL Highprint("  Make Include ")
LOCATE 8, 30: CALL Highprint(" Add to Include")
LOCATE 9, 30: CALL Highprint(" Finish Include")
LOCATE 10, 30: CALL Highprint("   Load tiles  ")
LOCATE 11, 30: CALL Highprint("   Save tiles  ")
LOCATE 12, 30: CALL Highprint("     Clear     ")
LOCATE 13, 30: CALL Highprint(" Rotate Colors ")
LOCATE 14, 30: CALL Highprint("  Turn Palette ")
LOCATE 15, 30: CALL Highprint("      Quit     ")

CALL Show.Help

LINE (230, 53)-(370, 212), , B

FOR T = 20 TO 160 STEP 20
    FOR S = 20 TO 160 STEP 20
	LINE (S, T)-(S + 20, T + 20), , B
    NEXT
NEXT

LINE (12, 222)-(178, 292), , B

DIM Cursor(1000), Cursor2(1000)

'----- X style cursor for editing grid
LINE (1, 1)-(18, 18)
LINE (1, 18)-(18, 1)

GET (1, 1)-(18, 18), Cursor
PUT (1, 1), Cursor, XOR

'----- Arrow for tile capturing
LINE (1, 8)-(15, 8), 7
LINE (15, 10)-(1, 10), 7
LINE -(1, 8), 7
LINE (7, 4)-(18, 9), 7
LINE -(7, 14), 7
PAINT (2, 9), 9, 7
GET (1, 1)-(18, 18), Cursor2
PUT (1, 1), Cursor2, XOR

X = 0
Y = 0
PUT (X * 20 + 21, Y * 20 + 21), Cursor, XOR
PUT (400, 10), Cursor2, XOR

DrawSaves:
FOR T = 1 TO 16
    LINE (420, T * 20 - 10)-(460, T * 20 + 10), , B
    LINE (421, T * 20 - 9)-(459, T * 20 + 9), 0, BF
    PAINT (421, T * 20 - 9), SaveTile$(T)
NEXT

FOR T = 1 TO 16
    LINE (490, T * 20 - 10)-(530, T * 20 + 10), , B
    LINE (491, T * 20 - 9)-(529, T * 20 + 9), 0, BF
    PAINT (491, T * 20 - 9), SaveTile$(T + 16)
NEXT

FOR T = 1 TO 16
    LINE (560, T * 20 - 10)-(600, T * 20 + 10), , B
    LINE (561, T * 20 - 9)-(599, T * 20 + 9), 0, BF
    PAINT (561, T * 20 - 9), SaveTile$(T + 32)
NEXT

Get.Key:
    Ky$ = UCASE$(INKEY$)
    IF Ky$ = "" GOTO Get.Key
    IF Ky$ = CHR$(27) OR Ky$ = "Q" THEN
       COLOR 15
       LOCATE 15, 32: PRINT "    Quit"
       IF NotFinsh THEN
	  LOCATE 17, 30: PRINT "Include File has"
	  LOCATE 18, 30: PRINT "NOT been Finished"
	  LOCATE 19, 30: PRINT "  PRESS ANY KEY  "
	  WHILE INKEY$ = "": WEND
	  LOCATE 17, 30: PRINT Cl$
	  LOCATE 18, 30: PRINT Cl$
	  LOCATE 19, 30: PRINT Cl$
	  COLOR 7
	  LOCATE 15, 32: CALL Highprint("    Quit")
	  GOTO Get.Key
       END IF

       LOCATE 17, 30: PRINT "Save File (Y/N)?"
       I$ = " "
       WHILE INSTR("yYnN" + CHR$(27), I$) < 1
	   I$ = ""
	   WHILE I$ = "": I$ = INKEY$: WEND
       WEND

       IF I$ = CHR$(27) THEN
	  COLOR 7
	  LOCATE 15, 32: CALL Highprint("    Quit")
	  LOCATE 17, 30: PRINT Cl$
	  GOTO Get.Key
       END IF

       IF INSTR("yY", I$) THEN
	  OPEN TileFile$ + ".GPK" FOR OUTPUT AS #1
	  FOR T = 1 TO 48
	      FOR S = 1 TO 32
		  IF S > 1 THEN PRINT #1, ",";
		  P = ASC(MID$(SaveTile$(T), S, 1))
		  PRINT #1, P;
	      NEXT
	      PRINT #1, " "
	  NEXT
	  CLOSE #1
       END IF
       END
    END IF

    IF Ky$ = "+" OR Ky$ = " " THEN
       C = SGN(ASC(MID$(Tile$, (Y) * 4 + 1, 1)) AND (2 ^ (7 - X))) * 1 + SGN(ASC(MID$(Tile$, (Y) * 4 + 2, 1)) AND (2 ^ (7 - X))) * 2 + SGN(ASC(MID$(Tile$, (Y) * 4 + 3, 1)) AND (2 ^ (7 - X))) * 4 + SGN(ASC(MID$(Tile$, (Y) * 4 + 4, 1)) AND (2 ^ (7 - X _
))) * 8
       C = (C + 1) MOD 16
       LINE (X * 20 + 21, Y * 20 + 21)-(X * 20 + 39, Y * 20 + 39), C, BF
       PUT (X * 20 + 21, Y * 20 + 21), Cursor, XOR

       FOR T = 0 TO 3
	   T$ = MID$(Tile$, Y * 4 + T + 1, 1)
	   T1 = ASC(T$) AND (255 XOR 2 ^ (7 - X))
	   T1 = T1 + SGN(C AND 2 ^ T) * (2 ^ (7 - X))
	   T$ = CHR$(T1)
	   MID$(Tile$, Y * 4 + T + 1, 1) = T$
       NEXT

       LINE (13, 223)-(177, 291), 0, BF
       LINE (12, 222)-(178, 292), , B
       PAINT (90, 252), Tile$
    END IF

    IF Ky$ = "-" THEN
       C = SGN(ASC(MID$(Tile$, Y * 4 + 1, 1)) AND (2 ^ (7 - X))) * 1 + SGN(ASC(MID$(Tile$, Y * 4 + 2, 1)) AND (2 ^ (7 - X))) * 2 + SGN(ASC(MID$(Tile$, Y * 4 + 3, 1)) AND (2 ^ (7 - X))) * 4 + SGN(ASC(MID$(Tile$, Y * 4 + 4, 1)) AND (2 ^ (7 - X))) * 8
       C = (C - 1) MOD 16
       IF C = -1 THEN C = 15

       LINE (X * 20 + 21, Y * 20 + 21)-(X * 20 + 39, Y * 20 + 39), C, BF
       PUT (X * 20 + 21, Y * 20 + 21), Cursor, XOR

       FOR T = 0 TO 3
	   T$ = MID$(Tile$, Y * 4 + T + 1, 1)
	   T1 = ASC(T$) AND (255 XOR 2 ^ (7 - X))
	   T1 = T1 + SGN(C AND 2 ^ T) * (2 ^ (7 - X))
	   T$ = CHR$(T1)
	   MID$(Tile$, Y * 4 + T + 1, 1) = T$
       NEXT

       LINE (13, 223)-(177, 291), 0, BF
       LINE (12, 222)-(178, 292), , B
       PAINT (90, 252), Tile$
    END IF

    IF Ky$ = "P" THEN
       COLOR 15
       LOCATE 6, 34: PRINT "Put tile"
       CALL Selectv(SaveDone)

       IF SaveDone < 0 THEN
	  SaveDone = -1 * SaveDone
       ELSE
	  SaveTile$(SaveDone) = Tile$
       END IF

       COLOR 7
       LOCATE 6, 34: CALL Highprint("Put tile")
       IF SaveDone < 17 THEN
	  LINE (421, SaveDone * 20 - 9)-(459, SaveDone * 20 + 9), 0, BF
	  PAINT (421, SaveDone * 20 - 9), Tile$
       ELSE
	  IF SaveDone < 33 THEN
	     LINE (491, (SaveDone - 16) * 20 - 9)-(529, (SaveDone - 16) * 20 + 9), 0, BF
	     PAINT (491, (SaveDone - 16) * 20 - 9), Tile$
	  ELSE
	     LINE (561, (SaveDone - 32) * 20 - 9)-(599, (SaveDone - 32) * 20 + 9), 0, BF
	     PAINT (561, (SaveDone - 32) * 20 - 9), Tile$
	  END IF
       END IF
       GOTO Get.Key
    END IF

    IF Ky$ = "G" THEN
       COLOR 15
       LOCATE 5, 34: PRINT "Get tile"
       CALL Selectv(SaveDone)

       IF SaveDone < 0 THEN
	  SaveDone = -1 * SaveDone
       ELSE
	  Tile$ = SaveTile$(SaveDone)
       END IF

       GOSUB DrawMain
       COLOR 7
       LOCATE 5, 34: CALL Highprint("Get tile")
       LINE (13, 223)-(177, 291), 0, BF
       LINE (12, 222)-(178, 292), , B
       PAINT (90, 252), Tile$
    END IF

    IF Ky$ = "C" THEN
       COLOR 15
       LOCATE 12, 34: PRINT " Clear"
       FOR T = 20 TO 160 STEP 20
	   FOR S = 20 TO 160 STEP 20
	       LINE (S + 1, T + 1)-(S + 19, T + 19), 0, BF
	   NEXT
       NEXT
       Tile$ = SPACE$(32)
       COLOR 7
       LOCATE 12, 34: CALL Highprint(" Clear")
       PUT (X * 20 + 21, Y * 20 + 21), Cursor, XOR
       LINE (13, 223)-(177, 291), 0, BF
       LINE (12, 222)-(178, 292), , B
       PAINT (90, 252), Tile$
    END IF

    IF Ky$ = "M" THEN
       COLOR 15
       LOCATE 7, 32: PRINT "Make Include"
       IF NOT FileOpen THEN
	  LOCATE 17, 30: PRINT "Enter Include Filename"
	  LOCATE 18, 30: PRINT "See .... for position"
	  LOCATE 19, 29: PRINT ":";
	  CALL GetFileName(IncludTil$)
	  IF IncludTil$ <> "" AND IncludTil$ <> CHR$(27) THEN
	      T = INSTR(IncludTil$, ".")
	      IF T < 1 THEN IncludTil$ = IncludTil$ + ".TIL"
	      OPEN IncludTil$ FOR OUTPUT AS #2
	      PRINT #2, IncludTil$; ":"
	      FileOpen = -1    'true
	      NotFinsh = -1    'true
	      IncludCnt = 0
	  END IF
	  LOCATE 17, 30: PRINT Cl$
	  LOCATE 18, 30: PRINT Cl$
	  LOCATE 19, 29: PRINT Cl$
       END IF

       COLOR 7
       LOCATE 7, 32: CALL Highprint("Make Include")
    END IF

    IF Ky$ = "A" THEN
       COLOR 15
       LOCATE 8, 31: PRINT "Add to Include"

       IF NOT FileOpen THEN
	  LOCATE 17, 30: PRINT "  Must Make Include"
	  LOCATE 18, 30: PRINT " before adding to it"
	  LOCATE 19, 30: PRINT "    PRESS ANY KEY"
	  WHILE INKEY$ = "": WEND
	  COLOR 7
	  LOCATE 17, 30: PRINT Cl$
	  LOCATE 18, 30: PRINT Cl$
	  LOCATE 19, 30: PRINT Cl$
	  LOCATE 8, 31: CALL Highprint("Add to Include")
	  GOTO Get.Key
       END IF

       IncludCnt = IncludCnt + 1
       PRINT #2, "Data ";
       FOR J = 1 TO 32
	   PRINT #2, MID$(STR$(ASC(MID$(Tile$, J, 1))), 2);
	   IF J < 32 THEN PRINT #2, ",";  ELSE PRINT #2, " "
       NEXT
       BEEP
       COLOR 7
       LOCATE 8, 31: CALL Highprint("Add to Include")
    END IF

    IF Ky$ = "F" THEN
       COLOR 15
       LOCATE 9, 31: PRINT "Finish Include"
       IF NOT FileOpen THEN
	  LOCATE 17, 30: PRINT "  Must Make Include"
	  LOCATE 18, 30: PRINT " before finishing it"
	  LOCATE 19, 30: PRINT "    PRESS ANY KEY"
	  WHILE INKEY$ = "": WEND
	  COLOR 7
	  LOCATE 17, 30: PRINT Cl$
	  LOCATE 18, 30: PRINT Cl$
	  LOCATE 19, 30: PRINT Cl$
	  LOCATE 9, 31: CALL Highprint("Finish Include")
	  GOTO Get.Key
       END IF

       LOCATE 17, 30: PRINT "Create Main tile"
       LOCATE 18, 30: PRINT "file or Alternate"
       LOCATE 19, 30: PRINT "tile file? (M/A)"
       X$ = ""
       WHILE X$ <> "M" AND X$ <> "A"
	   X$ = UCASE$(INKEY$)
       WEND
       LOCATE 17, 30: PRINT Cl$
       LOCATE 18, 30: PRINT Cl$
       LOCATE 19, 30: PRINT Cl$
     
       PRINT #2, " "
       IF X$ = "M" THEN
	  PRINT #2, "GP.STiles% ="; IncludCnt
       ELSE
	  PRINT #2, "GP.ATiles% ="; IncludCnt
       END IF
       PRINT #2, "GP.TilWid% = 32"     'EGA/VGA only
       CLOSE #2
       FileOpen = 0
       NotFinsh = 0
       COLOR 7
       LOCATE 9, 31: CALL Highprint("Finish Include")
    END IF

    IF Ky$ = "R" THEN
       COLOR 15
       LOCATE 13, 31: PRINT "Rotate Colors"
       Sx = X
       Sy = Y

       FOR X = 0 TO 7
	   FOR Y = 0 TO 7
	       C = SGN(ASC(MID$(Tile$, Y * 4 + 1, 1)) AND (2 ^ (7 - X))) * 1 + SGN(ASC(MID$(Tile$, Y * 4 + 2, 1)) AND (2 ^ (7 - X))) * 2 + SGN(ASC(MID$(Tile$, Y * 4 + 3, 1)) AND (2 ^ (7 - X))) * 4 + SGN(ASC(MID$(Tile$, Y * 4 + 4, 1)) AND (2 ^ (7 - X _
))) * 8
	       C = (C + 1) MOD 16
	       LINE (X * 20 + 21, Y * 20 + 21)-(X * 20 + 39, Y * 20 + 39), C, BF
	       FOR T = 0 TO 3
		   T$ = MID$(Tile$, Y * 4 + T + 1, 1)
		   T1 = ASC(T$) AND (255 XOR 2 ^ (7 - X))
		   T1 = T1 + SGN(C AND 2 ^ T) * (2 ^ (7 - X))
		   T$ = CHR$(T1)
		   MID$(Tile$, Y * 4 + T + 1, 1) = T$
	       NEXT
	   NEXT
       NEXT

       X = Sx
       Y = Sy
       PUT (X * 20 + 21, Y * 20 + 21), Cursor, XOR
       LINE (13, 223)-(177, 291), 0, BF
       LINE (12, 222)-(178, 292), , B
       PAINT (90, 252), Tile$
       COLOR 7
       LOCATE 13, 31: CALL Highprint("Rotate Colors")
    END IF

    IF Ky$ = "T" THEN
       COLOR 15
       LOCATE 14, 31: PRINT " Turn Palette"
       Sc = SGN(ASC(MID$(Tile$, Y * 4 + 1, 1)) AND (2 ^ (7 - X))) * 1 + SGN(ASC(MID$(Tile$, Y * 4 + 2, 1)) AND (2 ^ (7 - X))) * 2 + SGN(ASC(MID$(Tile$, Y * 4 + 3, 1)) AND (2 ^ (7 - X))) * 4 + SGN(ASC(MID$(Tile$, Y * 4 + 4, 1)) AND (2 ^ (7 - X))) * 8
       Sx = X
       Sy = Y

       FOR X = 0 TO 7
	   FOR Y = 0 TO 7
	       C = SGN(ASC(MID$(Tile$, Y * 4 + 1, 1)) AND (2 ^ (7 - X))) * 1 + SGN(ASC(MID$(Tile$, Y * 4 + 2, 1)) AND (2 ^ (7 - X))) * 2 + SGN(ASC(MID$(Tile$, Y * 4 + 3, 1)) AND (2 ^ (7 - X))) * 4 + SGN(ASC(MID$(Tile$, Y * 4 + 4, 1)) AND (2 ^ (7 - X _
))) * 8
	       IF Sc = C THEN
		  C = (C + 1) MOD 16
		  LINE (X * 20 + 21, Y * 20 + 21)-(X * 20 + 39, Y * 20 + 39), C, BF
		  FOR T = 0 TO 3
		      T$ = MID$(Tile$, Y * 4 + T + 1, 1)
		      T1 = ASC(T$) AND (255 XOR 2 ^ (7 - X))
		      T1 = T1 + SGN(C AND 2 ^ T) * (2 ^ (7 - X))
		      T$ = CHR$(T1)
		      MID$(Tile$, Y * 4 + T + 1, 1) = T$
		  NEXT
	       END IF
	   NEXT
       NEXT

       X = Sx
       Y = Sy
       PUT (X * 20 + 21, Y * 20 + 21), Cursor, XOR
       LINE (13, 223)-(177, 291), 0, BF
       LINE (12, 222)-(178, 292), , B
       PAINT (90, 252), Tile$
       COLOR 7
       LOCATE 14, 31: CALL Highprint(" Turn Palette")
    END IF

    IF Ky$ = "S" THEN
       COLOR 15
       LOCATE 11, 33: PRINT "Save tiles"

       'save file
       OPEN TileFile$ + ".GPK" FOR OUTPUT AS #1
       FOR T = 1 TO 48
	   FOR S = 1 TO 32
	       IF S > 1 THEN PRINT #1, ",";
	       P = ASC(MID$(SaveTile$(T), S, 1))
	       PRINT #1, P;
	   NEXT
	   PRINT #1, " "
       NEXT
       CLOSE 1
       COLOR 7
       LOCATE 11, 33: CALL Highprint("Save tiles")
    END IF

    IF Ky$ = "L" THEN
       COLOR 15
       LOCATE 10, 33: PRINT "Load tiles"
       COLOR 7
       LOCATE 17, 30: PRINT "Enter New FileName";
       LOCATE 18, 30: PRINT "Of the form .GPK";
       COLOR 15
       LOCATE 19, 29: PRINT ":";
       OldTileFile$ = TileFile$
       CALL GetFileName(TileFile$)
       T = INSTR(TileFile$, ".")
       IF T THEN TileFile$ = LEFT$(TileFile$, T - 1)

       IF TileFile$ <> CHR$(27) THEN
	  CALL GPExist(TileFile$ + ".GPK", There)
	  IF NOT There GOTO NoFile

	  OPEN TileFile$ + ".GPK" FOR INPUT AS #1
	  FOR T = 1 TO 48
	      SaveTile$(T) = ""
	      FOR S = 1 TO 32
		  INPUT #1, P
		  SaveTile$(T) = SaveTile$(T) + CHR$(P)
	      NEXT
	  NEXT
	  CLOSE #1
       ELSE
NoFile:
	  TileFile$ = OldTileFile$
       END IF

       COLOR 7
       LOCATE 17, 30: PRINT Cl$
       LOCATE 18, 30: PRINT Cl$
       LOCATE 19, 29: PRINT Cl$
       LOCATE 10, 33: CALL Highprint("Load tiles")
       GOTO DrawSaves
    END IF

    IF LEN(Ky$) = 1 GOTO Get.Key

Ext.Key:
    Ky = ASC(MID$(Ky$, 2))
    PUT (X * 20 + 21, Y * 20 + 21), Cursor, XOR

    IF Ky = 72 THEN
       Y = (Y - 1) MOD 8
       IF Y = -1 THEN Y = 7
    END IF

    IF Ky = 75 THEN
       X = (X - 1) MOD 8
       IF X = -1 THEN X = 7
    END IF

    IF Ky = 77 THEN X = (X + 1) MOD 8
    IF Ky = 80 THEN Y = (Y + 1) MOD 8
    PUT (X * 20 + 21, Y * 20 + 21), Cursor, XOR
    GOTO Get.Key



DrawMain:
    FOR X1 = 0 TO 7
	FOR Y1 = 0 TO 7
	    C = SGN(ASC(MID$(Tile$, Y1 * 4 + 1, 1)) AND (2 ^ (7 - X1))) * 1 + SGN(ASC(MID$(Tile$, Y1 * 4 + 2, 1)) AND (2 ^ (7 - X1))) * 2 + SGN(ASC(MID$(Tile$, Y1 * 4 + 3, 1)) AND (2 ^ (7 - X1))) * 4 + SGN(ASC(MID$(Tile$, Y1 * 4 + 4, 1)) AND (2 ^ (7 _
 - X1))) * 8
	    LINE (X1 * 20 + 21, Y1 * 20 + 21)-(X1 * 20 + 39, Y1 * 20 + 39), C, BF
	NEXT
    NEXT

    X = 0
    Y = 0
    PUT (X * 20 + 21, Y * 20 + 21), Cursor, XOR
    RETURN

SUB GetFileName (File$) STATIC

    PRINT File$;

Fil.Key:
    Ky$ = INKEY$
    IF Ky$ = "" GOTO Fil.Key
    IF Ky$ = CHR$(27) THEN
       File$ = CHR$(27)
       EXIT SUB
    END IF

    IF Ky$ = CHR$(8) THEN
       IF POS(0) > 30 THEN
	  LOCATE CSRLIN, POS(0) - 1
	  PRINT " ";
	  LOCATE CSRLIN, POS(0) - 1
	  File$ = LEFT$(File$, LEN(File$) - 1)
	  GOTO Fil.Key
	END IF
     END IF

     IF Ky$ = CHR$(13) THEN EXIT SUB

     IF Ky$ >= " " AND Ky$ <= CHR$(126) AND POS(0) < 42 THEN
	IF Ky$ >= "a" AND Ky$ <= "z" THEN Ky$ = CHR$(ASC(Ky$) - 32)
	PRINT Ky$;
	File$ = File$ + Ky$
	GOTO Fil.Key
     END IF

     PLAY "L16o2bg"
     GOTO Fil.Key

END SUB

SUB Highprint (A$) STATIC

   First = 1
   FOR T = 1 TO LEN(A$)
       D$ = MID$(A$, T, 1)
       IF D$ >= "A" AND D$ <= "Z" AND First = 1 THEN
	  COLOR 15
	  PRINT D$;
	  COLOR 7
	  First = 0
       ELSE
	  PRINT D$;
       END IF
   NEXT

END SUB

SUB Selectv (SaveDone) STATIC

    SHARED SaveTile$(), Cursor2()
    OldOne = SaveDone

Sel.key:
    Ky$ = INKEY$
    IF Ky$ = "" GOTO Sel.key
    IF Ky$ = CHR$(27) THEN
       SaveDone = -1 * OldOne
       EXIT SUB
    END IF

    IF Ky$ = CHR$(13) THEN EXIT SUB
    IF LEN(Ky$) > 1 THEN
       Ky = ASC(MID$(Ky$, 2))
       X1 = SaveDone
       IF X1 > 32 THEN X1 = X1 - 32
       IF X1 > 16 THEN X1 = X1 - 16
       PUT (400 + 70 * ((SaveDone - 1) \ 16), X1 * 20 - 10), Cursor2, XOR

       IF Ky = 72 THEN
	  SaveDone = SaveDone - 1
	  IF SaveDone = 0 THEN SaveDone = 48
       END IF

       IF Ky = 80 THEN
	  SaveDone = SaveDone + 1
	  IF SaveDone = 49 THEN SaveDone = 1
       END IF

       X1 = SaveDone
       IF X1 > 32 THEN X1 = X1 - 32
       IF X1 > 16 THEN X1 = X1 - 16
       PUT (400 + 70 * ((SaveDone - 1) \ 16), X1 * 20 - 10), Cursor2, XOR
    END IF

    GOTO Sel.key

END SUB

SUB Show.Help STATIC

    LOCATE 20, 25: PRINT "      HELP Window"
    LOCATE 21, 25: PRINT "  Use Arrow keys to Move"
    LOCATE 22, 25: PRINT "Use (+/-) to adjust Color "
    LOCATE 23, 25: PRINT "Type First Letter of above"
    LOCATE 24, 25: PRINT "   command to activate";
    LINE (190, 266)-(410, 280), , B
    LINE (190, 280)-(410, 336), , B

END SUB

