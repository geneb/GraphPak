;String Info  - returns length, segment and address of Far strings
;      saving all trashed registers
;Copyright (c) 1989 Crescent Software
;written by Jay Munro
;
;Usage -  Call StringInfo
;               Input
;               DS:SI = local address for string descriptor
;
;               Output
;               AX = offset of String Data
;               DX = Segment of String Data
;               CX = Length of String Data
;

.Model Medium,BASIC
Extrn  Stringassign:proc      ;
Extrn  StringAddress:Proc     ;BC 7's routines to get Far Strings info
Extrn  StringLength:Proc      ;  supplied by Microsoft

.Data
        Public NullSpace
        NullSpace   DW  ?  
.Code


StringInfo Proc
      Push SI                 ;save these regs
      Push DI                 ;
      Push BX                 ;
      Push ES                 ;
      Pushf                   ; and flags too

      Push ES                 ;save ES again since we need it up ahead
      Push SI                 ;push incoming string descriptor address
      Call StringAddress      ;call to get address

      Pop  ES                 ;retrieve ES for next call to StringLength
      Push AX                 ;save offset returned from StringAddress
      Push DX                 ;  and segment returned from StringAddress

      Push SI                 ;push incoming string descriptor address
      Call StringLength       ;now go for the length
      Mov  CX,AX              ;LEN(string) is in AX, so put it into CX to return

      Pop  DX                 ;get back saved Segment
      Pop  AX                 ;and address

      Popf                    ;retrieve flags and saved registers
      Pop  ES
      Pop  BX
      Pop  DI
      Pop  SI

Exit:
      Ret                     ;and return

StringInfo EndP


;MakeStrn.asm
;Makes a string descriptor for qbx

Comment / Expects :
 Incoming registers
    DX = Segment of Source Data
    AX = Offset of Source Data
    CX = Length of Source Data
    DS = Segment of Destination (string descriptor)
    DI = Offset of Destination
    BX = Length of Destination (0 for variable length string)

  Outgoing
    Memory location at DS:[DI] is filled in with string descriptor
/


MakeString Proc Uses ES 
     Push    DX              ;Push Segment of source string
     Push    AX              ;Push Offset of source string
     Push    CX              ;Push length if of source string
     Push    DS              ;Push segment of destination for descriptor
     Push    DI              ;push offset of destination for descriptor
     Push    BX              ;push length of destination (0 for fixed length)
     Call    Stringassign    ;go assign string

Exit:
    Ret

MakeString  EndP
End
