;----- GPExist.Asm - determine if named file exists

;Copyright (c) 1987 Ethan Winer
;BC7 version 1/1991 J.M.

;Syntax - File.Name$ = "\Path\Filename.Ext"
;         Call GPExist(File.Name$, There%) : If There% Then ...
;         where There% = -1 if the file exists, otherwise There% = 0


.Model Medium,BASIC
Extrn  StringAddress :Proc
Extrn  StringLength  :Proc

.Data

DTA             DB   44 Dup (?)       ;Disk Data Transfer Area
File_Spec       DB   64 Dup (?)       ;holds copy of File.Name$ to add Chr$(0) locally

.Code

GPExist Proc Uses ES SI DI, FName:Ptr, There:Ptr

                Push DS
                Pop  ES               ;insure that ES holds Data Segment
                Lea  DX,DTA           ;put address of DTA into DS:DX for set DTA service below

                Mov  AH,1Ah           ;set DTA service - creates space where file name info will be put by DOS
                Int  21h              ;call DOS to do it

                Mov  BX,Fname         ;BX holds address of File.Name$ descriptor
                Push BX
                Push BX
                Call StringLength     ;call BC7 for string length
                Mov  CX,AX            ;put Len(File.Name$) into CX to copy File.Name$ into local storage
                Pop  BX
                Jcxz Exit
                Push BX
                Call StringAddress    ;call BC7 for string address
                Mov  SI,AX            ;point Source Index to first character in File.Name$
                Push DS               ;save DS for move here
                Mov  DS,DX
                Lea  DI,File_Spec     ;point Destination Index to beginning of local storage
                Cld                   ;prepare to move bytes in the forward direction
                Rep  Movsb            ;move CX bytes
                Pop  DS
                Mov  Byte Ptr [DI],0  ;make an ASCIIZ string by adding a Chr$(0) to the end of File.Name$
                Lea  DX,File_Spec     ;Find_First expects the address of search string in DS:DX

                Mov  SI,There         ;get address of There% so we can set it depending on whether file exists or not
                Mov  Word Ptr [SI],0  ;set There% = 0 to initially show file as not being there

                                      ;CX is already zero to specify which type of files to search for via attributes
                Mov  AH,4Eh           ;find first matching file name service

                Int  21h              ;call DOS to look for it
                JC   Exit             ;not there, leave There% set to zero
                Dec  Word Ptr [SI]    ;yes, set There% = -1 by decrementing it from zero

Exit:           Ret                  ;exit back to BASIC

GPExist         Endp
                End
