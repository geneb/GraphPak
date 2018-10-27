'********** MakeFont.Bas - creates a set of "standard" CGA fonts

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software


Defint A-Z

    'by following the below instructions you can create a VGA font

    Screen 1, 0
    'SCREEN 12                       'Un-REM this to make a VGA font

    Dim Char$(95)
    Open "CGA.GPK" As 1 Len = 32     'place a REM before this line and
    'Open "VGA.GPK" As 1 Len = 32    'Un-REM this to make a VGA font
    Field #1, 32 As Wr$

    For T = 32 To 126
	Locate 1, 1
	Print Chr$(T);
	For S = 0 To 31
	    Ch = 0
	    For T1 = 0 To 7
		Ch = Ch + Sgn(Point((S Mod 2) * 8 + T1, S \ 2)) * (2^(7 - T1))
	    Next
	    Char$(T - 31) = Char$(T - 31) + Chr$(Ch)
	Next
	Lset Wr$ = Char$(T - 31)
	Put #1, (T - 31)
    Next

    Close
