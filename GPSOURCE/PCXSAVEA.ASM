;***** PCXSAVE.BAS - This file demostrates saveing a file using the .PCX
;                    file format used in PC Paintbrush

;Copyright (c) 1988 Brian C. Giedt

;The calling syntax for the assembly routines in this file is
;
;            CALL BankSW1 (Plane%)
;
;            CALL GetByteEGA (This%, Location%)
;
;            CALL WhichScreen (Mode%)
;

.MODEL MEDIUM
.CODE
INCLUDE MIXED.INC

HPROC BANKSW1, Plane             ;Switch the bank on the EGA/VGA to prepare
                                 ;for retrieving a byte from the video

            MOV   DX,03CEh       ;Out to the proper port
            MOV   AL,04
            OUT   DX,AL
            INC   DX
            MOV   SI,Plane       ;Get the Plane data from the parameter PLANE%
            MOV   AL,[SI]
            OUT   DX,AL
            HRET
HENDP



HPROC GetByteEGA, Thiss:Ptr, Location:Ptr       ;Get a byte from the EGA/VGA

            MOV   AX,0A000h      ;Get the EGA\VGA video segment
            MOV   ES,AX
            MOV   SI,Location    ;Get the video offset
            MOV   BX,[SI]
            MOV   SI,Thiss       ;Get the offset of the return variable
            MOV   AL,ES:[BX]     ;Get the byte from the screen
            MOV   [SI],AL        ;Return the byte in the parameter THIS%
            HRET
HENDP



HPROC WhichScreen, Mode:Ptr

            MOV   AH,0Fh
            PUSH  BP
            INT   10h
            POP   BP
            XOR   AH,AH
            MOV   SI,Mode
            MOV   [SI],AX
            HRET
HENDP
END
