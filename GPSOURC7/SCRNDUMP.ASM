;************ ScrnDump.Asm

;Copyright (c) 1988 Brian Giedt
;Copyright (c) 1988 Crescent Software
;Conversion to Masm 5.1 by Jay Munro
;syntax - CALL ScrnDump(DPI$, LPTNo%, Translate%)

;Where DPI$ is "" to dump to an Epson type printer, or " 75", "150", or "300"
;to indicate the HP LaserJet DPI resolution.  Note that if 75 is used, it
;MUST be preceded by a blank space to pad the length to three.
;
;LPTNo% specifies which parallel printer port to use (1, 2, or 3).
;If the printer is off line, runs out of paper, and so forth, LPTNo%
;will be returned as -1.
;
;Translate% is either non-zero to tell ScrnDump to interpret the screen
;colors and convert them to a tile pattern, or 0 to print all colors black.



.Model Medium,BASIC
.Data

MSave          DB   ?
EPSONInit      DB   1Bh, "3", 24
EPSONReset     DB   1Bh, 40h
HPInit         DB   27, "*t150R", 27, "*r1A"
                                  ;was *r0A, this honors current left margin
HPReset        DB   27, "*rB"
TestInc        DW   0
UsePrinter     DW   0
EGAToBW        DB   00000001b, 01010100b, 11101110b, 0
               DB   00010000b, 00101010b, 11011101b, 0
               DB   00000100b, 00010101b, 10111011b, 01000000b
               DB   01000000b, 10001010b, 01110111b, 0
BWToBW         DB   255, 255, 255, 255
               DB   255, 255, 255, 255
               DB   255, 255, 255, 255
               DB   255, 255, 255, 255
WhichTable     DW   Offset EGAToBW
TakeOut        DW   1
LineBytes      DW   80
InterNumber    DW   1

OldStack       DW   1     ;these lines were added 8/6/88 EW
ErrCode        DW   1

;NOTE:  Modifications to the next set of data will cause trouble if you are
;       not careful to also modify the code that accesses the data addresses.
;       Some variables are pointed to by addressing another and incrementing
;       the Offset pointer.  Search for "****" to see where the source code
;       must be changed.

Retrieve       DW   OffSet ByteCGAMono
VideoBufSeg    DW   0B800h
Wide           DW   639
Siz            DW   199
LineLength     DW   80
EndPoint       DW   3F40h
FirstInter     DW   8112, -8192, 8112, -8192
HPBegin        DB   27, "*b80W"
EPSONBegin     DB   13, 32, 27, "K", 144, 1
SavLineBytes   DW   80
EPSONInter     DW   8112, -8192, 8112, -8192
DoubleSize     DW   2

;CGA 4 color 320 x 200
FirstMonitor DW Offset ByteCGAColor, 0B800h, 319, 199, 40, 3F40h, -8192, 8112, -8192, 8112
  DB 27, "*b40W"
  DB 13, 10, 27, "K", 200, 0
  DW 80, 8111, -8193, 8111, -8193, 1

;CGA 2 color 640 x 200
  DW Offset ByteCGAMono, 0B800h, 639, 199, 80, 3F40h, -8192, 8112, -8192, 8112
  DB 27, "*b80W"
  DB 13, 10, 27, "K", 144, 1
  DW 80, 8112, -8192, 8112, -8192, 2

;Herc 720 x 350
  DW Offset ByteCGAMono, 0B000h, 719, 349, 90, 3EF0h, -8192 * 3, 8102, 8102, 8102
  DB 27, "*b90W"
  DB 13, 10, 27, "K", 94, 1
  DW 90, -8192, -8192, 8192 * 3 - 90, -8192, 1

;EGA 16 color 320 x 200
  DW Offset ByteEGAColor, 0A000h, 319, 199, 40, 1F40h, 0, 0, 0, 0
  DB 27, "*b40W"
  DB 13, 10, 27, "K", 200, 0
  DW 40, -40, -40, -40, -40, 1

;EGA 16 color 640 x 200
  DW Offset ByteEGAColor, 0A000h, 639, 199, 80, 3E80h, 0, 0, 0, 0
  DB 27, "*b80W"
  DB 13, 10, 27, "K", 200, 0
  DW 80, -80, -80, -80, -80, 1

