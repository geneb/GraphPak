'********** Fonts.Bas - Designs and edits GraphPak fonts

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software


'this program was compiled with QB 4.0 as follows:

    'BC FONTS /O;
    'LINK /E /NOE FONTS + NOCOM,, NUL, GRAPHPAK


DEFINT A-Z

DECLARE SUB GPExist (FileName$, There)
DECLARE SUB HighPrint (A$)

DIM Crossair(200)

'$INCLUDE: 'GetVideo.Bas'

bcgv = 15
IF GPDat%(31) <> 5 AND GPDat%(31) <> 8 THEN
   PRINT "This program requires an EGA or VGA display"
   END
END IF

SCREEN 9

False = 0
True = NOT False
Front = 15
Back = 1
Mark1 = 2
Mark2 = 4
Cl$ = SPACE$(20)

LINE INPUT "Enter the file name, without an extension: ", FileName$
T = INSTR(FileName$, ".")
IF T THEN FileName$ = LEFT$(FileName$, T - 1)
IF FileName$ = "" THEN FileName$ = "EGA"

DIM Char$(95), LnIn$(95)
CALL GPExist(FileName$ + ".GPK", There)
IF NOT There THEN
   CLS
   PRINT "File not found - press a key";
   WHILE INKEY$ = "": WEND
   CLS
   RUN
END IF
     
OPEN FileName$ + ".GPK" FOR RANDOM AS #1 LEN = 32
FIELD #1, 32 AS Wr$

FOR T = 32 TO 126
    GET #1, T - 31
    Char$(T - 31) = Wr$
NEXT

FOR T = 0 TO 15             'draw boxes
    FOR S = 0 TO 15
	LINE (60 + T * 24, 20 + S * 20)-(59 + (T + 1) * 24, 19 + (S + 1) * 20), Back, BF
	LINE (60 + T * 24, 20 + S * 20)-(59 + (T + 1) * 24, 19 + (S + 1) * 20), 2, B
    NEXT
NEXT

LINE (59, 19)-(444, 340), 2, B
BLine = 10
LINE (60, 39 + BLine * 20)-(443, 40 + BLine * 20), 14, B
SLine = 11
LINE (83 + SLine * 24, 20)-(84 + SLine * 24, 339), 14, B
LINE (474, 20)-(491, 37), 2, B
LINE (496, 20)-(522, 46), 2, B
LINE (529, 20)-(562, 53), 2, B
LINE (569, 20)-(634, 85), 2, B

LOCATE 1, 1                         'give boxes a coordinates system
PRINT TAB(10); "0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15";
FOR T = 0 TO 15
    GET (64 + T * 24, 0)-(64 + (T + 1) * 24, 13), Crossair
    PUT (39, T * 20 + 23), Crossair, XOR
NEXT

LOCATE 1, 60
PRINT "x1 x1.5  x2    x4"

CIRCLE (5, 5), 3, 3
GET (0, 0)-(10, 10), Crossair
PUT (0, 0), Crossair, XOR

NumEntries = 6
DIM T$(NumEntries)
T$(1) = "Accept Work Character"
T$(2) = "Generate Font File"
T$(3) = "Simulate Character"
T$(4) = "Move Help Lines"
T$(5) = "Quit Font Editor"
T$(6) = "Exit w/out Save"

COLOR 7
FOR T = 1 TO NumEntries
    LOCATE 12 + T, 59
    CALL HighPrint(T$(T))
NEXT

T$ = "AGSMQE"
Tst = 0

Enter:
    LOCATE 11, 59
    PRINT "Char ("; CHR$(34); " "; CHR$(34); ") Ascii     "

    FOR T = 0 TO 15                        'clear display
	LINE (475, 21 + T)-(490, 21 + T), Back
    NEXT
    KeyStroke = False

