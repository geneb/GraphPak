'********** DemoText.Bas - displays text-based bar charts - doesn't need CGA

'Copyright (c) 1988 Brian Giedt
'Copyright (c) 1988 Crescent Software

DEFINT A-Z

DECLARE SUB GPPause ()
DECLARE SUB TextAxis (XCenter, YCenter, XTitle$(), YTitle$(), Wide, Height)
DECLARE SUB TextTitle (Title$, Colr)
DECLARE SUB TextGraph1 (GraphData!(), XTitle$(), YTitle$(), MainTitle$)
DECLARE SUB TextGraph2 (GraphData!(), XTitle$(), YTitle$(), MainTitle$)


'Declare some Data points and define titles

DSize = 5
REDIM GraphData!(DSize, 3), XTitle$(DSize + 1), YTitle$(4)
FOR T = 1 TO DSize
    FOR S = 1 TO 3
        GraphData!(T, S) = RND * 100 + 1
    NEXT
NEXT

FOR T = 1 TO DSize + 1
    READ XTitle$(T)
NEXT
DATA SALES, First Quarter, Second Quarter, Third Quarter, Fourth Quarter, Fifth Quarter

FOR T = 1 TO 4
    READ YTitle$(T)
NEXT
DATA YEARS, 1986, 1987, 1988

MainTitle$ = "Sales_Report_1986-1988"

CLS

'show the horizontal bar graph
CALL TextGraph1(GraphData!(), XTitle$(), YTitle$(), MainTitle$)

GPPause

'show the vertical bar graph
CALL TextGraph2(GraphData!(), XTitle$(), YTitle$(), MainTitle$)
GPPause
END

SUB GPPause STATIC

    WHILE INKEY$ <> "": WEND
    LOCATE 25, 62
    PRINT "Press a key . .";
    WHILE INKEY$ = "": WEND
    CLS

END SUB