;EGA mono 640 x 350
  DW Offset ByteEGAColor, 0A000h, 639, 349, 80, 6D60h, 0, 0, 0, 0
  DB 27, "*b80W"
  DB 13, 10, 27, "K", 94, 1
  DW 80, -80, -80, -80, -80, 1

;EGA 16 color 640 x 350
  DW Offset ByteEGAColor, 0A000h, 639, 349, 80, 6D60h, 0, 0, 0, 0
  DB 27, "*b80W"
  DB 13, 10, 27, "K", 94, 1
  DW 80, -80, -80, -80, -80, 1

;VGA mono 640 x 480
  DW Offset ByteEGAColor, 0A000h, 639, 479, 80, 9600h, 0, 0, 0, 0
  DB 27, "*b80W"
  DB 13, 10, 27, "K", 224, 1
  DW 80, -80, -80, -80, -80, 1

;VGA 16 color 640 x 480
  DW Offset ByteEGAColor, 0A000h, 639, 479, 80, 9600h, 0, 0, 0, 0
  DB 27, "*b80W"
  DB 13, 10, 27, "K", 224, 1
  DW 80, -80, -80, -80, -80, 1

.Code
    Extrn  StringInfo:Proc

ScrnDump Proc Uses ES DI SI, DotsPerInch:Ptr, PrinterNO:Ptr, TranslateEGA:Ptr

    Mov    OldStack,SP    ;save SP in case we have to bail out of a Call
    Mov    ErrCode,0      ;assume no errors for now
;determine video display
    XOR    AX,AX          ;access segment zero through ES
    MOV    ES,AX          ;is it a monochrome screen?
    CMP    Byte Ptr ES:[0463h],0B4h
    PUSH   DS             ;make ES the same as DS for Movs later
    POP    ES
    JNE    ItIsColor      ;no, a color screen is active

                          ;check to see if Hercules
    MOV    CX,8000h       ;we're going to test this a bunch of times
    MOV    DX,3BAH        ;Hercules video status port
    IN     AL,DX          ;if bit 7 ever changes, it's a Herc card
    AND    AL,80h         ;isolate just the bit we care about
    MOV    AH,AL          ;save it in AH

CheckHERC:
    IN     AL,DX          ;now read register repeatedly
    AND    AL,80h         ;isolate the bit again
    CMP    AL,AH          ;has it changed?
    JNE    MonitorHerc    ;yes, a Herc card must be installed
    LOOP   CheckHERC      ;the bit hasn't changed yet, keep looping
                          ;if we got this far without AL changing,
                          ;it must be a plain ol' mono card, goodbye

TimeToLeave:              ;exit the routine at end of code
    JMP    AllDone

MonitorHerc:
    MOV    AL,7           ;Use Mode 7 as HERC and skip the BIOS monitor detect
    JMP    Short BypassBiosCheck

ItIsColor:
    MOV    AH,0Fh         ;Ask BIOS what monitor is currently active
    INT    10h

BypassBiosCheck:
    MOV    BL,AL          ;we'll need AL so put the monitor type in BL
    CMP    BL,4           ;if in text mode
    JB     TimeToLeave    ;then Exit
    JA     CheckTheNext   ;if mode is 4 then shift to mode 5
    INC    BL

CheckTheNext:
    CMP    BL,8           ;if in modes 4 - 7
    JB     MonitorOK      ;then Ok Graphics mode
    CMP    BL,13          ;if mode 8 - 12 then
    JB     TimeToLeave    ;  exit program
    CMP    BL,18          ;if Mode > 18 then
    JA     TimeToLeave    ;don't know these modes
    SUB    BL,5           ;adjust table to read continuously

MonitorOK:
    MOV    DI,PrinterNO   ;ask the host program which printer
    MOV    DX,[DI]        ;  to send it to LPT1: - LPT3: as 1-3
    DEC    DX             ;adjust 1 - 3 to 0 - 2 for use with INT 17h
    MOV    UsePrinter,DX  ;store it away for later
    MOV    MSave,BL       ;store the video mode for later too
    MOV    Word Ptr TakeOut,1 ;increment for Epson columns
    CMP    BL,5           ;if 320 x 200 graphics mode then
    JNE    DontTakeMore   ;  we need to move to screen columns
    INC    Word Ptr TakeOut ;for every printer column if Epson

