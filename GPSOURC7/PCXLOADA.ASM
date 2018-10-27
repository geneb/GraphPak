;***** PCXLOADA.ASM - This file contains assembly code for loading a file
;                     that uses the .PCX file format used in PC Paintbrush

;Copyright (c) 1988 Brian C. Giedt

;The calling instructions for the routines in this file are
;
;   CALL BankSW2 (Plane%)
;   CALL SendScreen (z%, Count%, This%)
;   CALL SendByte (z%, This%)

.MODEL MEDIUM,Basic
.CODE

BANKSW2 Proc, Plane:Ptr     ;Switch the bank on an EGA/VGA for sending

    MOV     DX,03C4h        ;Send the instruction to the monitor
    MOV     AL,02
    OUT     DX,AL
    INC     DX
    MOV     BX,Plane        ;To change to the plane in PLANE%
    MOV     AL,[BX]
    OUT     DX,AL
    RET

BankSw2 ENDP



SENDSCREEN Proc Uses DI ES, z:Ptr, Count:Ptr, Thiss:Ptr
                                ;Send Count% bytes of data to the screen
    MOV     AX,0A000h       ;Address the EGA/VGA video segment
    MOV     ES,AX
    MOV     BX,z            ;Obtain the video offset
    MOV     DI,[BX]
    MOV     BX,Count        ;Obtain the number of times to repeat the
    MOV     CX,[BX]         ;  operation
    MOV     BX,Thiss        ;Get the byte of data to send
    MOV     AL,[BX]
    REP     STOSB
    RET

SendScreen ENDP



SENDBYTE Proc Uses ES SI DI, z:Word, Thiss:Word   ;Send a single byte to the EGA/VGA

    MOV     AX,0A000h       ;Get the EGA/VGA segment
    MOV     ES,AX
    MOV     SI,z            ;Get the video offset
    MOV     DI,[SI]
    MOV     SI,Thiss        ;Get the byte to send
    MOVSB                   ;move the byte to video memory
    RET

SendByte ENDP
END