FGet.Key:
    Char$ = INKEY$
    IF Char$ >= "a" AND Char$ <= "z" THEN Char$ = CHR$(ASC(Char$) - 32)
    'Char$ = UCASE$(INKEY$)

    GOSUB Fix.it        'if nothing better to do, then update the screen
    IF Char$ = "" GOTO FGet.Key
    KeyStroke = False
    Tst = INSTR(T$, Char$)

    IF Tst > 0 THEN
	COLOR 15
	LOCATE 12 + Tst, 59
	PRINT T$(Tst)
	COLOR 7
	IF Tst = 1 THEN
	   LOCATE 11, 66
	   Char$ = ""
	   WHILE Char$ = ""
	       Char$ = INKEY$
	   WEND
	   IF Char$ < CHR$(32) GOTO FGet.Key
	   KeyStroke = False
	   GOTO Init.Screen
	END IF

	IF Tst = 2 THEN GOSUB Write.SP

	IF Tst = 3 THEN
	    COLOR 15
	    LOCATE 20, 59
	    PRINT "Must Accept Work";
	    LOCATE 21, 59
	    PRINT "Character First";
	    LOCATE 23, 59
	    PRINT "Press Any Key...";
	    WHILE INKEY$ = "": WEND
	    COLOR 7
	    LOCATE 20, 59: PRINT Cl$;
	    LOCATE 21, 59: PRINT Cl$;
	    LOCATE 23, 59: PRINT Cl$;
	END IF

	IF Tst = 4 THEN GOSUB MoveLines

	IF Tst = 5 THEN
	    FOR T = 32 TO 126
		LSET Wr$ = Char$(T - 31)
		PUT #1, (T - 31)
	    NEXT
	    CLOSE
	    END
	END IF

	IF Tst = 6 THEN
	   LOCATE 21, 59
	   PRINT "Are you sure? (Y/N)";
	   I$ = " "
	   WHILE INSTR("yYnN" + CHR$(27), I$) < 1
	      I$ = ""
	      WHILE I$ = ""
		 I$ = INKEY$
	      WEND
	   WEND
	   LOCATE 21, 59
	   PRINT Cl$;
	   IF INSTR("yY", I$) > 0 THEN
	      SCREEN 0, 1
	      CLS
	      PRINT "Bye..."
	      CLOSE
	      END
	   END IF
	END IF

	LOCATE 12 + Tst, 59
	CALL HighPrint(T$(Tst))

    END IF

    GOTO FGet.Key



Init.Screen:
    COLOR 15
    LOCATE 11, 59
    PRINT "Char ("; CHR$(34); Char$; CHR$(34); ") Ascii"; ASC(Char$)

    FOR T = 0 TO 31
	B = 0
	IF T \ 2 <> T / 2 THEN B = 8
	A = ASC(MID$(Char$(ASC(Char$) - 31), T + 1, 1))
	FOR T1 = 0 TO 7
	    IF A AND 2 ^ (7 - T1) THEN
		X = T1 + B
		Y = T \ 2
		PSET (475 + X, 21 + Y), Front
	    END IF
	NEXT
    NEXT

    FOR T = 1 TO NumEntries
	LOCATE 12 + T, 59
	CALL HighPrint(T$(T))
    NEXT

    X = 0
    Y = 0
    L = 1
    L1 = 0
    PUT (X * 24 + 67, Y * 20 + 26), Crossair, XOR
    KeyStroke = False
    StopFix = False

