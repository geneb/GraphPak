'********** Display.Bas - displays a title string in a specified color

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'This Declare statement is for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE SUB DrawText (Xx, Yy, Text$, Angle, Colr, TextSize#)
DECLARE FUNCTION GetTextWidth% (Text$)

'$INCLUDE: 'Common'

SUB DisplayTitle (Title$) STATIC

    IF GPDat%(12) = 0 THEN EXIT SUB   'If Not ShowTitle then exit

    REDIM T$(11)
    HoldSpacing% = GPDat%(36)
    TextSize# = 2.2
    IF GPDat%(27) <> 0 THEN TextSize# = GPDat%(27) / 10

    IF GPDat%(31) = 2 OR GPDat%(31) = 5 OR GPDat%(31) = 8 THEN  'EGA or VGA
    ELSEIF GPDat%(31) = 6 THEN  'CGA Screen 2
	TextSize# = TextSize# * .9
    ELSE                         'CGA Screen 1
	TextSize# = TextSize# * .8
    END IF

    T1$ = Title$
    T1 = 0
    MaxLen = 1
    WHILE LEN(T1$)
	T1 = T1 + 1
	L = INSTR(T1$, "_")      'search for underscore "new-line" character
	IF L THEN                  'If l > 0 then pull out the string
	    T$(T1) = LEFT$(T1$, L - 1)
	    T1$ = MID$(T1$, L + 1)
	    L = LEN(T$(T1))
	    IF L > LEN(T$(MaxLen)) THEN MaxLen = T1
	ELSE
	    T$(T1) = T1$
	    T1$ = ""
	    L = LEN(T$(T1))
	    IF L > LEN(T$(MaxLen)) THEN MaxLen = T1
	END IF
    WEND
   
    IF GPDat%(25) = 0 THEN                          'Left Side of screen
	Center% = (GetTextWidth%(T$(MaxLen)) / 2) * TextSize# + 5
    ELSEIF GPDat%(25) = 1 THEN                      'Middle of screen
	Center% = GPDat%(43) \ 2
    ELSE                                            'Right Side of screen
	Center% = GPDat%(43) - (GetTextWidth(T$(MaxLen)) / 2) * TextSize# - 5
    END IF

    T = 0
    T2 = 1
    WHILE T < T1
	T = T + 1                    'Move one line down for the next one
	IF LEN(T$(T)) > 23 THEN
	    BEEP: T$(T) = LEFT$(T$(T), 23)
	END IF
	S1 = Center% - (GetTextWidth(T$(T)) / 2) * TextSize#  'position the string
	CALL DrawText(S1, T2, T$(T), 0, GPDat%(9), TextSize#) 'draw the string
	T2 = T2 + GPDat%(36) * TextSize#
    WEND

END SUB

