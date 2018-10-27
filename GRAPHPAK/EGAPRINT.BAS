
'********** EGAPrint.Bas - prints EGA graphics on an HP LaserJet printer
'
'Copyright (c) 1988 Ethan Winer
'
'
SUB EGAPrint STATIC

    NumLines = 350                      'the number of lines on an EGA

    REDIM Plane1%(NumLines * 40)        'each plane holds one color
    REDIM Plane2%(NumLines * 40)
    REDIM Plane3%(NumLines * 40)

    Init$ = CHR$(27) + "E" + CHR$(27) + "*t75R" + CHR$(27) + "*r1A"                                       'initialize graphics

    Begin$ = CHR$(27) + "*b80W"         'HP beginning-of-data sequence
    Done$ = CHR$(27) + "*rB"            'end-of-data code

    DEF SEG = &HA000                    'EGA memory segment
    OUT &H3CE, 4: OUT &H3CF, 0          'activate the blue color memory plane
    BSAVE "Plane1.$", 0, NumLines * 80  'save the screen data
    OUT &H3CE, 4: OUT &H3CF, 1          'green
    BSAVE "Plane2.$", 0, NumLines * 80
    OUT &H3CE, 4: OUT &H3CF, 2          'red
    BSAVE "Plane3.$", 0, NumLines * 80
    OUT &H3CE, 4: OUT &H3CF, 0          'back to normal
    DEF SEG

    '----- load data into three arrays and combine all the colors
    '
    DEF SEG = VARSEG(Plane1%(0))
    BLOAD "Plane1.$", VARPTR(Plane1%(0))
    DEF SEG = VARSEG(Plane2%(0))
    BLOAD "Plane2.$", VARPTR(Plane2%(0))
    DEF SEG = VARSEG(Plane3%(0))
    BLOAD "Plane3.$", VARPTR(Plane3%(0))
    KILL "Plane?.$"                     'nuke the temporary files

    FOR X = 1 TO NumLines * 40          'create single composite of all colors
        Plane1%(X) = Plane1%(X) OR Plane2%(X) OR Plane3%(X)
    NEXT

    DEF SEG = VARSEG(Plane1%(0))
    BSAVE "FullScrn.", VARPTR(Plane1%(0)), NumLines * 80'save the whole mess
    ERASE Plane1%, Plane2%, Plane3%                     'free up the memory

    REDIM EGAData(1 TO NumLines) AS STRING * 80         'where we'll load it
    DEF SEG = VARSEG(EGAData$(1))
    BLOAD "FullScrn.", VARPTR(EGAData$(1))              'load it

    OPEN "FullScrn" FOR RANDOM AS #99 LEN = 86          'create download file
    FIELD #99, 6 AS Start$, 80 AS Dat$
    LSET Start$ = Begin$                                'begin data command

    FOR X = 1 TO NumLines                               'assign each line
        LSET Dat$ = EGAData$(X)                         'put it in the file
        PUT #99
    NEXT
    CLOSE #99

    ERASE EGAData$                              'free up the memory
    LPRINT Init$                                'send the initializing code
    SHELL "Copy FullScrn/B LPT1: > Nul:"        'download the data file
    LPRINT Done$                                'tell HP we're all done

    KILL "FullScrn"                             'kill the download file

END SUB

