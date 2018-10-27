'********** DemoGpak.Bas - demo of the GraphPak routines for the Pro package

'Copyright (c) 1988 Brian Giedt
'Copyright (c) 1988 Crescent Software

DEFINT A-Z

'These DECLARE statements are for QuickBASIC 4.0.  If you are using QB 2
'or QB 3, add a REMark apostrophe and also remove one of the REMark
'apostrophes from the $INCLUDE lines at the end.

DECLARE SUB Prepare ()
DECLARE SUB GPPause ()
DECLARE SUB SetColors (ForeGround%, BackGround%, Headings%, ZeroAxis%)
DECLARE SUB SetSpacing (SpacingH%, SpacingV%)
DECLARE SUB SetFont (FontNumber%)
DECLARE SUB MaxMinValue (GraphData!(), YValue%, Answer!)
DECLARE FUNCTION GetTextWidth% (Text$)
DECLARE SUB LoadFont (FontFile$)
DECLARE SUB Line2 (GraphData!(), XTitle$(), YTitle$(), MainTitle$, Colors%())
DECLARE SUB Line2F (GraphData!(), XTitle$(), YTitle$(), MainTitle$)
DECLARE SUB Line2S (GraphData!(), XTitle$(), YTitle$(), MainTitle$)
DECLARE SUB Line3 (GraphData!(), XTitle$(), YTitle$(), MainTitle$)
DECLARE SUB Bars1 (GraphData!(), XTitle$(), MainTitle$)
DECLARE SUB Bars2 (GraphData!(), XTitle$(), YTitle$(), MainTitle$)
DECLARE SUB Bars3 (GraphData!(), XTitle$(), YTitle$(), MainTitle$)
DECLARE SUB Bars2H (GraphData!(), XTitle$(), YTitle$(), MainTitle$)
DECLARE SUB Bars2S (GraphData!(), XTitle$(), YTitle$(), MainTitle$)
DECLARE SUB HighLow (GraphData!(), XTitle$(), YTitle$(), MainTitle$, Colors%())
DECLARE SUB Pie (GraphData!(), XTitle$(), MainTitle$)
DECLARE SUB DrawText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)
DECLARE SUB SetVideo ()
DECLARE FUNCTION HercThere%
DECLARE FUNCTION MakeBinary (Bin$)

'$INCLUDE: 'Simple'     'SIMPLE.BAS contains code to determine the current
			'  installed monitor, and load and process the font
			'  and tile string arrays

CALL SetVideo   'initiate graphics (SCREEN n) based on monitor detected above


'----- Set the spacing between characters and sizes for the text demonstration

CALL SetSpacing(2, 2)

EGATile$ = CHR$(0) + CHR$(0) + CHR$(255) + CHR$(255) + CHR$(0) + CHR$(0)

IF GPDat%(31) = 2 OR GPDat%(31) = 5 OR GPDat%(31) = 8 THEN 'EGA opening screen

   LINE (4, 4)-(GPDat%(43) - 6, GPDat%(44) - (GPDat%(36) + 3)), 15, B
   LINE (6, 6)-(GPDat%(43) - 8, GPDat%(44) - (GPDat%(36) + 5)), 15, B

IF GPDat%(31) = 8 THEN               'vga only !
   PAINT (20, 20), AltTile$(3), 15      'paint tiled backdrop
   LINE (125, 33)-(224, 143), 1, BF     'draw box outline
   LINE (125, 33)-(224, 143), 0, B      'draw box outline
   LINE (224, 37)-(233, 147), 0, BF     'draw box left shadow
   LINE (129, 143)-(233, 147), 0, BF    'draw box bottom shadow
   CIRCLE (160, 88), 53, 15             'draw circle outline
   CIRCLE (185, 88), 53, 15, 1.8, 4.5   'draw inner portion of circle
   PAINT (110, 88), 0, 15               'paint outside arc black
   CIRCLE (160, 88), 53, 0              'draw circle outline
   CIRCLE (185, 88), 53, 0, 1.8, 4.5    'draw inner portion of circle
   PAINT (200, 88), 15, 0               'paint inside of box white
   PAINT (106, 34), EGATile$, 0         'tile upper left corner
   PAINT (106, 142), EGATile$, 0        'tile lower left corner
   PAINT (223, 34), EGATile$, 0         'tile upper right corner
   PAINT (223, 142), EGATile$, 0        'tile lower right corner