DontTakeMore:
    SUB    BL,5           ;calculate offset into table based on
    MOV    AX,44          ;  monitor type
    MUL    BL
    MOV    SI,Offset FirstMonitor   ;offset of table
    MOV    DI,Offset Retrieve       ;offset of variables used by program
    ADD    SI,AX          ;add monitor offset
    MOV    CX,22          ;move 22 words of data
    REP    MOVSW          ;  into work variables

    MOV    BX,SavLineBytes    ;we need a copy to modify that tells how many
    MOV    LineBytes,BX       ;bytes per line, not how many columns

;Decide if we need to translate colors to BW
    MOV    DI,TranslateEGA    ;see if they want to translate colors
    MOV    DX,Offset BWToBW   ;assume not
    CMP    Word Ptr [DI],0    ;if true (not 0) then translate the
    JE     PickPrinter        ;  colors into tile patterns
    MOV    DX,Offset EGAToBW  ;load offset of tile patterns table

PickPrinter:
    MOV    WhichTable,DX      ;save the address of the correct table

;Need to make decision here as to which printer to use
    MOV    SI,DotsPerInch     ;look at DPI$
    Pop    ES
    Call   StringInfo
    Push   ES
    CMP    CX,3               ;  passed for the HP
    JNE    DoEPSON            ;otherwise do the EPSON
    Mov    ES,DX              ;a string of length 3 should have been
    MOV    SI,AX              ;to work the HP we need the address of the
    MOV    DI,Offset HPInit   ;  string to place in the HP Init String
    ADD    DI,3               ;we want to insert three bytes into the string
MovSbFake:
    Mov    AL,ES:[SI]
    Mov    DS:[DI],AL
    Inc    SI
    Inc    DI
    Loop   MovSbFake

;**************************************************************************;
;                 PRINT TO THE HP PRINTER TYPE                             ;
;**************************************************************************;

    MOV    ES,VideoBufSeg     ;we need the Video Segment in ES
    XOR    BX,BX              ;we'll start at Offset 0 later
    CALL   InitHP             ;initialize the HP
    MOV    CX,6               ;tell the HP we're going to
    MOV    DI,OFFSET HPBegin  ;send LineLength bytes
    CALL   PrintBuffer

DoMore:
    MOV    CX,4           ;loops of 4 will handle all of the
                          ;interlace types used in graphics modes

NextInter:
    PUSH   CX             ;after this we can modify CX without worry
    DEC    CX             ;calculate the offset
    SHL    CX,1           ;  into the EGA to BW
    SHL    CX,1           ;  buffer so the graphics
    MOV    InterNumber,CX ;  routine will work fast
    MOV    CX,LineLength  ;send LineLength bytes

NextByte:
    PUSH   CX
    CALL   Word Ptr Retrieve  ;the variable Retrieve holds the offset
                              ;  of the correct routine to call
    POP    CX
    MOV    DX,UsePrinter      ;the printer number was stored here
    XOR    AH,AH              ;print a Character service
    INT    17h                ;print it
    CALL   POkay              ;did the byte get printed successfully?
    INC    BX                 ;point to the next screen location
    LOOP   NextByte           ;loop until done

    POP    CX                 ;CX is which interlace
    CMP    BX,EndPoint        ;have we reached the last offset to print?
    JE     AllDoneHP          ;yes

;Note when CX is 1 we want word offset 0 so we start with an address of
; 1 word lower in memory
;****
    MOV    DI,Offset EndPoint ;time to work the
    ADD    DI,CX              ;  interlace of some
    ADD    DI,CX              ;  graphics modes by
    MOV    AX,[DI]            ;  adding the appropriate
    ADD    BX,AX              ;  values
    PUSH   CX
    MOV    CX,6               ;tell the HP
    MOV    DI,OFFSET HPBegin  ;  we're going to
    CALL   PrintBuffer        ;  send LineLength bytes
    POP    CX
    LOOP   NextInter
    JMP    Short DoMore

AllDoneHP:
    CALL   UndoHP             ;tell the HP were done
    JMP    AllDone

