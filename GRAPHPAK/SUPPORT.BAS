'********** Support.Bas - subprograms used by many other programs

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'These Declare statements are for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE SUB DrawText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)
DECLARE SUB StepText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)
DECLARE FUNCTION GetTextWidth% (Text$)
DECLARE FUNCTION MakeBinary% (Bin$)

'$INCLUDE: 'Common'

'This Sub program creates the group titles along the X-axis of bar charts
'
SUB BarGrouping (XTitle$(), XBound%) STATIC
  
    IF GPDat%(1) = 0 THEN EXIT SUB  'Don't Show Legends

    'Draw Groupings Title
    T1 = GPDat%(37) + (GPDat%(39) - GetTextWidth(XTitle$(1))) \ 2
    T2 = GPDat%(38) + 8 + GPDat%(36)
    CALL DrawText(T1, T2, XTitle$(1), 0, GPDat%(58), 1#)

    'Draw the Rest of the Titles
    T2 = GPDat%(38) + 8
    FOR S2 = 2 TO XBound + 1
        T1 = GPDat%(37) + (S2 - 2) * GPDat%(41) + GPDat%(41) \ 2

        'Show a tick mark to identify the grouping
        IF GPDat%(3) THEN
            LINE (T1, GPDat%(38) + 5)-(T1, GPDat%(38)), GPDat%(56)
            LINE STEP(0, -1)-STEP(0, -(GPDat%(40) - 1)), GPDat%(56), , GPDat%(61)
        END IF

        T1 = T1 - GetTextWidth(XTitle$(S2)) \ 2

        'Draw the group title
        CALL DrawText(T1, T2, XTitle$(S2), 0, GPDat%(56), 1#)
    NEXT

END SUB

'This Routine Draws the legend below Bar graphs
'
SUB BarLegend (YTitle$(), YBound%) STATIC

    IF GPDat%(1) = 0 THEN EXIT SUB    'Don't Show Legends
    IF YBound% > 6 THEN EXIT SUB

    'Draw Legend Title
    T1 = 3
    T3 = T1 + GetTextWidth(YTitle$(1))
    T2 = GPDat%(38) + GPDat%(36) * 2 + 11
    CALL DrawText(T1, T2, YTitle$(1), 0, GPDat%(58), 1#)

    MaxTileNum = UBOUND(Tile$)    'Obtain a local variable of max number of
                                  'tiles available
    'Draw the rest of the Titles
    FOR S2 = 2 TO YBound + 1
        T4 = GetTextWidth(YTitle$(S2))
        IF T4 > MaxWidth THEN MaxWidth = T4
    NEXT
    T1 = T3 + 2 * GPDat%(47)
    LastT2 = T2 + GPDat%(36)
   
   
    FOR S2 = 2 TO YBound + 1
        LastT1 = T1
       
        'Draw a box and fill it to show the bar color to them
        LINE (T1, T2)-(T1 + GPDat%(36) - 2, T2 + GPDat%(36) - 2), GPDat%(56), B
        PAINT (T1 + 1, T2 + 1), Tile$(((S2 - 2) MOD MaxTileNum) + 1), GPDat%(56)

        'Draw the title
        CALL DrawText(T1 + GPDat%(36) + 2 * GPDat%(47), T2, YTitle$(S2), 0, GPDat%(56), 1#)

        T2 = T2 + GPDat%(36)
        IF T2 + GPDat%(36) >= GPDat%(44) THEN
            LastT2 = T2
            T2 = GPDat%(38) + GPDat%(36) * 2 + 11
            T1 = T1 + MaxWidth + GPDat%(36) + 5 * GPDat%(47)
        END IF
    NEXT
    IF T2 > LastT2 THEN LastT2 = T2

    LINE (0, GPDat%(38) + GPDat%(36) * 2 + 8)-(LastT1 + MaxWidth + GPDat%(36) + 5 * GPDat%(47), LastT2), GPDat%(58), B

END SUB

'This Routine Draws the scaling along the Y(2 dimensional) or Z(3 dimensional)
'axis of the graph.  Is called from DrawAxis or DrawAxis3
'
SUB DrawPercent (ThreeDimensional%) STATIC

    'Determine Maximum number of digits
    Resolution% = LEN(STR$(GPDat%(5))) - 1

    IF GPDat%(15) = 0 OR GPDat%(15) = 2 THEN
      'draw percentages along left wall
      T2 = GPDat%(5)
      T1 = GPDat%(37) - 8
      T3 = GPDat%(38) - 5
      IF ThreeDimensional% THEN
          T1 = T1 - GPDat%(39) * XaAspect#
          T3 = T3 + GPDat%(39) * XbAspect#
      END IF
      FOR T = T3 - GPDat%(40) TO T3 STEP GPDat%(40) \ ((GPDat%(5) - GPDat%(6)) \ GPDat%(7))
          T$ = STR$(T2)
          IF T2 >= GPDat%(6) THEN CALL DrawText(T1 - GetTextWidth(STR$(T2)), T, T$, 0, GPDat%(56), 1#)
          T2 = T2 - GPDat%(7)
      NEXT
    END IF

    IF GPDat%(15) = 1 OR GPDat%(15) = 2 THEN
      'draw percentages along right wall
      Shift = 0
      IF GPDat%(8) THEN Shift = GPDat%(42) - INT(.7 * GPDat%(42) + .5)
      T2 = GPDat%(5)
      T1 = GPDat%(37) + GPDat%(39) + 8 + Shift
      T3 = GPDat%(38) - 5 - Shift
      IF ThreeDimensional% THEN
          T1 = GPDat%(37) + GPDat%(36) + GPDat%(39) * YaAspect#
          T3 = T3 + GPDat%(39) * YbAspect#
      END IF
      FOR T = T3 - GPDat%(40) TO T3 STEP GPDat%(40) \ ((GPDat%(5) - GPDat%(6)) \ GPDat%(7))
          T$ = MID$(STR$(T2), 2)
          IF T2 >= GPDat%(6) THEN CALL DrawText(T1, T, T$, 0, GPDat%(56), 1#)
          T2 = T2 - GPDat%(7)
      NEXT
    END IF

    IF GPDat%(1) = 0 THEN EXIT SUB    'Don't Show Legends

    IF GPDat%(15) = 0 OR GPDat%(15) = 2 THEN
      'Draw Legend Along Left Wall
      T1 = GPDat%(37) - GetTextWidth(STR$(GPDat%(5))) - GPDat%(36) - 10
      IF T1 < 0 THEN T1 = 0
      T2 = GPDat%(38) - (GPDat%(40) + LEN(YHeading$) * GPDat%(36)) \ 2
      IF ThreeDimensional% THEN
          T1 = T1 - GPDat%(39) * XaAspect#
          T2 = T2 + GPDat%(39) * XbAspect#
      END IF
      CALL StepText(T1, T2, YHeading$, -90, GPDat%(58), 1#)
    END IF

    IF GPDat%(15) = 1 OR GPDat%(15) = 2 THEN
      'Draw Legend Along Right Wall
      T1 = GPDat%(37) + GPDat%(39) + GetTextWidth(STR$(GPDat%(5))) + GPDat%(47) + 5 + Shift
      T2 = GPDat%(38) - (GPDat%(40) + LEN(YHeading$) * GPDat%(36)) \ 2 - Shift
      IF ThreeDimensional% THEN
          T1 = GPDat%(37) + GPDat%(36) * (Resolution% + 1) + GPDat%(39) * YaAspect#
          T2 = T2 + GPDat%(39) * YbAspect#
      END IF
      IF T1 < GPDat%(43) - GPDat%(35) THEN
          CALL StepText(T1, T2, YHeading$, -90, GPDat%(58), 1#)
      END IF
    END IF

END SUB

FUNCTION GetTextWidth% (Text$) STATIC
   
    FW = 0
    FOR T = 1 TO LEN(Text$)
        L = ASC(MID$(Text$, T, 1)) - 31
        FW = FW + FontWidth%(L, GPDat%(34)) + GPDat%(47)
    NEXT
    GetTextWidth% = FW

END FUNCTION

SUB GPPause STATIC

    P$ = " Press a key  .  .  .   "
    WHILE INKEY$ <> "": WEND
    IF GPDat%(31) = 4 OR GPDat%(31) = 9 THEN
       Xa = 1
       Ya = 1
    ELSE
       Xa = GPDat%(43) - GetTextWidth%(P$)
       Ya = GPDat%(44) - GPDat%(36) - 1
    END IF
    CALL DrawText(Xa, Ya, P$, 0, GPDat%(56), 1#)

    DO
       A$ = INKEY$
    LOOP UNTIL LEN(A$)

END SUB

SUB LeftLower STATIC

    IF GPDat%(31) = 2 OR GPDat%(31) = 5 THEN    'EGA or Hercules
       GPDat%(37) = 40: GPDat%(38) = 325
       GPDat%(39) = 270: GPDat%(40) = 145
    ELSEIF GPDat%(31) = 8 THEN                   'VGA
       GPDat%(37) = 40: GPDat%(38) = 460
       GPDat%(39) = 270: GPDat%(40) = 200
    ELSEIF GPDat%(31) = 6 THEN                   'CGA 2 Color Mode
       GPDat%(37) = 45: GPDat%(38) = 190
       GPDat%(39) = 250: GPDat%(40) = 85
    ELSE                                         'CGA 4 Color Mode
       GPDat%(37) = 30: GPDat%(38) = 190
       GPDat%(39) = 125: GPDat%(40) = 85
    END IF

END SUB

SUB LeftUpper STATIC
  
    IF GPDat%(31) = 2 OR GPDat%(31) = 5 THEN    'EGA or Hercules
       GPDat%(37) = 40: GPDat%(38) = 150
       GPDat%(39) = 270: GPDat%(40) = 145
    ELSEIF GPDat%(31) = 8 THEN                   'VGA
       GPDat%(37) = 40: GPDat%(38) = 220
       GPDat%(39) = 270: GPDat%(40) = 200
    ELSEIF GPDat%(31) = 6 THEN                   'CGA 2 Color Mode
       GPDat%(37) = 45: GPDat%(38) = 90
       GPDat%(39) = 250: GPDat%(40) = 85
    ELSE                                         'CGA 4 Color Mode
       GPDat%(37) = 30: GPDat%(38) = 98
       GPDat%(39) = 125: GPDat%(40) = 85
    END IF

END SUB

'This routine Draws labels below the data points
'
SUB LineGrouping (XTitle$(), XBound) STATIC
  
    IF GPDat%(1) = 0 THEN EXIT SUB     'Don't Show Legends

    'Draw Line Groupings Heading
    T1 = GPDat%(37) + (GPDat%(39) - GetTextWidth(XTitle$(1))) \ 2
    T2 = GPDat%(38) + GPDat%(36) + 8
    CALL DrawText(T1, T2, XTitle$(1), 0, GPDat%(58), 1#)

    'Draw The Rest of the Titles
    T2 = GPDat%(38) + 8
    FOR S2 = 2 TO XBound + 1
        IF GPDat%(21) THEN
            T1 = GPDat%(37) + (S2 - 2) * GPDat%(41)
        ELSE
            T1 = GPDat%(37) + (S2 - 2) * GPDat%(41) + GPDat%(41) \ 2
        END IF

        'Draw a tick Mark to show positioning of point
        IF GPDat%(3) THEN
            LINE (T1, GPDat%(38) + 5)-(T1, GPDat%(38)), GPDat%(56)
            'LINE STEP(0, -1)-STEP(0, -(GPDat%(40) - 1)), GPDat(56), , GPDat%(61)
            LINE STEP(0, -1)-STEP(0, -(GPDat%(40) - 1)), 8, , GPDat%(61)
        END IF

        T1 = T1 - GetTextWidth(XTitle$(S2)) \ 2

        'Draw the title
        CALL DrawText(T1, T2, XTitle$(S2), 0, GPDat%(56), 1#)
    NEXT

END SUB

'This Routine Creates a legend below the graph to make connections between
'colors of lines and the meaning
'
SUB LineLegend (YTitle$(), YBound%, GPLTile%(), Colors%()) STATIC

    IF GPDat%(1) = 0 THEN EXIT SUB     'Don't Show Legends
'   IF YBound% > 6 THEN EXIT SUB

    'Draw Legend Title
    T1 = 3
    T3 = T1 + GetTextWidth(YTitle$(1))
    T2 = GPDat%(38) + GPDat%(36) * 2 + 11
    CALL DrawText(T1, T2, YTitle$(1), 0, GPDat%(58), 1#)

    MaxTileNum% = UBOUND(GPLTile%)  'Obtain a local variable with the max
                                    'number of tiles available

    FOR S2 = 2 TO YBound + 1
        T4 = GetTextWidth(YTitle$(S2))
        IF T4 > MaxWidth THEN MaxWidth = T4
    NEXT
    T1 = T3 + 2 * GPDat%(47)
    LastT2 = T2 + GPDat%(36)
    'Draw the rest of the titles
    T3 = 0 'Start with tile number 1 (Note: it will automatically get incrmented once)
    FOR S2 = 2 TO YBound + 1
        LastT1 = T1
        Colr = Colors%((S2 - 2) MOD UBOUND(Colors) + 1)
        IF Colr = GPDat%(57) THEN Colr = GPDat%(56)
        'Draw a sample of the line
        IF Colr = Colors%(1) THEN T3 = T3 MOD MaxTileNum + 1  'Use next Tile
        
        'UpperOptions are used to make points stand out
        UpperOption = (Colr \ 256) \ 16
        LINE (T1 + 15, T2 + GPDat%(36) \ 2)-(T1, T2 + GPDat%(36) \ 2), Colr, , GPLTile%(T3)
        IF UpperOption = 1 THEN                                     'Box
          LINE -STEP(0, -2), Colr
          LINE -STEP(4, 4), Colr, BF
        ELSEIF UpperOption = 2 THEN                                 'Circle
          CIRCLE (T1 + 3, T2 + GPDat%(36) \ 2), 1.5, Colr
          CIRCLE (T1 + 3, T2 + GPDat%(36) \ 2), 2, Colr
          CIRCLE (T1 + 3, T2 + GPDat%(36) \ 2), 2.5, Colr
          CIRCLE (T1 + 3, T2 + GPDat%(36) \ 2), 3, Colr
          CIRCLE (T1 + 3, T2 + GPDat%(36) \ 2), 3.5, Colr
        ELSEIF UpperOption = 3 THEN                                 'Asterisk
          LINE -STEP(3, 0), Colr
          LINE -STEP(-3, -3), Colr
          LINE -STEP(6, 6), Colr
          LINE STEP(-6, 0)-STEP(6, -6), Colr
          LINE STEP(-3, 0)-STEP(0, 6), Colr
          LINE STEP(-3, -3)-STEP(6, 0), Colr
          LINE -STEP(-3, 0), Colr           're-center for next LINE statement
        END IF

        'Draw the title
        Colr = Colr MOD 256
        CALL DrawText(T1 + 15 + 2 * GPDat%(47), T2, YTitle$(S2), 0, Colr, 1#)

        T2 = T2 + GPDat%(36)
        IF T2 + GPDat%(36) >= GPDat%(44) THEN
            LastT2 = T2
            T2 = GPDat%(38) + GPDat%(36) * 2 + 11
            T1 = T1 + MaxWidth + 15 * GPDat%(47)
        END IF
    NEXT
    IF T2 > LastT2 THEN LastT2 = T2

    LINE (0, GPDat%(38) + GPDat%(36) * 2 + 8)-(LastT1 + MaxWidth + 15 * GPDat%(47), LastT2), GPDat%(58), B

END SUB

FUNCTION MakeBinary% (Bin$) STATIC

    A = 0
    FOR T = 2 TO 16
        IF MID$(Bin$, T, 1) = "1" THEN A = A + 1
        IF T < 16 THEN A = A * 2
    NEXT
    IF MID$(Bin$, 1, 1) = "1" THEN
        A = A - 32768
    END IF
    MakeBinary% = A

END FUNCTION

SUB MaxMinValue (GraphData!(), YValue, Answer!) STATIC

    Max! = GraphData!(1, YValue)
    Min! = Max!
    FOR T = 2 TO UBOUND(GraphData!, 1)
        A! = GraphData!(T, YValue)
        IF A! > Max! THEN
            Max! = A!
        ELSEIF A! < Min! THEN
            Min! = A!
        END IF
    NEXT
    IF Answer! < 0 THEN
        Answer! = Min!
    ELSE
        Answer! = Max!
    END IF

END SUB

SUB Prepare STATIC

    LINE (0, 0)-(GPDat%(43) - 1, GPDat%(44) - 1), GPDat%(57), BF

END SUB

SUB RightLower STATIC
  
    IF GPDat%(31) = 2 OR GPDat%(31) = 5 THEN    'EGA or Hercules
       GPDat%(37) = 360: GPDat%(38) = 325
       GPDat%(39) = 270: GPDat%(40) = 145
    ELSEIF GPDat%(31) = 8 THEN                   'VGA
       GPDat%(37) = 360: GPDat%(38) = 460
       GPDat%(39) = 270: GPDat%(40) = 200
    ELSEIF GPDat%(31) = 6 THEN                   'CGA 2 Color Mode
       GPDat%(37) = 365: GPDat%(38) = 190
       GPDat%(39) = 250: GPDat%(40) = 85
    ELSE                                         'CGA 4 Color Mode
       GPDat%(37) = 190: GPDat%(38) = 190
       GPDat%(39) = 125: GPDat%(40) = 85
    END IF

END SUB

SUB RightUpper STATIC

    IF GPDat%(31) = 2 OR GPDat%(31) = 5 THEN    'EGA or Hercules
       GPDat%(37) = 360: GPDat%(38) = 150
       GPDat%(39) = 270: GPDat%(40) = 145
    ELSEIF GPDat%(31) = 8 THEN                   'VGA
       GPDat%(37) = 360: GPDat%(38) = 220
       GPDat%(39) = 270: GPDat%(40) = 200
    ELSEIF GPDat%(31) = 6 THEN                   'CGA 2 Color Mode
       GPDat%(37) = 365: GPDat%(38) = 90
       GPDat%(39) = 250: GPDat%(40) = 85
    ELSE                                         'CGA 4 Color Mode
       GPDat%(37) = 190: GPDat%(38) = 90
       GPDat%(39) = 125: GPDat%(40) = 85
    END IF

END SUB

'This sub-program calculates the aspect for the 3D routines
'
SUB SetAspect (Angle1%, Angle2%) STATIC
   
    'Y Aspect of X-axis
    XaAspect# = SIN((Angle1% / 180) * (22 / 7))
    XbAspect# = COS((Angle1% / 180) * (22 / 7))  'X Aspect of X-axis
    'Y Aspect of Y-axis
    YaAspect# = SIN((Angle2% / 180) * (22 / 7))
    YbAspect# = COS((Angle2% / 180) * (22 / 7))  'X Aspect of Y-axis

END SUB

SUB SetColors (ForeGround%, BackGround%, Headings%, ZeroAxis%) STATIC

    GPDat%(56) = ForeGround%
    GPDat%(57) = BackGround%
    GPDat%(58) = Headings%
    GPDat%(55) = ZeroAxis%
    'If it's a screen with less possible colors then check them to fit
    IF GPDat%(31) = 4 OR GPDat%(31) = 6 OR GPDat%(31) = 2 THEN
      GPDat%(56) = GPDat%(56) MOD GPDat%(50)
      GPDat%(57) = GPDat%(57) MOD GPDat%(50)
      GPDat%(58) = GPDat%(58) MOD GPDat%(50)
      GPDat%(55) = GPDat%(55) MOD GPDat%(50)
    END IF
    IF GPDat%(57) MOD 8 = GPDat%(56) MOD 8 THEN 'Check The BackGround Color
      'There is going to be a conflict, so fix it up here
      IF GPDat%(56) MOD 8 <> 0 THEN  'If Possible make the BackGround Black
        GPDat%(57) = 0
      ELSE
        GPDat%(57) = (GPDat%(57) + 1) MOD GPDat%(50)
      END IF
    END IF
    IF GPDat%(58) MOD 8 = GPDat%(57) MOD 8 THEN 'Check The Headings Color
      'There is going to be a conflict, so fix it up here
      IF GPDat%(57) MOD 8 <> 2 THEN  'If Possible make the Heading Green(EGA)
        GPDat%(58) = 2
      ELSE
        GPDat%(58) = (GPDat%(58) + 1) MOD GPDat%(50)
      END IF
    END IF
    IF GPDat%(55) MOD 8 = GPDat%(57) MOD 8 THEN 'Check the Zero-Axis Color
      'There is going to be a conflict, so fix it up here
      IF GPDat%(57) MOD 8 <> 2 THEN  'If Possible make the Zero-Axis Green(EGA)
        GPDat%(55) = 2
      ELSE
        GPDat%(55) = (GPDat%(55) + 1) MOD GPDat%(50)
      END IF
    END IF
    IF GPDat%(31) = 6 OR GPDat%(31) = 2 THEN 'Fixup Where other sections couldn't
      A = GPDat%(57)
      IF A = 0 THEN A = 1 ELSE A = 0
      GPDat%(56) = A   'Make all the titles opposite of the background
      GPDat%(58) = A
      GPDat%(55) = A
    END IF

END SUB

'This Routine changes the current font
'
SUB SetFont (FontNumber%) STATIC

    'Check for invalid FontNumber
    IF FontNumber% < 0 OR FontNumber% > GPDat%(33) THEN EXIT SUB

    GPDat%(34) = FontNumber%   'Change the current font to FontNumber%
    GPDat%(36) = GPDat%(48) + FontHeight%(GPDat%(34))
    GPDat%(35) = FontWidth%(56, GPDat%(34))

END SUB

'This sub-program sets the character spacing
'
SUB SetSpacing (SpacingH%, SpacingV%) STATIC

    GPDat%(47) = SpacingH%           'Character Spacing
    GPDat%(48) = SpacingV%
    GPDat%(36) = GPDat%(48) + FontHeight%(GPDat%(34))

END SUB

SUB Standby STATIC

    LINE (0, 0)-(GPDat%(43) - 1, GPDat%(44) - 1), GPDat%(57), BF
    P$ = "Calculating some sample data  .  .  .   "
    IF GPDat%(31) = 4 OR GPDat%(31) = 9 THEN
       Xa = 1
       Ya = 1
    ELSE
       Xa = GPDat%(43) - GetTextWidth%(P$)
       Ya = GPDat%(44) - (FontHeight%(GPDat%(34)) + GPDat%(48) + 1)
    END IF
    CALL DrawText(Xa, Ya, P$, 0, GPDat%(56), 1#)

END SUB

