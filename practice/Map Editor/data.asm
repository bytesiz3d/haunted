;;; LoadSprite test
tpFilename                      DB      "../bin/teleport", 0
x2Filename                      DB      "../bin/x2speed", 0
;;; Scoreboard variables
SB_string                       DB      5 dup('$') 
SB_ext                          DB      "'s score: " 
SB_line                         DB      128 dup('_') 
SB_space                        DB      5(32)

;;; Haunted_MainMenu variables
HauntedWidth                    EQU     320
HauntedHeight                   EQU     89
HauntedFilename                 DB      "../bin/haunted", 0
HauntedData                     DB      HauntedWidth*HauntedHeight dup(0)
fileHandle                      DW      ?
p1Name                          DB      20, ?, 20 dup("$")
p2Name                          DB      20, ?, 20 dup("$")
newGame                         DB      0, 0, 0, "NEW GAME", 0, 0, 0
quit                            DB      0, 0, 0, "QUIT", 0, 0, 0                 
playerName                      DB      "Player$", " Name: $"                 

;; DrawSprite variables
Square_C                        DB      ?
Square_R                        DB      ?
Square_XF                       DW      ?
Square_YF                       DW      ?

Square_RES                      EQU     32
Grid_COLUMNS                    EQU     32
Grid_ROWS                       EQU     24

;;; DrawMap variables
Map_RC                          LABEL   WORD
Map_C                           DB      ?
Map_R                           DB      ?

;;; MoveGhost variables
mg_nextStep                     LABEL   WORD
mg_nextStep_C                   DB      ?
mg_nextStep_R                   DB      ?
mg_Step0                        DW      ?
mg_Step1                        DW      ?
mg_ghostOffset                  DW      ?
mg_ghostSpriteOffset            DW      ?

;;; Sprites
include sprites.asm
        
;;; Entity positions (AH: Row, AL: Column)
newPosition                     DW      ?
currentPlayer                   DW      ?      
Player_Base                     LABEL   WORD
Player_0                        DW      0202h
Player_1                        DW      021Dh
Player_0_WIN_MESSAGE            DB      "Player 0 wins!$"
Player_1_WIN_MESSAGE            DB      "Player 1 wins!$"
        
Ghost_PER_PLAYER                EQU     1
Ghost_Base                      LABEL   WORD
Ghost_00                        DW      1002h
Ghost_10                        DW      101Dh

;;; Player scores
Score_Base                      LABEL   BYTE
Score_Player_0                  DW      0000h
Score_Player_1                  DW      0000h
Score_TARGET                    EQU     100

;;; Level and Game State map
include map.asm
mapValue                        DB      ?

freezeFrameCount                EQU     60      
freezeCounter_Player0           DB      0
freezeCounter_Player1           DB      0

x2SpeedFrameCount               EQU     255     
x2SpeedCounter_Ghost0           DB      0
x2SpeedCounter_Ghost1           DB      0


;x2SpeedIndicator               DB	2	;  = 2 no doubleGS , = 0 player 0 hit doubleGS, = 1 player 1 hit doubleGS 
currentGhost                    DB	0

teleportIndicator               DB	2	; = 2 no teleport , = 0 player 0 hit teleport, = 1 player 1 hit teleport 


ghostDamage                     EQU     10
ghostDelay                      EQU     15
ghostCounter                    DB      ghostDelay

totalFrameCount                 DW      30 * 60
