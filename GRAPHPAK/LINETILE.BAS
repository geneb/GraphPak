'********** LineTile.Bas - Include file for setting up tiling of lines

'Copyright (c) 1987 Brian Giedt
'Copyright (c) 1987 Crescent Software
  
    MaxTileNum = 12
    REDIM GPLTile%(MaxTileNum)
    'The above line may need to be changed if more than 12 items are in the
    'array and you wish to create different patterns for all of them

    'The below calls to the function MakeBinary specify the bit patterns for
    'the line tiles.  If you wish to change the tiles, simple overwrite the
    'bits to the ones you want.  NOTE: For the EGA\VGA no tiles were chosen.

    MaxClr = GPDat%(50)
    GPLTile%(1) = MakeBinary("1111111111111111")
    GPLTile%(2) = MakeBinary("1100110011001100")
    GPLTile%(3) = MakeBinary("1111000011110000")
    GPLTile%(4) = MakeBinary("1001001001001001")
    GPLTile%(5) = MakeBinary("1110111011101110")
    GPLTile%(6) = MakeBinary("1010101010101010")
    GPLTile%(7) = MakeBinary("1010000110100001")
    GPLTile%(8) = MakeBinary("1110111111101111")
    GPLTile%(9) = MakeBinary("1101101111011011")
    GPLTile%(10) = MakeBinary("0001001000001001")
    GPLTile%(11) = MakeBinary("0000000100000001")
    GPLTile%(12) = MakeBinary("0010001000100010")
