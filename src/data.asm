;;; Binary files 
HauntedFilename                 DB      "../bin/haunted", 0
tpFilename                      DB      "../bin/teleport", 0
x2Filename                      DB      "../bin/x2speed", 0
lv1Filename                     DB      "../bin/lv1", 0
lv2Filename                     DB      "../bin/lv2", 0              
lvChosen                        DW      ?   

;;; Serial communication variables
localPlayer                     DB      ?
otherPlayer                     DB      ?
IG_counter                      DW      ?
IG_inputData                    DW      5 dup(?)
frameMove                       DB      ?

;;;; Chatting variables
Value_S							db ?
Value_R 						db ?
point    						dw 0D00h
point2   						dw 0100h

;;; Scoreboard variables
SB_string                       DB      5 dup('$') 
SB_ext                          DB      "'s score: " 
SB_line                         DB      128 dup('_')  ;for score & notification
SB_space                        DB      128(32),'$'       ;for score & notification

;;; Notification bar
NB_msg1                         DB      26, "Press ENTER to start game."
NB_msg2                         DB      41, "Press ESC to Exit game. First to 48 wins."
NB_msg3                         DB      53, "GAME OVER Press Enter to go to Level 2 or ESC to Exit"
NB_msg4                         DB      27, "GAME OVER Press ESC to Exit"

;;; AnimatePlayer variables
ap_newPosition                  DW      ?
ap_oldPosition                  DW      ?
ap_currentPosition              DD      ?
ap_Step_X                       DW      ?
ap_Step_Y                       DW      ?

;;; RandomRC variables
rrc_seed                        DW      ?        

;;; Haunted_MainMenu variables
HauntedWidth                    EQU     320
HauntedHeight                   EQU     89
HauntedData                     DB      HauntedWidth*HauntedHeight dup(0)
fileHandle                      DW      ?
p1Name                          DB      20, ?, 22 dup("$")
p2Name                          DB      20, ?, 22 dup("$")
;p1Name                          DB      "Ahmed:$"
;p2Name                          DB      "Ali:$"
newGame                         DB      0, 0, 0, "NEW GAME", 0, 0, 0
quit                            DB      0, 0, 0, "QUIT", 0, 0, 0
chatting 						DB 		30,"For Chatting Mode Press ==> F1"			
playerName                      DB      "Player$", " Name: $"                 
choose_msg                      DB      18, "Choose Your level:"
level1_msg                      DB      14, "Level 1 ==> F1"   
level2_msg                      DB      14, "Level 2 ==> F2"             
SelectMode						DB 		0                  
;; DrawSprite variables
Square_X                        LABEL   WORD    ;DrawSpriteXY
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

;;; CheckGhostCollision variables
cgc_ghostPositionOffset         DW      ?
cgc_ghostSpriteOffset           DW      ?

;;; Sprites
include sprites.asm
        
;;; Victory messages
Player_0_WIN_MESSAGE            DB      "Player 1 wins!$"
Player_1_WIN_MESSAGE            DB      "Player 2 wins!$"

;;; Entity positions (AH: Row, AL: Column)
newPosition                     DW      ?
currentPlayer                   DW      ?      
Player_Base                     LABEL   WORD
Player_0                        DW      ?
Player_1                        DW      ?
        
Ghost_PER_PLAYER                EQU     1
Ghost_Base                      LABEL   WORD
Ghost_00                        DW      ?
Ghost_10                        DW      ?

;;; Ghost controls
ghostDelay                      EQU     16
;; ghostDelay                      EQU     0FFh
ghostDamage                     EQU     10
ghostCounter                    DB      ghostDelay

;;; Player scores
Score_Base                      LABEL   BYTE
Score_Player_0                  DW      0000h
Score_Player_1                  DW      0000h
Score_TARGET                    EQU     48

;;; Level map and Game State
include map.asm
;; totalFrameCount                 DW      30 * 60
totalFrameCount                 DW      0FFFFh
mapValue                        DB      ?

freezeFrameCount                EQU     45      
freezeCounter_BASE              LABEL   BYTE
freezeCounter_Player0           DB      0
freezeCounter_Player1           DB      0

x2SpeedFrameCount               EQU     255     
x2SpeedCounter_Ghost0           DB      0
x2SpeedCounter_Ghost1           DB      0

teleportIndicator               DB	2	; = 2 no teleport , = 0 player 0 hit teleport, = 1 player 1 hit teleport 
;x2SpeedIndicator               DB	2	;  = 2 no doubleGS , = 0 player 0 hit doubleGS, = 1 player 1 hit doubleGS 
currentGhost                    DB	0


