'***** PCXLOAD.BAS - This file demostrates loading a file that uses the .PCX
'                    file format used in PC Paintbrush

'Copyright (c) 1988 Crescent Software and Brian C. Giedt

'These DECLARE statements are for QB4.0
'These routines are located in PCX.QLB

DECLARE SUB BankSW2 (Plane%)
DECLARE SUB SendScreen (Z&, This%, Count%)
DECLARE SUB SendByte (Z&, This%)

DEFINT A-Z
SUB PCXLoadFile (FileName$) STATIC

  CALL GPMonType(GPMonitor%, GPMemory%) 'Find out if we can load an EGA screen
  IF GPMonitor% <> 5 AND GPMonitor% <> 8 THEN EXIT SUB

  FileNum = FREEFILE                                    'use next available #
  OPEN FileName$ FOR RANDOM AS #FileNum LEN = 128       'Open file
  FIELD #FileNum, 128 AS FileIn$

  GET #FileNum                                          'Get header
  Buffer$ = FileIn$                                     'information

  IF MID$(Buffer$, 3, 1) <> CHR$(1) GOTO ExitSub        'Different Encoding

  XMin = CVI(MID$(Buffer$, 5, 2))                       'Image size
  YMin = CVI(MID$(Buffer$, 7, 2))
  XMax = CVI(MID$(Buffer$, 9, 2))
  YMax = CVI(MID$(Buffer$, 11, 2))
  IF XMin > 0 OR YMin > 0 GOTO ExitSub                  'Only can handle full
							'screen images
  XSize = CVI(MID$(Buffer$, 13, 2))                     'Video Size
  YSize = CVI(MID$(Buffer$, 15, 2))

  GPGot% = 5                                            'Check to see if
  IF XSize = 320 THEN                                   'screen was taken
      GPGot% = 4                                        'from an EGA or VGA
  ELSEIF YSize = 200 THEN
      GPGot% = 6
  END IF
  IF XSize = 720 THEN GPGot% = 2
  IF YSize = 480 THEN GPGot% = 8
  IF GPGot% <> 5 AND GPGot% <> 8 GOTO ExitSub
  
  'pallete info starts at 17

  NumPlanes = ASC(MID$(Buffer$, 66, 1))                 'Number of video planes
  X2 = CVI(MID$(Buffer$, 67, 2))                        'Bytes / Line

  X = 0                                                 'Screen start position
  Y = 0
  Plane = 1                                             'First plane
  CALL BankSW2(Plane)                                   'Tell monitor plane #
  Z& = 0                                                'Screen offset
  Buffer$ = Buffer$ + " "                               'Make Buffer$ 129 bytes
  WHILE NOT EOF(FileNum)

      GET #FileNum                                      'Get a buffer of
      MID$(Buffer$, 2, 128) = FileIn$                   'encoded data
      J = 1                                             'Point to element 1

      WHILE J < 129
	  This = ASC(MID$(Buffer$, J + 1, 1))             'Get a byte
	  IF This > 191 THEN                            'If packed then
	      Count = This - 192                        ' get count
	      IF J = 128 THEN                           'At this point we may
		  GET #FileNum                          'need another buffer
		  MID$(Buffer$, 2, 128) = FileIn$       'of data
		  J = 0
	      END IF
	      This = ASC(MID$(Buffer$, J + 2, 1))       'Get packed byte
	      IF Count > X2 - X THEN
		 MID$(Buffer$, J + 1, 1) = CHR$(192 + Count - X2 + X)
		 J = J - 2
		 Count = X2 - X
	      END IF
	      CALL SendScreen(Z&, Count, This)           'Send to video
	      'The assembly code handles repetitions for a fast video send
	      J = J + 2                                 'Increment pointers
	      Z& = Z& + Count
	      X = X + Count
	  ELSE
	      CALL SendByte(Z&, This) 'Bytes             'Just one byte to send
	      J = J + 1                                 'Increment counters
	      Z& = Z& + 1
	      X = X + 1
	  END IF

	  IF X >= X2 THEN                               'End of a line
	      X = 0
	      Plane = (Plane * 2)                       'Increment plane counter
	      IF Plane = 2 ^ NumPlanes THEN Plane = 1   'Have we done 4 planes?
	      CALL BankSW2(Plane)                       'Tell Video which plane
	      IF Plane = 1 THEN                         'If done 4 planes
		  Y = Y + 1                             'then setup for next line
	      END IF
	      Z& = CLNG(Y) * 80 + X                     'video offset
	      IF Y >= YSize GOTO ExitSub                'if we're done, exit
	  END IF
      WEND          ' (j < 128)  If finished this loop then get another buffer

  WEND              'Not Eof(FileNum)  If finished this loop then end of file

ExitSub:
  CLOSE #FileNum    'Close the file

END SUB

