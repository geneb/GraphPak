'*** LoadFont - Loads specified font file into memory

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software


DEFINT A-Z

'$INCLUDE: 'Common'

SUB LoadFont (FontFile$) STATIC

   OPEN FontFile$ + ".GFN" FOR INPUT AS #99
   INPUT #99, GPLen                        'the first record contains ASCII
   CLOSE #99                               '  representation of record length

   OPEN FontFile$ + ".GFN" FOR RANDOM AS #99 LEN = GPLen
   FIELD #99, GPLen AS GPL$

   GET #99                                 'bypass the first record
   FOR GPCnt = 1 TO 95
       GET #99                             'get next record from file
       GPChar = ASC(LEFT$(GPL$, 1))        'first byte contains Length of $
       Font$(GPCnt, GPDat%(34)) = MID$(GPL$, 2, GPChar) 'extract string
       Max = ASC(MID$(GPL$, 2, 1)) MOD 16
       FOR T = 3 TO GPChar + 1
          Ma = ASC(MID$(GPL$, T, 1)) MOD 16
         IF Ma > Max THEN Max = Ma
       NEXT
       IF GPCnt = 72 THEN  'Check for the height of the font by checking "g"
         Max2 = ASC(MID$(GPL$, 2, 1)) \ 16
         FOR T = 3 TO GPChar + 1
            Ma2 = ASC(MID$(GPL$, T, 1)) \ 16
            IF Ma2 > Max2 THEN Max2 = Ma2
         NEXT
         FontHeight%(GPDat%(34)) = Max2
       END IF
       FontWidth%(GPCnt, GPDat%(34)) = Max
   NEXT

   CLOSE #99
  
   GPDat%(36) = GPDat%(48) + FontHeight%(GPDat%(34))
   GPDat%(35) = FontWidth%(56, GPDat%(34))

END SUB
