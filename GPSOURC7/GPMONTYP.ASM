;GPMonTyp.Asm - reports the type of display adpater currently in use
;
;Copyright (c) 1987 Ethan Winer - SPECIAL FOR COMPATIBILITY WITH GRAPHPAK
;BC7 version J. Munro
;Calling syntax:
;
;Call GPMonType(Monitor%, Memory%)
;                  |         |
;                  |         +----- 0, or number of 64K memory blocks (1-4)
;                  |
;                  +--------------- 1 = EGA w/monochrome monitor
;                                   2 = Hercules monochrome adapter
;                                   3 = Monochrome adapter
;                                   4 = CGA adapter or an EGA emulating a CGA
;                                   5 = EGA adapter w/color monitor
;                                   7 = VGA adapter w/mono monitor
;                                   8 = VGA adapter w/color monitor


Code     Segment Byte Public 'Code'
         Assume  CS:Code
         Public  GPMonType

GPMonType  Proc Far

Begin:   Push BP                   ;save BP for BASIC
         Mov  BP,SP                ;get the stack pointer into BP
         Push SI
         Push DI
         Push ES
         Mov  SI,[BP+06]           ;set amount of EGA memory in 64K blocks
         Mov  Word Ptr [SI],0      ;assume zero bytes for now

         Mov  AX,1A00h             ;first we'll see if it's a VGA adapter
         Push BP                   ;some older PC BIOS's trash BP with Int 10h
         Int  10h
         Pop  BP
         Cmp  AL,1Ah               ;was it a VGA?
         JNZ  EGA                  ;no, but maybe it's an EGA
         Xor  BH,BH                ;clear BH
         Mov  DI,BX                ;set DI to BL if it is a VGA
         Cmp  BL,7                 ;if it really is a VGA, BL will be 7 or 8
         JZ   Finished             ;it's a mono monitor
         Cmp  BL,8
         JZ   Finished             ;it's a color monitor


EGA:
         Mov  AH,12h               ;ask for EGA info to see if it's an EGA
         Mov  BL,10h
         Push BP
         Int  10h
         Pop  BP
         Cmp  BL,10h               ;BL will still hold 10h if it's not an EGA
         JZ   CGA_Mono             ;not an EGA, must be a CGA or mono

         And  CL,00000110b         ;but wait - see if EGA is emulating a CGA
         Cmp  CL,0110b             ;well, is it?
         JZ   CGA                  ;yes, let the code at label CGA: handle it

         Mov  AL,BL                ;put the amount of EGA memory into AL
         Inc  AL                   ;adjust 0-3 to 1-4
         CBW                       ;clear AH
         Mov  [SI],AX              ;pass the memory back to Memory%
         Mov  DI,5                 ;assume EGA is connected to a color monitor
         Cmp  BH,0                 ;but is it really?
         JZ   Finished             ;yes, leave DI set to 5 and get outa' here
         Mov  DI,1                 ;no, show that it's a mono monitor
         Jmp  Finished             ;and go bye bye


CGA_Mono:
         Mov  AX,0                 ;now see if it's a color or monochrome
         Mov  ES,AX                ;look in low memory
         Mov  AL,ES:[463h]         ;in the BIOS data area
         Cmp  AL,0B4h              ;is it mono?
         JNZ  CGA                  ;nope


Mono:
         Mov  CX,8000h             ;we're going to test this 32,768 times
         Mov  DX,3BAH              ;Hercules video status port
         In   AL,DX                ;if bit 7 ever changes, it's a Herc card
         And  AL,80h               ;isolate just the bit we care about
         Mov  AH,AL                ;save it in AH


HercLoop:
         In   AL,DX                ;now read register repeatedly
         And  AL,80h               ;isolate the bit again
         Cmp  AL,AH                ;has it changed?
         Jne  Hercules             ;yes, a Herc card must be installed
         Loop HercLoop             ;the bit hasn't changed yet, keep looping
         Mov  DI,3                 ;if we got this far without AL changing,
         Jmp  Short Finished       ;  it must be a plain ol' mono card


Hercules:
         Mov  DI,2                 ;indicate a Hercules adapter
         Jmp  Short Finished       ;and get out of here


CGA:
         Mov  DI,4


Finished:
         Mov  SI,[BP+08]           ;return monitor type in Monitor%
         Mov  [SI],DI
         Pop  ES
         Pop  DI
         Pop  SI
         Pop  BP
         Ret  4

GPMonType  Endp
Code       Ends
           End
