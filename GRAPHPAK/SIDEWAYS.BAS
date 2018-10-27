'********** SideWays.Bas - demo of the GraphPak fonts drawing sideways

'Copyright (c) 1988 Brian Giedt
'Copyright (c) 1988 Crescent Software

DEFINT A-Z

DECLARE SUB GPPause ()
DECLARE SUB Prepare ()
DECLARE SUB SetVideo ()
DECLARE SUB SetFont (FontNumber%)
DECLARE SUB SetSpacing (SpacingH%, SpacingV%)
DECLARE SUB DrawText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)
DECLARE SUB StepText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)
DECLARE SUB LoadFont (FontFile$)
DECLARE FUNCTION GetTextWidth% (Text$)
DECLARE FUNCTION HercThere%

'$INCLUDE: 'Simple'   'see DEMOGPAK.BAS

CALL SetVideo

CALL SetSpacing(2, 2)             'Set Text Spacing to 12 pixels
Size# = 1                         'Set Text Size factor to 1

Shadow = 0
IF GPDat%(31) = 2 OR GPDat%(31) = 5 OR GPDat%(31) = 6 OR GPDat%(31) = 8 THEN
   IF GPDat%(31) <> 6 AND GPDat%(31) <> 2 THEN
       PAINT (1, 1), 4
       Shadow = 128
   END IF
ELSE
END IF

Angle = 90
Text$ = "SIDEWAYS CAN PRINT"
CALL DrawText(1, 10 + GetTextWidth%(Text$), Text$, Angle, 3 + Shadow, Size#)

Angle = 0
Text$ = "TEXT ON EITHER"
CALL DrawText((GPDat%(43) - GetTextWidth%(Text$)) \ 2, 10, Text$, Angle, 2 + Shadow, Size#)

Angle = -90
Text$ = "SIDE OF THE MONITOR"
CALL DrawText(GPDat%(43) - GPDat%(36) - 1, 10, Text$, Angle, 3 + Shadow, Size#)

Angle = 0
Text$ = "OR"
CALL DrawText((GPDat%(43) - GetTextWidth%(Text$)) \ 2, 2 * GPDat%(36), Text$, Angle, 3 + Shadow, Size#)

Angle = -90
Text$ = "STRAIGHT"
CALL StepText(GPDat%(43) \ 2 - 3.5 * GPDat%(35), 4 * GPDat%(36), Text$, Angle, 2 + Shadow, Size#)
Text$ = "DOWN"
CALL StepText(GPDat%(43) \ 2 - 1.5 * GPDat%(35), 4 * GPDat%(36), Text$, Angle, 2 + Shadow, Size#)
Text$ = "THE"
CALL StepText(GPDat%(43) \ 2 + .5 * GPDat%(35), 4 * GPDat%(36), Text$, Angle, 2 + Shadow, Size#)
Text$ = "MIDDLE"
CALL StepText(GPDat%(43) \ 2 + 2.5 * GPDat%(35), 4 * GPDat%(36), Text$, Angle, 2 + Shadow, Size#)

CALL GPPause
CALL Prepare
IF GPDat%(31) <> 2 AND GPDat%(31) <> 6 AND GPDat%(31) <> 4 THEN PAINT (1, 1), 1

Angle = 90
Text$ = "To Draw Text On This"
CALL DrawText(GPDat%(36), 10 + GetTextWidth(Text$), Text$, Angle, 3, Size#)
Text$ = "Side, Call DrawText"
CALL DrawText(GPDat%(36) * 2, 10 + GetTextWidth(Text$), Text$, Angle, 3, Size#)
Text$ = "with an Angle of 90"
CALL DrawText(GPDat%(36) * 3, 10 + GetTextWidth(Text$), Text$, Angle, 3, Size#)
Text$ = "Degrees."
CALL DrawText(GPDat%(36) * 4, 10 + GetTextWidth(Text$), Text$, Angle, 3, Size#)
'                  ^      ^       ^     
'                         |--------- this right justifies based on the number
'                                    of characters printed

Angle = -90
CALL DrawText(GPDat%(43) - GPDat%(36), 10, "To Draw Text On This", Angle, 3, Size#)
CALL DrawText(GPDat%(43) - GPDat%(36) * 2, 10, "Side, Call DrawText", Angle, 3, Size#)
CALL DrawText(GPDat%(43) - GPDat%(36) * 3, 10, "with an Angle of -90", Angle, 3, Size#)
CALL DrawText(GPDat%(43) - GPDat%(36) * 4, 10, "Degrees.", Angle, 3, Size#)

Angle = 180
Text$ = "How About That!"
CALL StepText((GPDat%(43) + LEN(Text$) * GPDat%(35)) \ 2 - 15, 170, Text$, Angle, 2 + Shadow, Size#)

''$INCLUDE: 'LoadFont'
''$INCLUDE: 'SetVideo'
''$INCLUDE: 'DrawText'
''$INCLUDE: 'DrawChar'
''$INCLUDE: 'Support'

