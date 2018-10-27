'********** Simple.Bas - simplifies loading necessary GraphPak $Include files

'Copyright (c) 1988 Brian Giedt
'Copyright (c) 1988 Crescent Software

'$INCLUDE: 'GetVideo'           'gets monitor type, and EGA memory
				'GetVideo also contains COMMON and SHARED
				'  declarations needed to make certain key
				'  variables available in the subprograms

'
'**** Setup Some of the new variables for external graph control
'
'$INCLUDE: 'SetGPDat'


'----- Helv12.GFN contains font information for a high-resolution font
'      Helv8.GFN is for use with CGA monitors
'
IF GPDat%(31) = 2 OR GPDat%(31) = 5 OR GPDat%(31) > 6 THEN
   FontFile$ = "Helv12"
ELSE
   FontFile$ = "Helv8"
END IF

CALL SetFont(1)                 'specify loading font number 1
CALL LoadFont(FontFile$)        'load fonts from disk into the Font$() array
CALL SetFont(1)                 'needed to set Font Variables

'$INCLUDE: 'ReadTile'

