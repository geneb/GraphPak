;***** PCXSAVE.BAS - This file supports saving a file in the .PCX
;                    file format used in PC Paintbrush
;BC7 version
;Copyright (c) 1988 Brian C. Giedt

;The calling syntax for the assembly routines in this file is
;
;   CALL BankSW1 (Plane%)
;   CALL GetByteEGA (This%, Location%)
;   CALL WhichScreen (Mode%)


.MODEL MEDIUM, BASIC
.CODE

BANKSW1 Proc, Plane:Word ;Switch the bank on the EGA/VGA to prepare
                         ;for retrieving a byte from the video
    MOV   DX,03CEh       ;Out to the proper port
    MOV   AL,04
    OUT   DX,AL
    INC   DX
    MOV   BX,Plane       ;Get the Plane data from the parameter PLANE%
    MOV   AL,[BX]
    OUT   DX,AL
    RET
    
BankSW1 ENDP



GetByteEGA Proc Uses ES SI, Thiss:Word, Location:Word
                        ;Get a byte from the EGA/VGA

    MOV   AX,0A000h     ;Get the EGA\VGA video segment
    MOV   ES,AX
    MOV   BX,Location   ;Get the video offset
    MOV   BX,[BX]
    MOV   SI,Thiss      ;Get the offset of the return variable
    MOV   AL,ES:[BX]    ;Get the byte from the screen
    MOV   [SI],AL       ;Return the byte in the parameter THIS%
    RET
    
GetByteEga ENDP



WhichScreen Proc, Mode:Ptr

    MOV   AH,0Fh
    PUSH  BP
    INT   10h
    POP   BP
    XOR   AH,AH
    MOV   BX,Mode
    MOV   [BX],AX
    RET
    
WhichScreen ENDP
END
