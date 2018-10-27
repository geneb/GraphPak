'***** PCXSAVE.BAS - This file demostrates saveing a file using the .PCX
'                    file format used in PC Paintbrush

'Copyright (c), 1988 Crescent Software and Brian C. Giedt


'These DECLARE statements are for QB4.0
'These are located in PCX.QLB

DECLARE SUB BankSW1 (Plane%)
DECLARE SUB GetByteEGA (This%, Location&)
DECLARE SUB WhichScreen (Mode%)

'These are in .BAS files
DECLARE SUB ScreenUsed (Mode%, Cols%, Rows%, NumPlanes%)

DEFINT A-Z
SUB PCXSaveFile (FileName$) STATIC

  AllDone = 0
  CALL ScreenUsed(Mode, Cols, Rows, NumPlanes)    'Ask BIOS what screen in
  IF Mode = 0 THEN EXIT SUB
  X1 = 0                                          'Screen coordinates for
  Y1 = 0                                          'screen capture
  X2 = Cols - 1
  Y2 = Rows - 1

  FileNum = FREEFILE
  OPEN FileName$ FOR RANDOM AS #FileNum LEN = 128       'Open the file
  FIELD #FileNum, 128 AS FileOut$

  Pallet$ = STRING$(48, 0)   '16 sets(one for each pallete) of 3 bytes of info   
                             'each representing the intensity of the RGB value
                             'ranging from 0 to 255
                             'Unless the "3" below is changed to a "5" the
                             'pallete information is ingnored.

  Buffer$ = CHR$(10) + CHR$(3) + CHR$(1) + CHR$(1) + MKI$(X1) + MKI$(Y1) + MKI$(X2) + MKI$(Y2) + MKI$(Cols) + MKI$(Rows)
  Buffer$ = Buffer$ + Pallet$ + CHR$(0) + CHR$(NumPlanes) + MKI$(Cols \ 8) + STRING$(60, 0)

  LSET FileOut$ = Buffer$                  'Store Header Information in file
  PUT #FileNum
  Buffer$ = SPACE$(131)                    'Clear Buffer for data
  Pointer = 1
  T1 = Y1                                  'Initialize screen pointers
  S3 = 0
  S2 = X2 \ 8
  S1 = 0
  T2& = T1 * 80
  Plane = 0                                'Start with the First Color Plane
  CALL BankSW1(Plane)                      'Tell the EGA\VGA which plane
  CALL GetByteEGA(Last, CLNG(S1 + T2&))           'Get the first byte off the screen
  Count = 1                                'It's the first occurance of data
  S1 = S1 + 1                              'Move pointer to next screen byte

'***************************************************************
'END OF INITIALIZATION CODE
'***************************************************************

DO  'until we're all done
  DO  'until we've got a 128 byte buffer filled or we're all done

'get a byte
    CALL GetByteEGA(This, CLNG(S1 + T2&))         'Get another byte

'check if byte can be compressed some more
    IF (This <> Last) OR (Count > 62) THEN 'Compare it with the last byte
      IF Count > 1 THEN                    'Can't compress so store byte
        MID$(Buffer$, Pointer, 1) = CHR$(192 + Count)
        Pointer = Pointer + 1
        Count = 1
      ELSEIF Last > 191 THEN               'Byte is > 191 so must store
        MID$(Buffer$, Pointer, 1) = CHR$(193)
        Pointer = Pointer + 1              'as count = 1
      END IF
      MID$(Buffer$, Pointer, 1) = CHR$(Last)
      Pointer = Pointer + 1
      Last = This
    ELSE
      Count = Count + 1                    'YES - it can compress more
    END IF

    S1 = S1 + 1                            'increment x position counter
    IF S1 > S2 THEN                        'is end of line?
      IF Count > 1 THEN                    'Send the last byte to the buffer
        MID$(Buffer$, Pointer, 1) = CHR$(192 + Count)
        Pointer = Pointer + 1
        Count = 1
      ELSEIF Last > 191 THEN
        MID$(Buffer$, Pointer, 1) = CHR$(193)
        Pointer = Pointer + 1
      END IF
      MID$(Buffer$, Pointer, 1) = CHR$(Last)
      Pointer = Pointer + 1

      Plane = (Plane + 1) MOD NumPlanes    'switch planes if posible
      CALL BankSW1(Plane)
      S1 = 0
      IF Plane = 0 THEN                    'If we've done all four planes
        T1 = T1 + 1                        'then move down one line
        T2& = T2& + 80
        IF T1 > Y2 THEN AllDone = -1
      END IF

      CALL GetByteEGA(This, CLNG(S1 + T2&))       'get first byte of next line
      Last = This: Count = 1: S1 = S1 + 1
    END IF

  LOOP UNTIL (Pointer > 128) OR AllDone    'If the 128 byte buffer is full
  LSET FileOut$ = LEFT$(Buffer$, 128)      'then put it into the file
  PUT #FileNum
  IF Pointer > 129 THEN                    'If there was any left over then
                                           'keep it for later
    Buffer$ = MID$(Buffer$, 129, Pointer - 128) + SPACE$(260 - Pointer)
  ELSE
    Buffer$ = SPACE$(131)
  END IF
  Pointer = Pointer - 128
LOOP UNTIL AllDone

CLOSE #FileNum                             'File is all done

END SUB

SUB ScreenUsed (Mode, Cols, Rows, NumPlanes) STATIC

    CALL WhichScreen(Mode)

    IF Mode < 15 THEN
         Mode = 0
         EXIT SUB
    END IF

    NumPlanes = 4
    Cols = 640
    Rows = 350
    IF Mode = 18 THEN Rows = 480

END SUB

