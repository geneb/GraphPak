'********** DemoReal.Bas - demo of the GraphPak realtime line graph

'Copyright (c) 1992 Phil Cramer
'Copyright (c) 1988 Crescent Software

DEFINT A-Z

'These DECLARE statements are for QuickBASIC 4.0.  If you are using QB 2
'or QB 3, add a REMark apostrophe and also remove one of the REMark
'apostrophes from the $INCLUDE lines at the end.

DECLARE SUB DrawText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)
DECLARE SUB GPPause ()
DECLARE SUB LoadFont (FontFile$)
DECLARE SUB Prepare ()
DECLARE SUB RealTime (GraphData!(), XTitle$(), YTitle$(), MainTitle$, Colors%(), Action%)
DECLARE SUB SetFont (FontNumber%)
DECLARE SUB SetSpacing (SpacingH%, SpacingV%)
DECLARE SUB SetVideo ()

DECLARE FUNCTION GetTextWidth% (Text$)
DECLARE FUNCTION HercThere%
DECLARE FUNCTION Rand# (Hi#, Lo#)




'$INCLUDE: 'Simple'    'SIMPLE.BAS contains code to determine the current
		       '  installed monitor, and load and process the font
		       '  and tile string arrays.  This file should ALWAYS
		       '  be included in your main module.

CALL SetVideo          'Initiate graphics (SCREEN n) based on monitor detected above
CALL SetSpacing(2, 2)  'Set font spacings in pixels, HSpacing, VSpacing

NumPoints = 50         'Number of points to plot, any number, 100 max for demo
NumLines = 2           'Number of lines to plot, any number, 21 max for demo

  
'---- Dim arrays to hold data and titles
REDIM GraphData!(NumLines)       'Redim to the total number of lines to plot
REDIM YTitle$(NumLines + 1)      'Redim to the total number of lines + 1
REDIM XTitle$(NumPoints + 1)     'Redim to the total number of points/line + 1

'---- Read in X axis titles
RESTORE XTitle
FOR X = 1 TO NumPoints + 1       'Read the X axis titles
  READ XTitle$(X)                'The first title is the X axis heading and is
NEXT

XTitle:                          'Display XTitle every 5th tick mark
DATA SECONDS                
DATA .01, ,,, .05, , , , , .10, , , , , .15, , , , , .20
DATA  , , , , .25, , , , , .30, , , , , .35, , , , , .40
DATA  , , , , .45, , , , , .50, , , , , .55, , , , , .60
DATA  , , , , .65, , , , , .70, , , , , .75, , , , , .80
DATA  , , , , .85, , , , , .90, , , , , .95, , , , , 1.00


'---- Read in Y axis titles
RESTORE YTitle
FOR X = 1 TO NumLines + 1       'Read the Y axis titles
  READ YTitle$(X)               'The first title is the Y axis heading
NEXT

YTitle:                     
DATA "Test Point        "
DATA TP1,  TP2,  TP3,  TP4,  TP5,  TP6,  TP7
DATA TP8,  TP9,  TP10, TP11, TP12, TP13, TP14
DATA TP15, TP16, TP17, TP18, TP19, TP20, TP21

'---- Graph title
MainTitle$ = "Voltage Monitor"
YHeading$ = "MILLIVOLTS"


'---- Set up colors array. First line color is Colors(1), second line Colors(2)
REDIM Colors(GPDat(50))
FOR T = 1 TO UBOUND(Colors)
    Colors(T) = T MOD GPDat%(50)
    IF T MOD GPDat%(50) = 0 THEN Colors(T) = 1
NEXT

GPDat(2) = 0          'Don't tile background (No effect with Action = -1 or -2)
GPDat(5) = 150        'Maximum value
GPDat(6) = -150       'Minimum value


'GPDat(57) = 8        'Background color

CALL Prepare          'Clear screen to background color (GPDat(57))
Count = 0             'Start counting at 0




'---- Demo #1 - This plot will end after one complete pass, plotting 2 lines
'               at once
DO
  Count = Count + 1
  FOR i = 1 TO NumLines     'Generate some data to plot
    IF i MOD 2 THEN         '
      Hi# = GPDat(5)
      Lo# = GPDat(6)
    ELSE
      Hi# = GPDat(5) \ 10
      Lo# = GPDat(6) \ 10
    END IF
    GraphData!(i) = Rand#(Hi#, Lo#)  'read data for next point to be plotted
  NEXT                               'This could be read from a COM port
 
  CALL RealTime(GraphData!(), XTitle$(), YTitle$(), MainTitle$, Colors(), Action)
  '               ^           ^          ^          ^
  '               ³           ³          ³          ÀÄÄÄ title at top right
  '               ³           ³          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of Y-Axis titles
  '               ³           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of X-Axis titles
  '               ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 1 dimension data array
