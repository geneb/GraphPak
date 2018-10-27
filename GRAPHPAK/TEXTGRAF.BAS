'********** TextGraf.Bas

'Copyright (c) 1988 Brian Giedt
'Copyright (c) 1988 Crescent Software


DEFINT A-Z

DECLARE SUB TextAxis (XCenter, YCenter, XTitle$(), YTitle$(), Wide, Height)
DECLARE SUB TextTitle (Title$, Colr)

SUB TextAxis (XCenter, YCenter, XTitle$(), YTitle$(), Wide, Height) STATIC

    Wide = 60
    Height = 19

    YCenter = 11 + Height \ 2
    XCenter = 40 - Wide \ 2

    LOCATE (YCenter - Height), XCenter
    PRINT "Ú"; STRING$(Wide - 2, "Ä"); "¿"

    FOR T = 1 TO Height - 2
	LOCATE , XCenter
	PRINT "³"; SPC(Wide - 2); "³"
    NEXT
    LOCATE YCenter - 1, XCenter: PRINT "À"; STRING$(Wide - 2, "Ä"); "Ù"

    XBound = UBOUND(XTitle$)

    LOCATE YCenter + 1, 40 - LEN(XTitle$(1))
    COLOR 7
    PRINT XTitle$(1);
    FOR T = 2 TO XBound
	Vert = YCenter + 1 + T \ 2
	IF Vert <= 25 THEN
	   LOCATE Vert, XCenter + (Wide \ 2) * (T MOD 2) + 5
	   COLOR (T - 1)
	   PRINT CHR$(219); SPC(1);
	   COLOR 7
	   PRINT XTitle$(T);
	END IF
    NEXT

END SUB

SUB TextGraph1 (GraphData!(), XTitle$(), YTitle$(), MainTitle$) STATIC

    CALL TextAxis(XCenter, YCenter, XTitle$(), YTitle$(), Wide, Height)
    CALL TextTitle(MainTitle$, 2)

    XBound = UBOUND(GraphData!, 1)
    YBound = UBOUND(GraphData!, 2)

    TotalBars = XBound * YBound
    IF TotalBars + YBound >= Height THEN EXIT SUB

    BarWidth = Height \ (TotalBars + YBound)
    InnerBar = ((Height - TotalBars * BarWidth) \ YBound)
    GroupWidth = XBound * BarWidth + InnerBar

    LOCATE YCenter - (Height + LEN(YTitle$(1))) \ 2, XCenter - 4
    FOR T = 1 TO LEN(YTitle$(1))
	PRINT MID$(YTitle$(1), T, 1);
	LOCATE CSRLIN + 1, XCenter - 4
    NEXT

    FOR S1 = 0 TO YBound - 1            'show title of bar groups

	COLOR 7
	LOCATE YCenter - (((S1 + 1) * (XBound + 1) + 1) * BarWidth - 1), XCenter - 2

	'If its too long cut off the end of the title
	YLength = LEN(YTitle$(S1 + 2))
	IF YLength >= GroupWidth THEN YLength = GroupWidth - 1
	FOR T = 1 TO YLength
	    PRINT MID$(YTitle$(S1 + 2), T, 1);
	    LOCATE CSRLIN + 1, XCenter - 2
	NEXT

	FOR S2 = 1 TO XBound            'plot individual bars
	    FOR I = 1 TO BarWidth
		LOCATE YCenter - ((S1 * (XBound + 1) + S2) * BarWidth + I), XCenter + 1
		PlotValue! = GraphData!(S2, S1 + 1) / 100 * (Wide - 2)
		COLOR S2
		FOR T = 1 TO INT(PlotValue!)
		    PRINT CHR$(219);
		NEXT
		IF PlotValue! - INT(PlotValue!) > .5 THEN PRINT CHR$(221);
	    NEXT
	NEXT
    NEXT
    COLOR 7

END SUB

SUB TextGraph2 (GraphData!(), XTitle$(), YTitle$(), MainTitle$) STATIC

    CALL TextAxis(XCenter, YCenter, XTitle$(), YTitle$(), Wide, Height)
    CALL TextTitle(MainTitle$, 2)

    XBound = UBOUND(GraphData!, 1)
    YBound = UBOUND(GraphData!, 2)

    TotalBars = XBound * YBound
    IF TotalBars + YBound >= Wide THEN EXIT SUB

    BarWidth = Wide \ (TotalBars + YBound)
    InnerBar = ((Wide - TotalBars * BarWidth) \ YBound)
    GroupWidth = XBound * BarWidth + InnerBar

    LOCATE YCenter, 1
    PRINT YTitle$(1);

    FOR S1 = 0 TO YBound - 1
	'show title of bar groups
	COLOR 7
	LOCATE YCenter, XCenter + (S1 * GroupWidth)

	'If Title is too long then cut off end
	YLength = LEN(YTitle$(S1 + 2))
	IF YLength >= GroupWidth - InnerBar THEN YLength = GroupWidth - InnerBar - 1

	'If We can lets center the title
	IF YLength < GroupWidth - InnerBar THEN PRINT STRING$((GroupWidth - YLength - InnerBar) \ 2, " ");
	PRINT LEFT$(YTitle$(S1 + 2), YLength);

	FOR S2 = 1 TO XBound            'plot individual bars
	    FOR I = 1 TO BarWidth
		LOCATE YCenter - 2, XCenter + S1 * GroupWidth + S2 * BarWidth + I - BarWidth
		PlotValue! = GraphData!(S2, S1 + 1) * (Height - 2) * .01
		COLOR S2
		FOR T = 1 TO INT(PlotValue!)
		    PRINT CHR$(219);
		    LOCATE CSRLIN - 1, POS(0) - 1
		NEXT
		IF PlotValue! - INT(PlotValue!) > .5 THEN PRINT CHR$(220);
	    NEXT
	NEXT
    NEXT
    COLOR 7

END SUB

SUB TextTitle (Title$, Colr) STATIC

    T = 0
    T$ = Title$
    COLOR Colr
    WHILE LEN(T$)
	L = INSTR(T$, "_")      'search for underscore "new-line" character
	IF L THEN
	    S$ = LEFT$(T$, L - 1)
	    T$ = MID$(T$, L + 1)
	ELSE
	    S$ = T$
	    T$ = ""
	END IF
	S = 74 - LEN(S$) \ 2
	T = T + 1
	LOCATE T, S
	PRINT S$;
    WEND
    COLOR 7

END SUB

