'********** SetVideo.Bas - Initializes the appropriate Screen mode based
'                          on the type of display adapter

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

'9/24/91: Modified SETVIDEO.BAS to fix a bug in PlotLineS.BAS where on a
'monochrome VGA display the routine would get stuck in an endless loop.
'PlotLineS is used in the Line2F and Line2S graphs.


DEFINT A-Z

'$INCLUDE: 'Common'

'This subprogram sets the proper screen mode
'
SUB SetVideo STATIC

    IF GPDat%(31) = 1 THEN                     'EGA (or VGA) w/mono monitor
       SCREEN 10                               'set Screen 10
       GPDat%(31) = 5                          'treat as a color EGA later
       GPDat(56) = 3
    ELSEIF GPDat%(31) = 2 THEN                 'Hercules monitor
       SCREEN 3, 0                             'REM out if not using QB 4.0
       GPDat%(43) = 720
       GPDat%(44) = 350
       GPDat%(50) = 2
       GPDat%(56) = 1
    ELSEIF GPDat%(31) = 3 THEN                 'plain monochrome
       CLS
       PRINT "Graphics adapter required."
       END
    ELSEIF GPDat%(31) = 4 THEN                 'CGA or EGA w/CGA emulation
       SCREEN 1, 0
       GPDat%(43) = 320
       GPDat%(44) = 200
       GPDat%(50) = 4
       GPDat%(56) = 3
       GPDat%(57) = 0
    ELSEIF GPDat%(31) = 5 THEN                 'EGA (or VGA) w/color monitor
       SCREEN 9
    ELSEIF GPDat%(31) = 6 THEN                 'CGA hi-res, no color
       SCREEN 2, 0
       GPDat%(43) = 640
       GPDat%(44) = 200
       GPDat%(50) = 2
       GPDat%(56) = 1
       GPDat%(57) = 0
    ELSEIF GPDat%(31) = 7 THEN
       SCREEN 11
       GPDat%(31) = 8
       GPDat(56) = 1
    ELSEIF GPDat%(31) = 8 THEN
       SCREEN 12
    ELSEIF GPDat%(31) = 9 THEN
       SCREEN 13
       GPDat%(43) = 320
       GPDat%(44) = 200
       GPDat%(50) = 255
    END IF
   
    IF GPDat%(31) = 5 THEN
       GPDat%(43) = 640
       GPDat%(44) = 350
       GPDat%(50) = 16
    ELSEIF GPDat%(31) = 8 THEN
       GPDat%(43) = 640
       GPDat%(44) = 480
       GPDat%(50) = 16
    END IF

    GPDat%(49) = INT((4 * (GPDat%(44) / GPDat%(43)) / 3) * 1000)

END SUB
