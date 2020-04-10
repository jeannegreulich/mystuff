#!/usr/bin/env ruby

mapping = {
       "00" => "NUL",
       "01" => "SOH",
       "02" => "STX",
       "03" => "ETX",
       "04" => "EOT",
       "05" => "ENQ",
       "06" => "ACK",
       "07" => "BEL",
       "08" => "BS",
                        40    @
                        41    A
                        42    B
                        43    C
                        44    D
                        45    E
                        46    F
                        47    G
                        48    H
       "09" => "HT  '\t' (horizontal tab)   49    I
       "0A" => "LF  '\n' (new line)         4A    J
       "0B" => "VT  '\v' (vertical tab)     4B    K
       "0C" => "FF  '\f' (form feed)        4C    L
       "0D" => "CR  '\r' (carriage ret)     4D    M
       "0E" => "SO  (shift out)             4E    N
       "0F" => "SI  (shift in)              4F    O
       "10" => "DLE (data link escape)      50    P
       "11" => "DC1 (device control 1)      51    Q
       "12" => "DC2 (device control 2)      52    R
       "13" => "DC3 (device control 3)      53    S
       "14" => "DC4 (device control 4)      54    T
       "15" => "NAK (negative ack.)         55    U
       "16" => "SYN (synchronous idle)      56    V
       "17" => "ETB (end of trans. blk)     57    W
       "18" => "CAN (cancel)                58    X
       "19" => "EM  (end of medium)         59    Y
       1B    ESC (escape)                5B    [
       1C    FS  (file separator)        5C    \  '\\'
       1D    GS  (group separator)       5D    ]
       1E    RS  (record separator)      5E    ^
       1F    US  (unit separator)        5F    _
       20    SPACE                       60    `
       21    !                           61    a
       22    "                           62    b
       23    #                           63    c
       24    $                           64    d
       25    %                           65    e
       26    &                           66    f
       27    ´                           67    g
       28    (                           68    h
       29    )                           69    i
       2A    *                           6A    j
       2B    +                           6B    k
       2C    ,                           6C    l
       2D    -                           6D    m
       2E    .                           6E    n
       2F    /                           6F    o
       30    0                           70    p
       31    1                           71    q
       32    2                           72    r
       33    3                           73    s
       34    4                           74    t
       35    5                           75    u
       36    6                           76    v
       37    7

    :                                                172   122   7A    z
       073   59    3B    ;                           173   123   7B    {
       074   60    3C    <                           174   124   7C    |
       075   61    3D    =                           175   125   7D    }
       076   62    3E    >                           176   126   7E    ~
       077   63    3F    ?                           177   127   7F    DEL
    :                           172   122   7A    z
       073   59    3B    ;                           173   123   7B    {
       074   60    3C    <                           174   124   7C    |
       075   61    3D    =                           175   125   7D    }
       076   62    3E    >                           176   126   7E    ~
       077   63    3F    ?                           177   127   7F    DEL
    :                           172   122   7A    z
       073   59    3B    ;                           173   123   7B    {
       074   60    3C    <                           174   124   7C    |
       075   61    3D    =                           175   125   7D    }
       076   62    3E    >                           176   126   7E    ~
       077   63    3F    ?                           177   127   7F    DEL



30 82 01 9e 30 82 01 07 02 01 00 30 17 31 15 30 
13 06 03 55 04 03 13 0c 31 30 2e 32 35 35 2e 33 
37 2e 36 39 30 81 9f 30 0d 06 09 2a 86 48 86 f7 
0d 01 01 01 05 00 03 81 8d 00 30 81 89 02 81 81 
00 c0 3a 0e 0c 72 38 cc e7 b7 87 04 00 d1 69 e0 
08 f7 59 1a 83 45 cf 3e 84 e4 d7 8e 5d c0 29 ab 
af b9 ea 00 29 5a c1 f8 91 44 22 91 8f c1 94 5b 
f6 1e 4a 9d f0 46 97 6e c6 8f bb 5f 16 77 98 82 
5c 2c 19 21 a9 4e 41 4c 6f 71 88 53 43 31 17 b8 
99 81 8b bc 1c 74 98 56 84 4c e4 58 8c 39 08 a2 
46 1b 18 67 05 b1 44 64 e2 c2 db 9f 7a d0 10 71 
af fe 0c fc cc 09 4c 83 31 59 ba 2d ec a2 02 5d 
37 02 03 01 00 01 a0 47 30 20 06 09 2a 86 48 86 
f7 0d 01 09 07 31 13 16 11 6f 6e 65 5f 74 69 6d 
65 5f 70 61 73 73 77 6f 72 64 30 23 06 09 2a 86 
48 86 f7 0d 01 09 0e 31 16 30 14 30 12 06 03 55 
1d 11 01 01 ff 04 08 30 06 87 04 0a ff 25 45 30 
0d 06 09 2a 86 48 86 f7 0d 01 01 05 05 00 03 81 
81 00 42 48 29 ac 5a cb 4c f2 c8 2f bd 26 aa d0 
07 e6 23 0d ea 58 83 4b 07 b0 23 f7 cd 16 44 c6 
b1 11 66 50 3b 8c bf 50 c6 15 28 1a a7 39 df b7 
a7 60 93 25 7d 8a d2 a8 5b b0 a8 db cf 8b 97 63 
f3 21 1e df 2f eb fb 4f 47 41 37 a7 4a 76 a3 42 
c7 4f a7 1b 3d 8f 70 93 6e e1 9b ce 57 73 2c 32 
6a 26 f3 5f be 26 ab bd 9d a5 d3 3c c0 16 c5 74 
8d 7c 69 79 e7 fb 45 21 61 d5 39 5a ab ef 52 d6 
34 93 06 06 06 06 06 06 