;**************************************************************************;
;              PRINT TO THE EPSON PRINTER TYPE                             ;
;**************************************************************************;

DoEPSON:
    CALL   InitEPSON

    MOV    ES,VideoBufSeg ;we need the video segment in ES
    MOV    BX,EndPoint    ;calculate the last video offset
    SUB    BX,LineBytes   ;of the current column - in this case
                          ;  the first column
    MOV    CX,LineLength  ;do this many columns

DoColumnE:
    PUSH   CX             ;store the number of columns remaining
    MOV    CX,6                 ;tell the Epson
    MOV    DI,OFFSET EPSONBegin ;  we're going to
    CALL   PrintBuffer          ;  send LineLength bytes

DoMoreE:
    MOV    CX,4           ;do 4 steps for all possible interlace schemes

NextInterE:
    PUSH   CX             ;store Interlace level away while we
                          ;  find the screen contents
    DEC    CX             ;calculate the offset
    SHL    CX,1           ;  into the EGA to BW
    SHL    CX,1           ;  buffer so the graphics
    MOV    InterNumber,CX ;  routine will work fast

    CALL   Word Ptr Retrieve  ;get screen contents in AL

;Print the Character
    MOV    CX,DoubleSize      ;Number of times to repeat
DoubleRepeat:
    MOV    DX,UsePrinter      ;the printer number was stored here
    XOR    AH,AH              ;function to print a character
    INT    17h                ;print the character in AL
    CALL   POkay              ;did the byte get printed sucessfully?
    LOOP   DoubleRepeat       ;Repeat the print function if DoubleSize = 2
    INC    Word Ptr TestInc

;Calculate the Next Position
    POP    CX                 ;restore interlace into CX for LOOP
    CMP    BX,SavLineBytes    ;if just printed while in first row
    JB     NextColumnE        ;  then start at last row, next column
;****
    MOV    DI,Offset SavLineBytes   ;work the interlace
    ADD    DI,CX                    ;  by calculating the offset
    ADD    DI,CX                    ;  in table for Epson interlaces
    MOV    AX,[DI]                  ;then add that value
    ADD    BX,AX                    ;  to our Screen offset
    LOOP   NextInterE               ;get another byte and change
                                    ;  interlace number
    JMP    DoMoreE                  ;do more interlaced bytes

NextColumnE:
    MOV    CX,TakeOut               ;take out the number of bytes
    MOV    DI,Offset LineBytes      ;  that make up an 8 bit output
    SUB    [DI], CX                 ;  from the variable which will
    MOV    BX,EndPoint              ;  position us at the correct column
    SUB    BX,LineBytes             ;  on the last row of the current screen
    POP    CX                       ;restore the number of columns left
    LOOP   DoColumnE                ;  and do another column

AllDone:
    Mov    SP,OldStack              ;restore the stack EXACTLY as it was
    Cmp    ErrCode,-1               ;was there an error?
    Jnz    NoError                  ;no, leave
    Mov    SI,PrinterNO             ;yes, get the address for PrinterNo%
    Mov    Word Ptr [SI],-1         ;set it to -1

NoError:
    RET                             ;return to BASIC
;END of main code


PrintBuffer:
    XOR    AH,AH          ;Function 0 - print a char
    MOV    DX,UsePrinter  ;use this printer
    MOV    AL,[DI]        ;get character to print
    INC    DI             ;move to next position in buf
    INT    17h            ;print this character
    CALL   POkay          ;did the byte get printed successfully?
    LOOP   PrintBuffer    ;print CX items
    RetN


InitEPSON:
    MOV    DI,OFFSET EPSONInit   ;offset of buffer to print
    MOV    CX,3                  ;number of bytes in the buffer
    CALL   PrintBuffer           ;print the buffer
    RetN


InitHP:
    MOV    DI,OFFSET HPInit      ;offset of buffer to print
    MOV    CX,12                 ;number of bytes in the buffer
    CALL   PrintBuffer           ;print the buffer
    RetN


UndoHP:
    MOV    DI,OFFSET HPReset     ;offset of buffer to print
    MOV    CX,4                  ;number of bytes in the buffer
    CALL   PrintBuffer           ;print the buffer
    RetN


