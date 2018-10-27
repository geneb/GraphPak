;***** PCXLOADA.ASM - This file contains assembly code used for loading a file
;                     that uses the .PCX file format used in PC Paintbrush

;Copyright (c) 1988 Brian C. Giedt

;The calling instructions for the routines in this file are
;
;            CALL BankSW2 (Plane%)
;
;            CALL SendScreen (z%, Count%, This%)
;
;            CALL SendByte (z%, This%)

.MODEL MEDIUM
.CODE
INCLUDE MIXED.INC

HPROC BANKSW2, Plane:Ptr        ;Switch the bank on an EGA/VGA for sending

        MOV     DX,03C4h        ;Send the instruction to the monitor
        MOV     AL,02
        OUT     DX,AL
        INC     DX
        MOV     SI,Plane        ;To change to the plane in PLANE%
        MOV     AL,[SI]
        OUT     DX,AL
        HRET

HENDP



HPROC SENDSCREEN, z:Ptr, Count:Ptr, Thiss:Ptr   ;Send a byte of data to the
                                                ;screen Count% times
        MOV     AX,0A000h       ;Address the EGA/VGA video segment
        MOV     ES,AX
        MOV     SI,z            ;Obtain the video offset
        MOV     DI,[SI]
        MOV     SI,Count        ;Obtain the number of times to repeat the
        MOV     CX,[SI]         ;  operation
        MOV     SI,Thiss        ;Get the byte of data to send
        MOV     AL,[SI]
        REP     STOSB
        HRET

HENDP



HPROC SENDBYTE z, Thiss         ;Send a single byte to the EGA/VGA

        MOV     AX,0A000h       ;Get the EGA/VGA segment
        MOV     ES,AX
        MOV     SI,z            ;Get the video offset
        MOV     DI,[SI]
        MOV     SI,Thiss        ;Get the byte to send
        MOV     AL,[SI]
        MOVSB                   ;move the byte to video memory
        HRET

HENDP
END