Get.Key:
    Ky$ = INKEY$
    IF Ky$ >= "a" AND Ky$ <= "z" THEN Ky$ = CHR$(ASC(Ky$) - 32)
    'Ky$ = UCASE$(INKEY$)
    GOSUB Fix.it
    IF Ky$ = "" GOTO Get.Key
    Tst = INSTR(T$, Ky$)

    IF Tst > 0 THEN
       COLOR 15
       LOCATE 12 + Tst, 59
       PRINT T$(Tst)
       COLOR 7

       IF Tst = 1 THEN
	  FOR T = 0 TO 31
	      B = 0
	      IF T \ 2 <> T / 2 THEN B = 8
	      A = 0
	      FOR T1 = 0 TO 7
		  X = T1 + B
		  Y = T \ 2
		  IF POINT(475 + X, 21 + Y) = Front THEN A = A + 2 ^ (7 - T1)
	      NEXT
	      MID$(Char$(ASC(Char$) - 31), T + 1, 1) = CHR$(A)
	  NEXT

	  GOSUB Fix.it
	  COLOR 7
	  LOCATE 11, 59
	  PRINT "Char ("; CHR$(34); " "; CHR$(34); ") Ascii     "
	  LOCATE 11, 66
	  Char$ = ""
	  WHILE Char$ = ""
	     Char$ = INKEY$
	  WEND
	  IF Char$ < CHR$(32) GOTO FGet.Key
	  FOR T = 0 TO 15                     'clear display
	      LINE (475, 21 + T)-(490, 21 + T), Back
	  NEXT
	  KeyStroke = False
	  GOTO Init.Screen
       END IF

       IF Tst = 2 THEN
	  FOR T = 0 TO 31
	      B = 0
	      IF T \ 2 <> T / 2 THEN B = 8
	      A = 0
	      FOR T1 = 0 TO 7
		  X = T1 + B
		  Y = T \ 2
		  IF POINT(475 + X, 21 + Y) = Front THEN A = A + 2 ^ (7 - T1)
	      NEXT
	      MID$(Char$(ASC(Char$) - 31), T + 1, 1) = CHR$(A)
	  NEXT
	  GOSUB Write.SP
	  FOR T = 0 TO 31
	      B = 0
	      IF T \ 2 <> T / 2 THEN B = 8
	      A = ASC(MID$(Char$(ASC(Char$) - 31), T + 1, 1))
	      FOR T1 = 0 TO 7
		IF A AND 2 ^ (7 - T1) THEN
		   X = T1 + B
		   Y = T \ 2
		   PSET (475 + X, 21 + Y), Front
		END IF
	      NEXT
	  NEXT
       END IF

       IF Tst = 3 THEN
	  COLOR 15
	  LOCATE 1, 1
	  PRINT Char$;
	  FOR T1 = 0 TO 15
	      FOR T2 = 0 TO 15
		  Fv = POINT(T1, T2)
		  IF Fv THEN
		     Fv = Front
		  ELSE
		     Fv = Back
		  END IF
		  PSET (475 + T1, 21 + T2), Fv
	      NEXT
	  NEXT
	  KeyStroke = False
	  LOCATE 1, 1
	  PRINT " ";
	  COLOR 7
       END IF

       IF Tst = 4 THEN GOSUB MoveLines

       IF Tst = 5 THEN
	  FOR T = 0 TO 31
	      B = 0
	      IF T \ 2 <> T / 2 THEN B = 8
	      A = 0
	      FOR T1 = 0 TO 7
		  X = T1 + B
		  Y = T \ 2
		  IF POINT(475 + X, 21 + Y) = Front THEN
		     A = A + 2 ^ (7 - T1)
		  END IF
	      NEXT
	      MID$(Char$(ASC(Char$) - 31), T + 1, 1) = CHR$(A)
	  NEXT
	  FOR T = 32 TO 126
	      LSET Wr$ = Char$(T - 31)
	      PUT #1, (T - 31)
	  NEXT
	  CLOSE
	  END
       END IF

       IF Tst = 6 THEN
	  LOCATE 21, 59: PRINT "Are You Sure (Y/N)?"
	  I$ = " "
	  WHILE INSTR("yYnN" + CHR$(27), I$) < 1
	     I$ = ""
	     WHILE I$ = ""
		 I$ = INKEY$
	     WEND
	  WEND
	  LOCATE 21, 59: PRINT Cl$;
	  IF INSTR("yY", I$) > 0 THEN
	     SCREEN 0, 1
	     CLS
	     PRINT "Bye..."
	     CLOSE
	     END
	  END IF
       END IF
       LOCATE 12 + Tst, 59
       CALL HighPrint(T$(Tst))
       GOTO Get.Key
    END IF

    'implied else
    KeyStroke = False

    IF Ky$ = CHR$(27) THEN              'save character to array
       FOR T = 0 TO 31
	   B = 0
	   IF T \ 2 <> T / 2 THEN B = 8
	   A = 0
	   FOR T1 = 0 TO 7
	       X = T1 + B
	       Y = T \ 2
	       IF POINT(475 + X, 21 + Y) = Front THEN A = A + 2 ^ (7 - T1)
	   NEXT
	   MID$(Char$(ASC(Char$) - 31), T + 1, 1) = CHR$(A)
       NEXT
       GOSUB Fix.it
       GOTO Enter
    END IF

    IF Ky$ = " " THEN
	Fv = POINT(475 + X, 21 + Y)
	IF Fv = Back THEN Fv = Front ELSE Fv = Back
	PSET (475 + X, 21 + Y), Fv      'toggle pixel
	GOSUB Fix.Point
    END IF

    IF Ky$ = CHR$(8) THEN               'erase pixel
	PSET (475 + X, 21 + Y), Back
	GOSUB Fix.Point
    END IF

    IF Ky$ = CHR$(13) THEN              'draw pixel
	PSET (475 + X, 21 + Y), Front
	GOSUB Fix.Point
    END IF

    IF LEN(Ky$) < 2 GOTO Get.Key        'ignore the rest of the keystokes

    Ky = ASC(MID$(Ky$, 2, 1))           'get extended scan code

    'remove cross hair from screen
    PUT (X * 24 + 67, Y * 20 + 26), Crossair, XOR
    KeyStroke = True

    IF Ky = 72 THEN                     'check direction moved
       Y = Y - 1
       IF Y < 0 THEN Y = 15
    END IF

    IF Ky = 75 THEN
       X = X - 1
       IF X < 0 THEN X = 15
    END IF

    IF Ky = 77 THEN
       X = X + 1
       IF X > 15 THEN X = 0
    END IF

    IF Ky = 80 THEN
       Y = Y + 1
       IF Y > 15 THEN Y = 0
    END IF

    ' replace cross hair in new position
    PUT (X * 24 + 67, Y * 20 + 26), Crossair, XOR
    GOTO Get.Key

