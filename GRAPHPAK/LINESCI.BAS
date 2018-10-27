'********** LineSci.Bas - displays a complete 2-D line chart

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software

DEFINT A-Z

'These DECLARE statements are for QuickBASIC 4.0 - see DEMOGPAK.BAS

DECLARE FUNCTION GetTextWidth% (Text$)
DECLARE FUNCTION MakeBinary% (Bin$)
DECLARE FUNCTION FUsing$ (Number$, Image$)
DECLARE FUNCTION CleanNumber! (TheNumber!, Precision%, AddUp%)
DECLARE SUB LineLegend (YTitle$(), YBound%, GP.LTile%(), Colors%())
DECLARE SUB DrawText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)
DECLARE SUB StepText (Xx%, Yy%, Text$, Angle%, Colr%, TextSize#)
DECLARE SUB PrecisionStr (S$, S1!, Prec1%, Prec2%)
DECLARE SUB DrawBackSci (XTitle$(), YTitle$())
DECLARE SUB PlotLineSci (X!, Y!, Colr%, Style%, Options%)
DECLARE SUB DisplayTitle (Title$)

'$INCLUDE: 'Common'

DEF FNLog10! (InNum!)
   IF InNum! > 0 THEN
     FNLog10! = ABS(LOG(InNum!) / LOG(10))
   ELSE
     FNLog10! = 0
   END IF
END DEF

FUNCTION CleanNumber! (TheNumber!, Precision%, AddUp%) STATIC

   A! = TheNumber! * (10 ^ (Precision)) + (AddUp% * .5)
   A! = A! - (A! - INT(A!))
   A! = A! * (10 ^ (-Precision))
   CleanNumber! = A!

END FUNCTION

SUB LineSci (SciData!(), XTitle$(), YTitle$(), MainTitle$, TypeOfGraph, LineType, PointType, Colors%()) STATIC

    PrecWanted = 4
    Options = LineType + 1 + PointType * 16

    'Upper boundary's of the data
    XBound = UBOUND(SciData!, 1)
    YBound = UBOUND(SciData!, 2)
    IF GPDat%(19) > 0 THEN XBound = GPDat%(19)
    IF GPDat%(20) > 0 THEN YBound = GPDat%(20)
    GPDat%(45) = XBound
    GPDat%(46) = YBound

    'Draw the backdrop
    CALL DrawBackSci(XTitle$(), YTitle$())
    'Display graph title
    CALL DisplayTitle(MainTitle$)

    '$INCLUDE: 'LineTile'

    'obtain ranges from the GPDat%() array
    MaxX! = GPDat%(5)
    LowX! = GPDat%(6)

    MaxY! = GPDat%(51)
    LowY! = GPDat%(52)

    'obtain the largest values from the array
    HighX! = SciData!(1, 1, 1)
    HighY! = SciData!(1, 1, 2)
    LowestX! = SciData!(1, 1, 1)
    LowestY! = SciData!(1, 1, 2)
    FOR S1 = 1 TO YBound
	FOR S2 = 1 TO XBound
	    IF SciData!(S2, S1, 1) > HighX! THEN HighX! = SciData!(S2, S1, 1)
	    IF SciData!(S2, S1, 1) < LowestX! THEN LowestX! = SciData!(S2, S1, 1)
	    IF SciData!(S2, S1, 2) > HighY! THEN HighY! = SciData!(S2, S1, 2)
	    IF SciData!(S2, S1, 2) < LowestY! THEN LowestY! = SciData!(S2, S1, 2)
	NEXT
    NEXT

    'Check to make sure all data will be within bounds
    IF MaxX! >= LowX! THEN
	IF HighX! > MaxX! THEN MaxX! = HighX!
	IF LowestX! < LowX! THEN LowX! = LowestX!
    ELSE
	IF HighX! > LowX! THEN LowX! = HighX!
	IF LowestX! < MaxX! THEN MaxX! = LowestX!
    END IF
    IF MaxY! >= LowY! THEN
	IF HighY! > MaxY! THEN MaxY! = HighY!
	IF LowestY! < LowY! THEN LowY! = LowestY!
    ELSE
	IF HighY! > LowY! THEN LowY! = HighY!
	IF LowestY! < MaxY! THEN MaxY! = LowestY!
    END IF
   
 'There are two methods for determining the increments on the axis.
 'The first method is the standard method which simply allows the increment
 'to end up as whatever it may.  The second method increase the range of
 'the graphing region so that the increments are integers.
 'Method 1:
    DiffX! = MaxX! - LowX!
    IncX! = (INT((DiffX! / GPDat%(7)) * 1000 + .999)) / 1000
    DiffY! = MaxY! - LowY!
    IncY! = (INT((DiffY! / GPDat%(53)) * 100 + .999)) / 100
 'Method 2:
    'DO
    '  DiffX! = MaxX! - LowX!
    '  IncX! = (INT((DiffX! / GPDat%(7)) * 1000 + .999)) / 1000
    '  IF (IncX! <> INT(IncX!)) THEN MaxX! = MaxX! + 1
    'LOOP WHILE (IncX! <> INT(IncX!))
    'DO
    '  DiffY! = MaxY! - LowY!
    '  IncY! = (INT((DiffY! / GPDat%(53)) * 100 + .999)) / 100
    '  IF (IncY! <> INT(IncY!)) THEN MaxY! = MaxY! + 1
    'LOOP WHILE (IncY! <> INT(IncY!))

    'XPrec1 is the Precision in front of the decimal place
    'XPrec2 is the Precision after the decimal place

    A$ = STR$(INT(MaxX!))
    XPrec1 = LEN(A$) - 1
    A$ = STR$(INT(LowX!))
    IF LEN(A$) - 1 > XPrec1 THEN XPrec1 = LEN(A$) - 1
    A$ = STR$(IncX! - INT(IncX!))
    IF LEN(A$) - 2 > 0 THEN XPrec2 = PrecWanted - XPrec1


    A$ = STR$(INT(MaxY!))
    YPrec1 = LEN(A$) - 1
    A$ = STR$(INT(LowY!))
    IF LEN(A$) - 1 > YPrec1 THEN YPrec1 = LEN(A$) - 1
    A$ = STR$(IncY! - INT(IncY!))
    IF LEN(A$) - 2 > 0 THEN YPrec2 = PrecWanted - YPrec1

    IF TypeOfGraph = 3 OR TypeOfGraph = 2 THEN
	 IF LowX! < 0 OR MaxX! < 0 THEN
	     BEEP
	     EXIT SUB
	 END IF
    END IF
    IF TypeOfGraph = 2 OR TypeOfGraph = 1 THEN
	 IF LowY! < 0 OR MaxY! < 0 THEN
	     BEEP
	     EXIT SUB
	 END IF
    END IF
   
'=============================================================
'Show graph markings

    NSize# = 1         'new text size is 1.0

    '******************************** Side Markings
    LowestY! = CleanNumber!(LowestY!, 2, 0)
    IF MaxY! > 0 THEN MaxYLog10! = FNLog10!(MaxY!) ELSE MaxYLog10! = 0
    IF LowestY! >= 1! THEN LowestY! = INT(LowestY!)
    IF LowY! > 0 AND LowestY! > 0 THEN BottomYLog10! = FNLog10!(LowestY!) ELSE BottomYLog10! = 0
    MaxYLog10! = MaxYLog10! - BottomYLog10!
    IF MaxYLog10! <> 0 THEN
       FactorY = ABS(GPDat%(40) / MaxYLog10!)
    ELSE
       FactorY = 0
    END IF

    IF GPDat%(1) THEN
    IF TypeOfGraph = 1 OR TypeOfGraph = 2 THEN
    'side numbers are to be on a logarithmic scale
	IF LowY! > 0 THEN
	  S4! = LowestY!
	  T = LEN(STR$(S4!))
	  WHILE MID$(STR$(S4!), T, 1) = "0"
	    T = T - 1
	  WEND
	  S5 = VAL(MID$(STR$(S4!), T, 1))
	ELSE
	  S4! = 1!   'counts up the numbers to be displayed in integer fashion
	  S5 = 1
	END IF
	LS = -4
	WHILE (S4! / (10 ^ (LS))) >= 1
	  LS = LS + 1
	WEND
	S3! = 10 ^ (LS - 1)
	OrigYPrec = LS - 1
	'in logarithmic scaling numbers go from   1 to   10 at a step of   1
				'     then from  10 to  100 at a step of  10
				'     then from 100 to 1000 at a step of 100
	'and so on.  At the end of a loop the incrementer (S3) is multiplied
	'  by 10 and the counting continues
	WHILE S4! + S3! < MaxY!
	    WHILE (S5 <= 10) AND (S4! <= MaxY!)
		S$ = MID$(STR$(CleanNumber!(S4!, OrigYPrec, 0)), 2)
		LS = ABS(FNLog10!(S4!) - BottomYLog10!) * FactorY
		LINE (GPDat%(37) - 15, GPDat%(38) - LS)-(GPDat%(37), GPDat%(38) - LS), GPDat%(56)
		LINE (GPDat%(37) + 1, GPDat%(38) - LS)-(GPDat%(37) + GPDat%(39) - 1, GPDat%(38) - LS), GPDat%(56), , GPDat%(61)
		'Don't draw labels if not enough space exists
		IF ABS(FNLog10!(S4! + S3!) - FNLog10!(S4!)) * FactorY > GPDat%(36) THEN
		    T1 = GPDat%(37) - 20 - GetTextWidth%(S$)
		    CALL DrawText(T1, GPDat%(38) - LS - GPDat%(36) \ 2, S$, 0, GPDat%(56), NSize#)
		END IF
		S4! = S4! + S3!
		S5 = S5 + 1
	    WEND
	    S4! = S4! - S3!
	    S5 = 1
	    LS = ABS(FNLog10!(S4!) - BottomYLog10!) * FactorY
	    'in some cases this may be a redraw but it is necessary to draw
	    '  the last number of a loop even if not enough space exists
	    LINE (GPDat%(37) - 15, GPDat%(38) - LS)-(GPDat%(37), GPDat%(38) - LS), GPDat%(56)
	    LINE (GPDat%(37) + 1, GPDat%(38) - LS)-(GPDat%(37) + GPDat%(39) - 1, GPDat%(38) - LS), GPDat%(56), , GPDat%(61)
	    CALL DrawText(GPDat%(37) - 20 - GetTextWidth%(S$), GPDat%(38) - LS - GPDat%(36) \ 2, S$, 0, GPDat%(56), NSize#)
	    S3! = S3! * 10
	WEND
     ELSE    'draw a normal Y axis
	S2! = LowY!
	S4 = -1 * GPDat%(40)
	FOR S1! = 0 TO GPDat%(40) + 1 STEP GPDat%(40) / GPDat%(53)
	    LINE (GPDat%(37) - 15, GPDat%(38) - S1!)-(GPDat%(37), GPDat%(38) - S1!), GPDat%(56)
	    LINE (GPDat%(37) + 1, GPDat%(38) - S1!)-(GPDat%(37) + GPDat%(39) - 1, GPDat%(38) - S1!), GPDat%(56), , GPDat%(61)
	    CALL PrecisionStr(S$, S2!, YPrec1, YPrec2)
	    S$ = STRING$(7 - LEN(S$), " ") + S$
	    IF S1! - S4 > GPDat%(36) THEN
		CALL DrawText(GPDat%(37) - 20 - GetTextWidth%(S$), GPDat%(38) - S1! - GPDat%(36) \ 2, S$, 0, GPDat%(56), NSize#)
		S4 = S1!
	    END IF
	    S2! = S2! + IncY!
	NEXT
	IF GPDat%(54) THEN
	    IF (LowY! < 0 AND MaxY! > 0) OR (LowY! > 0 AND MaxY! < 0) THEN
		YValue! = GPDat%(40) * (-1 * LowY!) / DiffY!
		LINE (GPDat%(37), GPDat%(38) - YValue!)-(GPDat%(37) + GPDat%(39), GPDat%(38) - YValue!), GPDat%(55)
	    END IF
	END IF
    END IF
    END IF

    'if enough titles exist then display their names below
    CALL LineLegend(YTitle$(), YBound, GPLTile(), Colors%())

    'Under Markings
    'SEE SECTION FOR SIDE MARKINGS FOR AN EXPLANATION OF LOGARITHMIC SCALING

    LowestX! = CleanNumber!(LowestX!, 2, 0)
    IF MaxX! > 0 THEN MaxXLog10! = FNLog10!(MaxX!) ELSE MaxXLog10! = 0
    IF LowestX! >= 1! THEN LowestX! = INT(LowestX!)
    IF LowX! > 0 THEN BottomXLog10! = FNLog10!(LowestX!) ELSE BottomXLog10! = 0
    MaxXLog10! = MaxXLog10! - BottomXLog10!
    IF MaxXLog10! <> 0 THEN
       FactorX = ABS(GPDat%(39) / MaxXLog10!)
    ELSE
       FactorX = 0
    END IF

    IF GPDat%(1) THEN
    IF TypeOfGraph = 2 OR TypeOfGraph = 3 THEN
    'draw a logaritmic scale on the X-axis
	IF LowX! > 0 THEN
	  S4! = LowestX!
	  T = LEN(STR$(S4!))
	  WHILE MID$(STR$(S4!), T, 1) = "0"
	    T = T - 1
	  WEND
	  S5 = VAL(MID$(STR$(S4!), T, 1))
	ELSE
	  S4! = 1
	  S5 = 1
	END IF
	LS = -4
	WHILE (S4! / (10 ^ (LS))) >= 1
	  LS = LS + 1
	WEND
	S3! = 10 ^ (LS - 1)
	OrigXPrec = LS - 1
	WHILE S4! + S3! < MaxX!
	    WHILE (S5 <= 10) AND (S4! <= MaxX!)
		S$ = MID$(STR$(CleanNumber!(S4!, OrigXPrec, 0)), 2)
		LS = ABS(FNLog10!(S4!) - BottomXLog10!) * FactorX
		LINE (GPDat%(37) + LS, GPDat%(38))-(GPDat%(37) + LS, GPDat%(38) + 15), GPDat%(56)
		LINE (GPDat%(37) + LS, GPDat%(38) - 1)-(GPDat%(37) + LS, GPDat%(38) - GPDat%(40) + 1), GPDat%(56), , GPDat%(62)
		'don't draw labels if no GPDat%(35) is allowed
		IF ABS(FNLog10!(S4! + S3!) - FNLog10!(S4!)) * FactorX > GPDat%(35) THEN
		   CALL StepText(GPDat%(37) + LS - GPDat%(36) \ 2, GPDat%(38) + 20, S$, -90, GPDat%(56), NSize#)
		END IF
		S4! = S4! + S3!
		S5 = S5 + 1
	    WEND
	    S4! = S4! - S3!
	    S5 = 1
	    LS = ABS(FNLog10!(S4!) - BottomXLog10!) * FactorX
	    LINE (GPDat%(37) + LS, GPDat%(38))-(GPDat%(37) + LS, GPDat%(38) + 15), GPDat%(56)
	    LINE (GPDat%(37) + LS, GPDat%(38) - 1)-(GPDat%(37) + LS, GPDat%(38) - GPDat%(40) + 1), GPDat%(56), , GPDat%(62)
	    CALL StepText(GPDat%(37) + LS - GPDat%(36) \ 2, GPDat%(38) + 20, S$, -90, GPDat%(56), NSize#)
	    S3! = S3! * 10
	WEND
    ELSE 'draw a normal X-axis (this section is used also for Semi-log graphs)

	S2! = LowX!
	FOR S1! = 0 TO GPDat%(39) + 1 STEP GPDat%(39) / GPDat%(7)
	    LINE (GPDat%(37) + S1!, GPDat%(38))-(GPDat%(37) + S1!, GPDat%(38) + 15), GPDat%(56)
	    LINE (GPDat%(37) + S1!, GPDat%(38) - 1)-(GPDat%(37) + S1!, GPDat%(38) - GPDat%(40) + 1), GPDat%(56), , GPDat%(62)
	    CALL PrecisionStr(S$, S2!, XPrec1, XPrec2)
	    'Sa$ = STR$(CleanNumber!(S2!, 2, 0))
	    IF GPDat%(63) THEN
	      CALL DrawText(GPDat%(37) + S1! - GetTextWidth%(S$) / 2, GPDat%(38) + 20, S$, 0, GPDat%(56), NSize#)
	    ELSE
	      CALL StepText(GPDat%(37) + S1! - GPDat%(35), GPDat%(38) + 20, S$, -90, GPDat%(56), NSize#)
	    END IF
	    S2! = S2! + IncX!
	NEXT
	IF GPDat%(54) THEN
	    IF (LowX! < 0 AND MaxX! > 0) OR (LowX! > 0 AND MaxX! < 0) THEN
		XValue! = GPDat%(39) * (-1 * LowX!) / DiffX!
		LINE (GPDat%(37) + XValue!, GPDat%(38))-(GPDat%(37) + XValue!, GPDat%(38) - GPDat%(40)), GPDat%(55)
	    END IF
	END IF
    END IF
    END IF

'=============================================================
'Plot graph values

    T4 = 0 'Start tile at 1 (NOTE: Automatically incremented once)
    FOR S1 = 1 TO YBound
	IF Colors%((S1 - 1) MOD UBOUND(Colors) + 1) MOD 256 = Colors%(1) MOD 256 THEN T4 = T4 MOD MaxTileNum + 1
	FOR S2 = 1 TO XBound
	    'take values from data array and scale to our graph depending
	    '  upon type of graph creating
	    XValue! = SciData!(S2, S1, 1)
	    YValue! = SciData!(S2, S1, 2)
	    IF TypeOfGraph = 0 THEN                    'normal graph
		XValue! = GPDat%(39) * (XValue! - LowX!) / DiffX!
		YValue! = GPDat%(40) * (YValue! - LowY!) / DiffY!
	    ELSEIF TypeOfGraph = 1 THEN                'Semi-Log graph
		XValue! = GPDat%(39) * (XValue! - LowX!) / DiffX!
		YValue! = ABS(FNLog10!(YValue!) - BottomYLog10!) * FactorY
	    ELSEIF TypeOfGraph = 2 THEN                'Log-Log graph
		XValue! = ABS(FNLog10!(XValue!) - BottomXLog10!) * FactorX
		YValue! = ABS(FNLog10!(YValue!) - BottomYLog10!) * FactorY
	    ELSEIF TypeOfGraph = 3 THEN                'Semi-Log graph
		XValue! = ABS(FNLog10!(XValue!) - BottomXLog10!) * FactorX
		YValue! = GPDat%(40) * (YValue! - LowY!) / DiffY!
	    END IF
	    Colr = Colors%((S1 - 1) MOD UBOUND(Colors) + 1)
	    IF Colr > 255 THEN
	      PassedOptions = Colr \ 256
	      'force first dot to be drawn
	      IF S2 = 1 THEN PassedOptions = (PassedOptions \ 16) * 16 + 1
	    ELSE
	      PassedOptions = Options
	      'force first dot to be drawn
	      IF S2 = 1 THEN PassedOptions = PointType * 16 + 1
	    END IF
	    CALL PlotLineSci(XValue!, YValue!, Colr, GPLTile(T4), PassedOptions)
	NEXT
    NEXT

END SUB

SUB PrecisionStr (S$, S1!, Prec1, Prec2) STATIC

    IF Prec2 < 0 THEN Prec2 = 0   'added 3-1-1996

    T1$ = STR$(FIX(S1!))
    T2$ = STR$(INT((S1! - FIX(S1!)) * (10 ^ Prec2) + .5) / (10 ^ Prec2))
    T2$ = T2$ + STRING$(Prec2, "0")
    'Add Padding Zeros
    IF S1! - INT(S1!) < .00001 THEN T2$ = " ." + STRING$(Prec2, "0")
    T2$ = MID$(T2$, 3, Prec2)
    IF Prec2 > 0 THEN
      S$ = T1$ + "." + T2$
    ELSE
      S$ = T1$
    END IF
    IF MID$(S$, 1, 1) = " " THEN S$ = MID$(S$, 2)

END SUB