ELSE                                    'ega etc...
   IF GPDat%(31) = 5 THEN
      PAINT (20, 20), AltTile$(3), 15   'paint tiled backdrop
   END IF
   LINE (105, 33)-(235, 143), 1, BF     'draw box outline
   LINE (105, 33)-(235, 143), 0, B      'draw box outline
   LINE (235, 37)-(240, 147), 0, BF     'draw box left shadow
   LINE (109, 143)-(235, 147), 0, BF    'draw box bottom shadow
   PAINT (106, 34), 15, 0               'paint inside of box white
   CIRCLE (160, 88), 75, 15             'draw circle outline
   CIRCLE (185, 88), 75, 15, 1.8, 4.5   'draw inner portion of circle
   PAINT (104, 88), 0, 15               'paint outside arc black
   PAINT (102, 120), 0, 15              'help for paint on line above
   CIRCLE (160, 88), 75, 0              'draw circle outline
   CIRCLE (185, 88), 75, 0, 1.8, 4.5    'draw inner portion of circle
   PAINT (110, 88), 0, 0                'paint outside arc black
   PAINT (105, 120), 0, 0               'help for paint on line above
   PAINT (106, 88), 0, 0                'paint inside arc black
 
   IF GPDat%(31) = 2 THEN
	CIRCLE (160, 88), 75, 1, 1.65, 4.75  'draw circle outline
	PAINT (20, 20), AltTile$(3), 15      'paint tiled backdrop
   END IF
 
   PAINT (106, 34), EGATile$, 0         'tile upper left corner
   PAINT (106, 142), EGATile$, 0        'tile lower left corner
   PAINT (234, 34), EGATile$, 0         'tile upper right corner
   PAINT (234, 142), EGATile$, 0        'tile lower right corner