Fix.it:
    IF NOT KeyStroke THEN
       FS = 0
       FT = 0
       KeyStroke = True
       StopFix = False
    ELSE
       IF StopFix THEN
	  FS = 0
	  FT = 0
	  RETURN
       END IF
       FS = (FS + 1) MOD 16
       IF FS = 0 THEN
	  FT = (FT + 1) MOD 16
	  IF FT = 0 THEN StopFix = True
       END IF
    END IF

    Fv = POINT(475 + FT, 21 + FS)
    LINE (61 + FT * 24, 21 + FS * 20)-(58 + (FT + 1) * 24, 18 + (FS + 1) * 20), Fv, BF
    LINE (497 + FT * 1.5, 21 + FS * 1.5)-(497 + (FT + 1) * 1.5, 21 + (FS + 1) * 1.5), Fv, BF
    LINE (530 + FT * 2, 21 + FS * 2)-(531 + FT * 2, 22 + FS * 2), Fv, BF
    LINE (570 + FT * 4, 21 + FS * 4)-(573 + FT * 4, 24 + FS * 4), Fv, BF
    IF FT = X AND FS = Y THEN
	PUT (X * 24 + 67, Y * 20 + 26), Crossair, XOR
    END IF
    RETURN

Fix.Point:
    Fv = POINT(475 + X, 21 + Y)
    LINE (61 + X * 24, 21 + Y * 20)-(58 + (X + 1) * 24, 18 + (Y + 1) * 20), Fv, BF
    LINE (497 + X * 1.5, 21 + Y * 1.5)-(497 + (X + 1) * 1.5, 21 + (Y + 1) * 1.5), Fv, BF
    LINE (530 + X * 2, 21 + Y * 2)-(531 + X * 2, 22 + Y * 2), Fv, BF
    LINE (570 + X * 4, 21 + Y * 4)-(573 + X * 4, 24 + Y * 4), Fv, BF
    PUT (X * 24 + 67, Y * 20 + 26), Crossair, XOR
    RETURN

MoveLines:
    Ky$ = INKEY$
    GOSUB Fix.it
    IF Ky$ = "" GOTO MoveLines
    IF Ky$ = CHR$(27) OR Ky$ = CHR$(13) THEN RETURN

    IF LEN(Ky$) < 2 GOTO MoveLines      'ignore the rest of the keystokes

    Ky = ASC(MID$(Ky$, 2, 1))           'get extended scan code

    LINE (60, 39 + BLine * 20)-(443, 40 + BLine * 20), 2, B
    LINE (83 + SLine * 24, 20)-(84 + SLine * 24, 339), 2, B

    IF Ky = 72 THEN                     'check direction moved
	BLine = BLine - 1
	IF BLine < 0 THEN BLine = 15
    END IF

    IF Ky = 75 THEN
	SLine = SLine - 1
	IF SLine < 0 THEN SLine = 15
    END IF

    IF Ky = 77 THEN
	SLine = SLine + 1
	IF SLine > 15 THEN SLine = 0
    END IF

    IF Ky = 80 THEN
	BLine = BLine + 1
	IF BLine > 15 THEN BLine = 0
    END IF

    LINE (60, 39 + BLine * 20)-(443, 40 + BLine * 20), 14, B
    LINE (83 + SLine * 24, 20)-(84 + SLine * 24, 339), 14, B

    GOTO MoveLines


