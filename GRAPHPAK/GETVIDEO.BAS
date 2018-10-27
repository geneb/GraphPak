'********* GetVideo.Bas - determines monitor type, declares Shared variables

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

'use this block of Shared statements with QuickBASIC 2.0 and 3.0

    'REDIM SHARED XaAspect#, XbAspect#, YaAspect#, YbAspect#

'use the COMMON.BAS include file with QB 4.0

    '$INCLUDE: 'Common'

    MaxFonts% = 4    'Change this number to increase the number of fonts used

    REDIM SHARED Font$(95, MaxFonts%), FontWidth(95, MaxFonts%), FontHeight%(MaxFonts%)
    REDIM SHARED Tile$(1), AltTile$(1), GPDat%(75)

    GPDat%(33) = MaxFonts%

    CALL GPMonType(GPDat%(31), GPDat%(32))

    IF GPMonitor% > 0 THEN GPDat%(31) = GPMonitor% 'If something is placed
    ' in GPMonitor% this will force to a known screen.  This adddition allows
    ' forcing from outside the Include file to avoid saving changes to the
    ' include file.  GPMonitor% must be created using CONST.

    'IF GPDat%(31) = 8 Then GPDat%(31) = 9     'UnREM for VGA 256 color mode

    'GPDat%(31) = 4                            'UnREM to force CGA color mode
    'If GPDat%(31) = 4 Then GPDat%(31) = 6     'UnREM for HiRes CGA, no color

    GPDat%(32) = GPDat%(32) * 64               'MonType returns 1-4, adjust
					       '  to number of 64K blocks

    IF GPDat%(31) = 2 THEN
	IF NOT Hercthere% THEN
	    CLS
	    PRINT "You must run QBHERC.COM before running this program."
	    PRINT "Press any key to end.";
	    WHILE INKEY$ = "": WEND
	    END
	END IF
    END IF