LOOP UNTIL Count = NumPoints + 1     'Loop until all points are displayed

CALL GPPause       'Display graph until they hit a key
GPDat%(37) = 0     'We clear this variable to tell the next graph to
		   'pick its own screen size.
					    

' DEMO #2 - This plot displays the entire graph but waits for a key press
' before plotting any data.  Once a key is pressed, the graph will continue to
' plot data until another key is pressed.

CALL Prepare          'Clear screen to the background color (GPDat(57)
Action = -1           'Action -1 clears entire graph before plotting new data
GPDat(5) = 300        'Maximum value
GPDat(6) = -150       'Minimum value
GPDat(7) = 50

CALL RealTime(GraphData!(), XTitle$(), YTitle$(), MainTitle$, Colors(), Action)

Msg$ = "Press   any   key   to   begin   plotting  .  .  ."
CALL DrawText(5, 5, Msg$, 0, GPDat(56), 1)


WHILE INKEY$ = "": WEND                             'Wait for keypress

LINE (5, 5)-STEP(GetTextWidth%(Msg$), 16), GPDat(57), BF            'Clear message

DO

  FOR i = 1 TO NumLines     'Generate some data to plot
    IF i MOD 2 THEN         '
      Hi# = GPDat(5)
      Lo# = GPDat(6)
    ELSE
      Hi# = GPDat(5) \ 10
      Lo# = GPDat(6) \ 10
    END IF
    GraphData!(i) = Rand#(Hi#, Lo#)
  NEXT

  CALL RealTime(GraphData!(), XTitle$(), YTitle$(), MainTitle$, Colors(), Action)
  '               ^           ^          ^           ^
  '               ³           ³          ³           ÀÄÄÄ title at top right
  '               ³           ³          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of Y-Axis titles
  '               ³           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of X-Axis titles
  '               ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 1 dimension data array

LOOP UNTIL INKEY$ <> ""

CALL GPPause





'---- DEMO #3 - This plot will keep displaying new data until a key is pressed

CALL Prepare       'Clear screen to the background color (GPDat(57)
GPDat(5) = 1000    'Maximum value
GPDat(6) = 500     'Minimum value
Action = -2        'Action -2 clears just the portion being being graphed
CALL RealTime(GraphData!(), XTitle$(), YTitle$(), MainTitle$, Colors(), Action)
DO

  FOR i = 1 TO NumLines     'Generate some data to plot
    IF i MOD 2 THEN         '
      Hi# = GPDat(5)
      Lo# = GPDat(6)
    ELSE
      Hi# = GPDat(5)' \ 10
      Lo# = GPDat(6)' \ 10
    END IF
    GraphData!(i) = Rand#(Hi#, Lo#)
  NEXT

  CALL RealTime(GraphData!(), XTitle$(), YTitle$(), MainTitle$, Colors(), Action)
  '               ^           ^          ^           ^
  '               ³           ³          ³           ÀÄÄÄ title at top right
  '               ³           ³          ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of Y-Axis titles
  '               ³           ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ array of X-Axis titles
  '               ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 1 dimension data array

LOOP UNTIL INKEY$ <> ""

'********* End of demo


'For QuickBASIC 2 or 3, remove one of the REM apostrophes from each line below

''$INCLUDE: 'DrawChar'               'low level character routine
''$INCLUDE: 'DrawText'               'low level string routine
''$INCLUDE: '2DLine'                 'actual draw of 2D lines
''$INCLUDE: 'Axis2'                  'plots axis, set up variables
''$INCLUDE: 'FillPoly'               'draws a quadrilateral
''$INCLUDE: 'Display'                'displays main title
''$INCLUDE: 'SetVideo'               'sets video mode based on monitor type
''$INCLUDE: 'LoadFont'               'loads font files into Font$() array
''$INCLUDE: 'Support'                'Supporting Subroutines to all graphs

FUNCTION Rand# (Hi#, Lo#)

  Rand# = INT((Hi# - Lo# + 1)) * RND + Lo#

END FUNCTION