Write.SP:
    J1 = 0
    FOR S2 = 32 TO 126
	COLOR 15
	LOCATE 11, 59: PRINT "Char ("; CHR$(34); CHR$(S2); CHR$(34); ") Ascii"; S2

	LINE (475, 21)-(490, 36), Back, BF          'clear display

	FOR T = 0 TO 31
	    B = 0
	    IF T \ 2 <> T / 2 THEN B = 8
	    A = ASC(MID$(Char$(S2 - 31), T + 1, 1))
	    FOR T1 = 0 TO 7
		IF A AND 2 ^ (7 - T1) THEN
		   X = T1 + B
		   Y = T \ 2
		   PSET (475 + X, 21 + Y), Front
		END IF
	    NEXT
	NEXT

	GOSUB Here          'this goes to special routines below...
	Quotes = False
	LnIn$(S2 - 31) = LnCh$
	IF J1 < LEN(LnCh$) THEN J1 = LEN(LnCh$)
    NEXT

    J1 = J1 + 1
    OPEN FileName$ + ".GFN" FOR RANDOM AS #2 LEN = J1 'file name user entered
	FIELD #2, J1 AS Into$
	LSET Into$ = STR$(J1) + CHR$(13) + CHR$(10)
	PUT #2
	FOR j2 = 1 TO 95
	   LnCh$ = CHR$(LEN(LnIn$(j2))) + LnIn$(j2)
	   LSET Into$ = LnCh$
	   PUT #2
	NEXT
    CLOSE #2

    COLOR 7
    LOCATE 11, 59: PRINT "Char ("; CHR$(34); " "; CHR$(34); ") Ascii"

    LINE (475, 21)-(490, 36), Back          'clear display
    RETURN


Here:
    LINE (474, 40)-(491, 57), 2, B
    LINE (474, 60)-(491, 77), 2, B
    FOR T = 0 TO 15
	FOR S = 0 TO 15
	    Fv = POINT(475 + T, 21 + S)
	    PSET (475 + T, 41 + S), Fv
	    PSET (475 + T, 61 + S), Fv
	NEXT
    NEXT
    LnCh$ = ""
    Ofs = 0


There:
    IF POINT(475 + (Ofs MOD 16), 21 + Ofs \ 16) = Front GOTO Lp1
    Ofs = Ofs + 1
    IF Ofs < 256 GOTO There
    LINE (474, 40)-(491, 77), 0, BF
    RETURN


Lp1:  'check to see if a line across would be valid
    Of2 = Ofs + 1
    Bv = POINT(475 + (Of2 MOD 16), 41 + Of2 \ 16)
    WHILE Of2 MOD 16 > 0 AND Bv = Front
       Of2 = Of2 + 1
       Bv = POINT(475 + (Of2 MOD 16), 41 + Of2 \ 16)
    WEND
    IF Of2 > Ofs + 1 THEN
      bcgv = POINT(475 + (Ofs MOD 16), 41 + Ofs \ 16)
      LINE (475 + (Ofs MOD 16), 41 + Ofs \ 16)-(475 + ((Of2 - 1) MOD 16), 41 + (Of2 - 1) \ 16), Mark1
      LnCh$ = LnCh$ + CHR$(Ofs) + CHR$(Of2 - 1)
    END IF

    Of2 = Ofs + 16
    Bv = POINT(475 + (Of2 MOD 16), 61 + Of2 \ 16)
    WHILE Of2 < 256 AND Bv = Front
       Of2 = Of2 + 16
       Bv = POINT(475 + (Of2 MOD 16), 61 + Of2 \ 16)
    WEND
    IF Of2 > Ofs + 16 THEN
      LINE (475 + (Ofs MOD 16), 61 + Ofs \ 16)-(475 + (Of2 MOD 16), 60 + Of2 \ 16), Mark2
      LnCh$ = LnCh$ + CHR$(Ofs) + CHR$(Of2 - 16)
    END IF

    IF POINT(475 + (Ofs MOD 16), 41 + Ofs \ 16) = Front AND POINT(475 + (Ofs MOD 16), 61 + Ofs \ 16) = Front THEN
       PSET (475 + (Ofs MOD 16), 41 + Ofs \ 16), Mark1
       LnCh$ = LnCh$ + CHR$(Ofs) + CHR$(Ofs)
    END IF

    Ofs = Ofs + 1
    GOTO There

SUB HighPrint (A$) STATIC

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

