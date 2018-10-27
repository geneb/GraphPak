'**** SetGPDat.Bas - Initialize the variables of the GPDat%() array

'Copyright (c) 1989, Brian C. Giedt


         '******* User Variables *******
GPDat%(1) = -1                       'Show Legend Text
GPDat%(2) = -1                       'Tile in the Background
GPDat%(3) = -1                       'Use Tick Marks
GPDat%(4) = -1                       'Use OutSide Border Lines
GPDat%(5) = 100                      'Graph High Value Number
GPDat%(6) = 0                        'Graph Low Value Number
GPDat%(7) = 25                       'Step Size for Tick Marks
GPDat%(8) = -1                       'Display Bars as 3d images
GPDat%(9) = 9                        'MainTitle color
GPDat%(10) = 80                       'X-Axis Angle
GPDat%(11) = 60                       'Y-Axis Angle
GPDat%(12) = -1                       'Show Main Title
GPDat%(13) = -1                       'Draw High\Low Graph using bars
GPDat%(14) = 0                        'Don't Paint Back Walls on 3D graphs
GPDat%(15) = 0                        'Left Axis Tick Marks and Values
GPDat%(16) = -1                       'Display only Non-Zero values
GPDat%(17) = 1                        'Pull out last piece of pie chart
GPDat%(18) = 0                        'Show Area Graph Lines
GPDat%(19) = 0                        'Don't Force XBoundary
GPDat%(20) = 0                        'Don't Force YBoundary
GPDat%(21) = 0                        'Normal Line Graphs
GPDat%(22) = -1                       'Shift Layered bars
GPDat%(23) = 0                        'Boldface the text
GPDat%(24) = 90                       'Angle for Italicizing the text
GPDat%(25) = 2                        'Main Title in Upper Right corner
GPDat%(26) = 0                        'FillPoly uses white borders
GPDat%(27) = 0                        'DisplayTitle textsize is normal
GPDat%(28) = 1                        'Start Plotting lines with element 1
GPDat%(29) = 30000                    'Continue Plottine lines until element 30000
'30 is un-used

         '******* System Variables *******
'31 is the current screen mode used
'32 is the amount of EGA memory available
'33 is the Maximum number of Fonts available
'34 is the current font being used
'35 has been changed to Width of ASCII "W" in specified font
'36 has been changed to Height of Specified Font + Current Height Addition
'37 is the X Center of the graph axis
'38 is the Y Center of the graph axis
'39 is the Width of the graph axis
'40 is the Height of the graph axis
'41 is the one of the bar width variables
'42 is the other bar width variable
'43 is screen's physical height
'44 is screen's physical width
'45 is a copy of XBound
'46 is a copy of YBound
GPDat%(47) = 2                        'Horizontal spacing = 2 pixels
GPDat%(48) = 2                        'Vertical spacing = 2 pixels
'49 is Screen Aspect Ration (VGA is 1000)
'50 is Maximum number of colors on screen

         '******* More User Variables *******
GPDat%(51) = 0                        'X-Axis Highest Value
GPDat%(52) = 0                        'X-Axis Lowest Value
GPDat%(53) = 0                        'X-Axis Stepsize
GPDat%(54) = -1                       'Draw X-Axis Zero Line
GPDat%(55) = 14                       'Set Color of Scientific Zeros to Yellow
GPDat%(56) = 15                       'Foreground Color
GPDat%(57) = 0                        'BackGround Color
GPDat%(58) = 2                        'Headings Color
GPDat%(59) = 0                        'Temporary Text Spacing
GPDat%(60) = 0                        'Don't fill the graph area
GPDat%(61) = 0                        'Line Tile for Horizontal axis lines
GPDat%(62) = 0                        'Line Tile for Vertical axis lines
GPDat%(63) = -1                       'LineSci X-Axis Legends Drawn Across
'64 is un-used

YHeading$ = "PERCENT"