;also does Hercules
ByteCGAMono:
    MOV    AL,ES:[BX]            ;put byte straight from screen
    RetN


ByteCGAColor:
    XOR    AL,AL                 ;clear the output byte
    MOV    DH,ES:[BX]            ;get one of the bytes needed
    INC    BX                    ;the outside routine will increment BX
                                 ;  resulting in two increments
    MOV    DL,ES:[BX]            ;get the next byte needed
    MOV    CX,8                  ;to retrieve 8 bits

CGALoop1:
    MOV    AH,1                  ;AH will be shifted into
                                 ;  the proper position
    SHL    DX,1                  ;shift to check Carry
    JC     CGAColor23            ;if Carry then COLOR > 1
    SHL    DX,1                  ;shift to check Carry
    JC     CGAColor1             ;if Carry then COLOR = 1
    JMP    Short CGANextSet      ;COLOR = 0, do nothing

CGAColor1:
    PUSH   CX                    ;store CX so we can use it
    MOV    DI,WhichTable         ;offset of EGA to B/W table
    ADD    DI,InterNumber        ;add (Interlace# - 1) * 4
    DEC    CX                    ;shift AH Left one less than
    SHL    AH,CL                 ;  bit number we are on
    AND    AH,[DI]               ;use EGAtoBW to Convert Color
    OR     AL,AH                 ;add Color of bit to output
    POP    CX                    ;get back bit number
    JMP    Short CGANextSet      ;do another bit

CGAColor23:
    SHL    DX,1                  ;shift to check Carry
    JC     CGAColor3             ;if Carry then COLOR = 3
    PUSH   CX                    ;COLOR = 2, Store CX away
    MOV    DI,WhichTable         ;offset to EGA to b/w table
    ADD    DI,InterNumber        ;modify offset to line number
    DEC    CX                    ;shift AH left one less than
    SHL    AH,CL                 ;  bit number we are on
    INC    DI                    ;get offset of plane 2 color
    AND    AH,[DI]               ;and check if color into BW
    OR     AL,AH                 ;if bit set, set output bit
    POP    CX                    ;get back bit number we're on
    JMP    Short CGANextSet      ;do another bit

CGAColor3:
    PUSH   CX                    ;COLOR = 3, store away bit #
    DEC    CX                    ;shift AH left one less than
    SHL    AH,CL                 ;  bit number we are on
    OR     AL,AH                 ;set output bit
    POP    CX                    ;get back bit number we're on

CGANextSet:
    LOOP   CGALoop1              ;do another bit in loop
    RetN


;also does EGAMono and VGAMono and VGAColor
ByteEGAColor:
    MOV    CX, 4
    XOR    AX,AX
    PUSH   AX                    ;store blank screen
    PUSH   AX                    ;store first plane
    MOV    DI,WhichTable
    ADD    DI,InterNumber

EGALoop1:
    MOV    DX,03CEh              ;switch video planes
    MOV    AL, 4
    OUT    DX, AL
    INC    DX
    POP    AX                    ;retrieve stored value
    OUT    DX, AL
    INC    AX                    ;next plane
    MOV    DX,AX                 ;store plane in DL

    POP    AX                    ;previous screen value (AH)
    MOV    AL,ES:[BX]            ;value on screen
    AND    AL,[DI]               ;AND with pattern for plane
    OR     AH,AL                 ;OR with previous values
    PUSH   AX                    ;put back on stack (AH)
    PUSH   DX                    ;put plane on stack (DL)
    INC    DI                    ;next pattern
    LOOP   EGALoop1              ;loop 4 times

    POP    AX                    ;clean up stack
    POP    AX                    ;value to print (AL)
    MOV    AL, AH
    RetN

POkay:                            ;check the status of the last Int 17h print
    Or   AH,10000000b            ;who cares if it's busy?
    And  AH,10111111b            ;ditto for the printer acknowledgment
    Cmp  AH,144                  ;see what happened
    Jnz  NoGood                  ;no good, bail out early
    RetN                         ;it was okay, return normally

NoGood:
    Mov  ErrCode, -1
    Jmp  AllDone                 ;an early exit is better than a hang any day

ScrnDump Endp
END
