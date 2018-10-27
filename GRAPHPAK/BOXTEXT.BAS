'********** BoxText.Bas - subprogram to box and draw a string of text

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software


DEFINT A-Z

'This Declare statement is for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE SUB DrawText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)
DECLARE FUNCTION GetTextWidth% (Text$)
DECLARE SUB GPPause ()
DECLARE SUB Prepare ()

'$INCLUDE: 'Common'

SUB BoxText (Text$, Colr, X, Y, J, T, FS) STATIC

    'draws a box and centers text within it

    '    X  =  0 = Center, 1 = Left, 2 = Right
    '    Y  =  1..100  percentage position on screen
    '    J  =  0 = Left Justify, 1 = Centered, 2 = Right Justify
    '    T  =  0..4 meaning 1..5  box width

    TextSize# = FS / 10
    S = 1
    T1 = 1
    U = 1
    WHILE T1 > 0
       T1 = INSTR(S, Text$, "_")
       IF T1 > 0 THEN U = U + 1
       S = T1 + 1
    WEND

    REDIM T$(U)
    S = 1
    T1 = 1
    U = 0
    WHILE T1 > 0
       T1 = INSTR(S, Text$, "_")
       IF T1 > 0 THEN
	  U = U + 1
	  T$(U) = MID$(Text$, S, T1 - S)
       ELSE
	  U = U + 1
	  T$(U) = MID$(Text$, S)
       END IF
       S = T1 + 1
    WEND

    Wdth = GetTextWidth%(T$(1)) * TextSize#
    FOR T1 = 2 TO U
	A = GetTextWidth%(T$(T1)) * TextSize#
	IF A > Wdth THEN Wdth = A
    NEXT
    S = U                       'use S to hold value of U

    Wdth = Wdth + 2 * GPDat%(36) * TextSize#
    U = (U + 1) * GPDat%(36) * TextSize#

    Corner = GPDat%(43) \ 2
    Y = GPDat%(44) * Y / 100 - U \ 2

    IF X = 1 THEN
       Corner = Wdth \ 2 + GPDat%(35) \ 2
    ELSEIF X = 2 THEN
       Corner = Corner * 2 - (Wdth + GPDat%(35)) \ 2
    END IF

    BoxColr = Colr \ 1024
    TxtColr = Colr MOD 1024
    IF BoxColr = 0 THEN BoxColr = TxtColor MOD 16

    LINE (Corner - Wdth \ 2, Y)-(Corner + Wdth \ 2, Y + U), 0, BF
    FOR G = 0 TO T
	LINE (Corner - Wdth \ 2 - G, Y - G)-(Corner + Wdth \ 2 + G, Y + U + G), BoxColr, B
    NEXT

    FOR T1 = 1 TO S
	IF J = 0 THEN
	   CALL DrawText(Corner - Wdth \ 2 + GPDat%(36) * TextSize#, Y + (T1 - .5) * GPDat%(36) * TextSize#, T$(T1), 0, TxtColr, TextSize#)
	ELSEIF J = 1 THEN
	   CALL DrawText(Corner - (GetTextWidth%(T$(T1)) * TextSize#) \ 2, Y + (T1 - .5) * GPDat%(36) * TextSize#, T$(T1), 0, TxtColr, TextSize#)
	ELSE
	   CALL DrawText(Corner + Wdth \ 2 - GetTextWidth(T$(T1)) * TextSize# + GPDat%(36) * TextSize#, Y + (T1 - .5) * GPDat%(36) * TextSize#, T$(T1), 0, TxtColr, TextSize#)
	END IF
   NEXT

   CALL GPPause            'Wait for a keystroke
   CALL Prepare

END SUB