END IF

   CALL DrawText(260, 30, "Crescent", 0, 12 + 128, 3#)
'                 ^    ^       ^       ^    ^     ^
'                 ³    ³       ³       ³    ³     ÀÄÄÄÄÄ height of text
'                 ³    ³       ³       ³    ÀÄÄÄÄÄÄÄÄÄÄÄ color of text
'                 ³    ³       ³       ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ angle to draw at
'                 ³    ³       ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ the text to display
'                 ³    ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄ X and Y location of top
'                 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  left corner of string

   CALL DrawText(285, 70, "Software", 0, 12 + 128, 3#)
   CALL DrawText(310, 110, "Presents", 0, 12 + 128, 3#)
   PLAY "MBL16O2CEG>CEG>CL32O2CDEFGAB>CDEFGAB>CDEFGAB>L12C"

   CALL DrawText(60, 200, "GraphPak", 5, 14, 7#)
   GPDat%(59) = -3
   CALL DrawText(85, 210, STRING$(11, "_"), 5, 5, 5.6#)
   GPDat%(59) = 0
   GPDat%(24) = 70          'Italicize text at 60 degrees
   CALL DrawText(400, 290, "by Brian Giedt", 0, 11, 2#)
   GPDat%(24) = 90          'Return text to normal

ELSE                                    'CGA opening screen

   LINE (4, GPDat%(36) + 1)-(GPDat%(43) - 6, GPDat%(44) - GPDat%(36) - 3), 15, B
   LINE (6, GPDat%(36) + 3)-(GPDat%(43) - 8, GPDat%(44) - GPDat%(36) - 5), 15, B

   IF GPDat%(31) <> 6 THEN
       PAINT (10, 21), 1, 15                'paint blue backdrop
   END IF
   LINE (53, 29)-(120, 92), 0, BF       'draw box outline
   LINE (53, 29)-(120, 92), 2, BF       'draw box in white
   LINE (53, 29)-(120, 92), 0, B        'draw box outline
   LINE (120, 31)-(122, 94), 0, BF      'draw box left shadow
   LINE (55, 92)-(122, 94), 0, BF       'draw box bottom shadow
   CIRCLE (82, 60), 36, 0               'draw circle outline
   CIRCLE (94, 60), 36, 0, 1.8, 4.5     'draw inner portion of circle
   PAINT (52, 60), 0, 0                 'paint outside arc black
   PAINT (54, 60), 0, 0                 'paint inside arc black
   PAINT (94, 60), 3, 0                 'paint inside of box white

   CALL DrawText(130, 33, "Crescent", 0, 2 + 128, 2.1#)
   CALL DrawText(143, 50, "Software", 0, 2 + 128, 2.1#)
   CALL DrawText(155, 67, "Presents", 0, 2 + 128, 2.1#)
   PLAY "MBL16O2CEG>CEG>CL32O2CDEFGAB>CDEFGAB>CDEFGAB>L12C"

   IF GPDat%(31) = 6 THEN
      CALL DrawText(30, 140, "GraphPak", 10, 1, 4#)
   ELSE
      CALL DrawText(30, 140, "GraphPak", 10, 0, 4#)
   END IF
   GPDat%(59) = -2
   CALL DrawText(32, 144, STRING$(9, "_"), 10, 2, 4#)
   GPDat%(59) = 0
   GPDat%(24) = 60      'Italicize the text at 60 degrees
   CALL DrawText(160, 170, "by Brian Giedt", 0, 2, 1.5#)
   GPDat%(24) = 90      'Return the text to normal
END IF

'********************************************************************
'It is important to set the spacing for normal text after the above
'code has changed it.
CALL SetSpacing(2, 2)
CALL GPPause
CALL Prepare


'----- Dim the arrays that will hold the data for the various graphs

REDIM GraphData!(3, 6), PieData!(6), XTitle$(4), YTitle$(7), PTitle$(7)
REDIM Colors%(16)

FOR T = 1 TO 16
    Colors%(T) = T
NEXT

RESTORE Here            'the files included earlier contain data statements,
			'  and this guarantees the correct data will be read

FOR Y = 1 TO 6          'read data for the bar and line graphs
    FOR X = 1 TO 3
	READ GraphData!(X, Y)
    NEXT
NEXT

Here:
DATA 72, 70, 100
DATA 20, 42, 74
DATA 34, 32, 70
DATA 42, 34, 60
DATA 11, 20, 17
DATA 10, 37, 52

FOR X = 1 TO 6          'read the data for the pie chart
    READ PieData!(X)
NEXT
DATA 11, 19, 30, 45, 78, 92

FOR X = 1 TO 4          'read the X axis titles
    READ XTitle$(X)     'the first title is the X axis heading
NEXT
DATA SALES, Jan, Feb, Mar

FOR Y = 1 TO 7
    READ YTitle$(Y)
NEXT
DATA PRODUCTS
DATA Product X, Product Y, Product Z, Product A, Product B, Product C

FOR X = 1 TO 7                          'read the pie chart titles
    READ PTitle$(X)
NEXT
DATA SALES, Jan, Feb, Mar, Apr, May, June

MainTitle$ = "CRESCENT_SALES"           'the underscore forces a line break


'The comments directly below show how to create a single line graph
'
'REDIM GraphData!(3,1), XTitle$(4), YTitle$(1)
'GraphData!(1,1) = 20
'GraphData!(2,1) = 30
'GraphData!(3,1) = 80
'XTitle$(1) = "SALES"
'XTitle$(2) = "January"
'XTitle$(3) = "February"
'XTitle$(4) = "March"



'*****************************************************************************
GPDat%(2) = 0    'Don't Display Background Tiles
GPDat%(9) = 4    'Set Main Title Color to 4(Red on the EGA)

'Set the screen colors - Keep the current Foreground and Background
'                      - Make the headings Green(EGA)
'                      - Make the Zero-Axis Yellow(EGA)
CALL SetColors(GPDat%(56), GPDat%(57), 2, 12)

CALL Prepare
'=========================== LINE GRAPHS =====================

CALL Line2(GraphData!(), XTitle$(), YTitle$(), MainTitle$, Colors%())
'               ^           ^          ^           ^
'               ³           ³          ³           ÀÄÄÄ title at top right
'               ³           ³          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of Y-Axis titles
'               ³           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of X-Axis titles
'               ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 2 dimension data array

'Line2F will do an area chart in a similar fashion to Line2 above
CALL GPPause
CALL Prepare
CALL Line2F(GraphData!(), XTitle$(), YTitle$(), MainTitle$)

CALL GPPause
CALL Prepare
GPDat%(5) = 0
FOR T1 = 1 TO UBOUND(GraphData!, 2)
    AAA! = 0
    CALL MaxMinValue(GraphData!(), T1, AAA!)
    GPDat%(5) = GPDat%(5) + AAA! + .5
NEXT
GPDat%(5) = (INT(GPDat%(5) / 100) + 1) * 100
GPDat%(7) = GPDat%(5) / 10
GPDat%(18) = 0
GPDat%(21) = -1
CALL Line2S(GraphData!(), XTitle$(), YTitle$(), MainTitle$)
GPDat%(5) = 100
GPDat%(7) = 20


'=========================== BAR GRAPHS =====================

CALL GPPause
CALL Prepare
CALL Bars1(PieData!(), PTitle$(), MainTitle$)
'             ^           ^           ^
'             ³           ³           ³
'             ³           ³           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ title at top right
'             ³           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ text array of titles
'             ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of graph data

CALL GPPause
CALL Prepare
CALL Bars2(GraphData!(), XTitle$(), YTitle$(), MainTitle$)     'same as Line2

'=========================== STACKED BAR GRAPHS =====================

CALL GPPause
CALL Prepare
GPDat%(5) = 0
FOR T1 = 1 TO UBOUND(GraphData!, 2)
    AAA! = 0
    CALL MaxMinValue(GraphData!(), T1, AAA!)
    GPDat%(5) = GPDat%(5) + AAA! + .5
NEXT
GPDat%(5) = (INT(GPDat%(5) / 100) + 1) * 100
GPDat%(7) = GPDat%(5) / 10
CALL Bars2S(GraphData!(), XTitle$(), YTitle$(), MainTitle$)    'same as Line2
GPDat%(5) = 100
GPDat%(7) = 20

CALL GPPause
CALL Prepare
CALL Bars2H(GraphData!(), XTitle$(), YTitle$(), MainTitle$)    'same as Line2

'=========================== HIGH-LOW-CLOSE GRAPHS =====================

CALL GPPause
CALL Prepare
CALL HighLow(GraphData!(), XTitle$(), YTitle$(), MainTitle$, Colors%())  'same as Line2

CALL GPPause
CALL Prepare
GPDat%(13) = 0
CALL HighLow(GraphData!(), XTitle$(), YTitle$(), MainTitle$, Colors%())   'same as Line2


'=========================== 3 DIMENSIONAL GRAPHS =====================

CALL GPPause
CALL Prepare
CALL Bars3(GraphData!(), XTitle$(), YTitle$(), MainTitle$)     'same as Line2

CALL GPPause
CALL Prepare
GPDat%(10) = 50                           'Angle of X axis
CALL Line3(GraphData!(), XTitle$(), YTitle$(), MainTitle$)     'same as Line2

CALL GPPause
CALL Prepare
GPDat%(10) = 70                           'Angle of Pie
CALL Pie(PieData!(), PTitle$(), MainTitle$)


CALL GPPause
CLS
'********* End of demo
