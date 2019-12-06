include macros.asm
;;; ============================================================================================
        .MODEL LARGE
        .STACK 64

;;; ============================================================================================
        .DATA
;;; Scoreboard variables
SB_string                       DB      5 dup('$') 
SB_ext                          DB      "'s score: " 
SB_line                         DB      128 dup('_') 
SB_space                        DB      5(32)

;;; Haunted_MainMenu variables
HauntedWidth                    EQU     320
HauntedHeight                   EQU     89
HauntedFilename                 DB      "h.bin", 0
HauntedFilehandle               DW      ?
HauntedData                     DB      HauntedWidth*HauntedHeight dup(0)
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
Score_TARGET                    EQU     24

;;; Level and Game State map
include map.asm
mapValue                        DB      ?

freezeFrameCount                EQU     60      
freezeCounter_Player0           DB      0
freezeCounter_Player1           DB      0

doubleSpeedFrameCount          EQU     255     
doubleSpeedCounter_Ghost0      DB      255
doubleSpeedCounter_Ghost1      DB      0


;doubleSpeedIndicator			DB		2	;  = 2 no doubleGS , = 0 player 0 hit doubleGS, = 1 player 1 hit doubleGS 
currentGhost					DB		0

teleportIndicator				DB		2	;  = 2 no teleport , = 0 player 0 hit teleport, = 1 player 1 hit teleport 


ghostDamage                     EQU     10
ghostDelay                      EQU     15
ghostCounter                    DB      ghostDelay

totalFrameCount                 DW      30 * 60

;;; ============================================================================================
        .CODE
;;; Main menu
include menu.asm
        ;; Haunted_MainMenu
        
;;; ============================================================================================
;;; Scoreboard
include score.asm
        ;; Scoreboard
        ;; InttoString
        
;;; ============================================================================================
;;; Draw procedures and utility functions
include draw.asm
        ;; in AX: Square_Row, Square_Column
        ;; in SI: Sprite offset
        ;; DrawSprite
        ;; DrawMap

        
        ;; in AH: Row, AL: Column
        ;; out BX: Map index
        ;; out DI: Row, Column
RCtoMapIndex    PROC    NEAR
        mov     DI, AX

        mov     CL, AL
        mov     CH, 0

        mov     AL, 0
        XCHG    AH, AL

        mov     BX, Grid_COLUMNS
        MUL     BX
        ADD     AX, CX

        mov     BX, AX
        RET
RCtoMapIndex    ENDP

        ;; in AH: Row, AL: Column
        ;; Out SI: Map Sprite offset
RCtoMapSprite   PROC     NEAR
        CALL    RCtoMapIndex
        mov     BL, levelMap[BX]        ;Retrieve the cell value
        mov     BH, 0
        
        mov     AX, Sprite_SIZE ;To get the offset of the sprite
        MUL     BX              ;Multiply the cell value by SPRITE_SIZE
        
        ADD     AX, offset Sprite_Map_Base      ;Add the offset to the base
        mov     SI, AX                          ;Load the address of the sprite

        mov     AX, DI
        RET
RCtoMapSprite   ENDP

Teleport   PROC     NEAR

		CMP		teleportIndicator,2
		JE 		EndTeleport
		
		
		CMP		teleportIndicator,1
		
		JE		teleport_player0
		mov		teleportIndicator,2
        mov     AX, Player_1		
        CALL    RCtoMapSprite
        CALL    DrawSprite
		mov		newPosition,021DH
        mov     SI, newPosition         ;Update position
        mov     Player_1, SI    
		jmp		EndTeleport
		
teleport_player0:
		mov		teleportIndicator,2		
		mov     AX, Player_0		
        CALL    RCtoMapSprite
        CALL    DrawSprite
		mov		newPosition,0202H
        mov     SI, newPosition         ;Update position
        mov     Player_0, SI    
		
EndTeleport:
        RET
Teleport   ENDP



;;; ============================================================================================
;;; Ghost logic
include ghost.asm
        ;; in SI: Player position offset
        ;; in DI: Ghost position offset
        ;; in BX: Ghost sprite offset
        ;; MoveGhost

;;; ============================================================================================
MAIN    PROC    FAR

        mov     AX, @DATA
        mov     DS, AX
        mov     ES, AX

        ;; Clear the screen
        mov     AX, 4F02H
        mov     BX, 0105H
        INT     10H   
       
        CALL    Haunted_MainMenu
        CALL    DrawMap         

        mDrawEntities
        
        JMP     FRAME_START

;;; ============================================================================================
MOVE_GHOSTS_FRAME_START:
        mDrawPlayer 0
        mDrawPlayer 1

        ;; Delay ghosts
        dec     ghostCounter
        JNZ     FRAME_START

        mov     ghostCounter, ghostDelay

		mov		currentGhost,0
        mov     AX, Player_0
        mov     DI, offset Ghost_00
        mov     BX, offset Sprite_Ghost_0
        CALL    MoveGhost
		CALL	MoveGhost2XChecker

		mov		currentGhost,1
        mov     AX, Player_1
        mov     DI, offset Ghost_10
        mov     BX, offset Sprite_Ghost_1
        CALL    MoveGhost

		CALL	MoveGhost2XChecker

;;; ============================================================================================
FRAME_START:
        ;; 33 ms delay (CX:DX in microseconds)
        mov     CX, 0h
        mov     DX, 8235h
        mov     AH, 86h
        INT     15h

        call    Scoreboard
        
        DEC     totalFrameCount
        JNZ     HIT_GHOST
        JMP     EXIT

HIT_GHOST:     
        ;; Loop over all ghosts
        ;; TODO: Don't hardcode
        ;; Reduce the player's score by value if any ghost hit them
        ;; Player 0:
        mov     AX, Player_0
        cmp     AX, Ghost_00
        JE      PLAYER_0_HIT_GHOST
        cmp     AX, Ghost_10
        JE      PLAYER_0_HIT_GHOST
        JMP     END_PLAYER_0_HIT_GHOST

PLAYER_0_HIT_GHOST:
        mov     DI, offset Ghost_00
        mov     BX, offset Sprite_Ghost_0
        mov		currentGhost,0
		CALL    ShoveGhost

        mov     DI, offset Ghost_00
        mov     BX, offset Sprite_Ghost_0
        CALL    ShoveGhost

        SUB     Score_Player_0, ghostDamage
        CMP     Score_Player_0, 0
        JG      END_PLAYER_0_HIT_GHOST
        MOV     Score_Player_0, 0
END_PLAYER_0_HIT_GHOST:   

        ;; Player 1:
        mov     AX, Player_1
        cmp     AX, Ghost_00
        JE      PLAYER_1_HIT_GHOST
        cmp     AX, Ghost_10
        JE      PLAYER_1_HIT_GHOST
        JMP     END_PLAYER_1_HIT_GHOST

PLAYER_1_HIT_GHOST:
        mov     DI, offset Ghost_10
        mov     BX, offset Sprite_Ghost_1
		mov		currentGhost,1
        CALL    ShoveGhost

        mov     DI, offset Ghost_10
        mov     BX, offset Sprite_Ghost_1
        CALL    ShoveGhost

        SUB     Score_Player_1, ghostDamage
        CMP     Score_Player_1, 0
        JG      END_PLAYER_1_HIT_GHOST
        MOV     Score_Player_1, 0
END_PLAYER_1_HIT_GHOST:   

        ;; Check if any player reached the score target
        cmp     Score_Player_0, Score_TARGET
        JAE     FAR PTR PLAYER_0_WIN

        cmp     Score_Player_1, Score_TARGET
        JAE     FAR PTR PLAYER_1_WIN

        ;; Reduce active freeze timers
        CMP     freezeCounter_Player0, 0           
        JZ      END_PLAYER_0_FREEZE
        DEC     freezeCounter_Player0
END_PLAYER_0_FREEZE:   

        CMP     freezeCounter_Player1, 0           
        JZ      END_PLAYER_1_FREEZE
        DEC     freezeCounter_Player1
END_PLAYER_1_FREEZE:   

        ;; Reduce active double ghost speed timers
        CMP     doubleSpeedCounter_Ghost0, 0           
        JZ      END_GHOST_0_DOUBLESPEED
        DEC     doubleSpeedCounter_Ghost0
END_GHOST_0_DOUBLESPEED:   

        CMP     doubleSpeedCounter_Ghost1, 0           
        JZ      END_GHOST_1_DOUBLESPEED
        DEC     doubleSpeedCounter_Ghost1
END_GHOST_1_DOUBLESPEED:   





;;; ============================================================================================
READ_INPUT:
        ;; Read input, jump back if no input was received
        mov     AH, 1
        INT     16H
        JNZ     MOVED?                 
        
        JMP     MOVE_GHOSTS_FRAME_START
MOVED?:
        mov     AH, 0
        INT     16h             ;Clear the key queue, keep the value in AH

        CMP     AH, 01H
        JNZ     SET_PLAYER
        JMP     EXIT

SET_PLAYER:     
        CMP     AH, 40H
        JB      SET_PLAYER_0
        JMP     SET_PLAYER_1

SET_PLAYER_0:
        MOV     currentPlayer, 0
        CMP     freezeCounter_Player0, 0           ;Check if player0 has been freezed
        JZ      GET_NEW_POS

        JMP     MOVE_GHOSTS_FRAME_START

SET_PLAYER_1:
        MOV     currentPlayer, 1
        CMP     freezeCounter_Player1, 0           ;Check if player1 has been freezed
        JZ      GET_NEW_POS

        JMP     MOVE_GHOSTS_FRAME_START

;;; ============================================================================================
PLAYER_0_WIN:   
        MOV     DX, offset player_0_win_message
        JMP     GAME_OVER
PLAYER_1_WIN:   
        MOV     DX, offset player_1_win_message
        JMP     GAME_OVER

;;; ============================================================================================
GET_NEW_POS:    
        ;; Get the new position
        mov     SI, currentPlayer
        SHL     SI, 1           ;Word
        mov     DI, Player_Base[SI]
        mov     newPosition, DI

        CMP     AH, 48H
        JE      IS_UP
        CMP     AH, 11h         ;W
        JE      IS_UP

        CMP     AH, 50H
        JE      IS_DOWN
        CMP     AH, 1Fh         ;S
        JE      IS_DOWN

        CMP     AH, 4DH
        JE      IS_RIGHT
        CMP     AH, 20h         ;D
        JE      IS_RIGHT
        
        CMP     AH, 4BH
        JE      IS_LEFT
        CMP     AH, 1Eh         ;A
        JE      IS_LEFT

        JMP     MOVE_GHOSTS_FRAME_START

;;; ============================================================================================
IS_UP:
        SUB     newPosition, 0100h
        JMP     TEST_NEW_POSITION

IS_DOWN:
        ADD     newPosition, 0100h
        JMP     TEST_NEW_POSITION

IS_RIGHT:
        ADD     newPosition, 0001h
        JMP     TEST_NEW_POSITION

IS_LEFT:
        SUB     newPosition, 0001h
        JMP     TEST_NEW_POSITION

;;; ============================================================================================
TEST_NEW_POSITION:      
        ;; Get the map value
        mov     AX, newPosition
        CALL    RCtoMapIndex
        mov     DL, levelMap[BX]
        mov     mapValue, DL

        cmp     mapValue, SPRITE_ID_WALL
        JE      HIT_WALL
        
        cmp     mapValue, SPRITE_ID_COIN
        JE      HIT_COIN

        cmp     mapValue, SPRITE_ID_FREEZE
        je      HIT_FREEZE

        cmp     mapValue, SPRITE_ID_BIG_COIN
        je      HIT_BIG_COIN

        JMP     MOVE_PLAYER

;;; ============================================================================================
HIT_WALL:
        JMP      MOVE_GHOSTS_FRAME_START     ;Jump back

HIT_COIN:
        mov     SI, currentPlayer
        SHL     SI, 1                   ;Word   
        inc     Score_Base[SI]          
        JMP     CLEAR_PIECE

HIT_POWERUP:
HIT_FREEZE:
        ;; TODO: Make powerup activation modular 
        ;; Freeze test
        CMP     currentPlayer, 0
        JNZ     FREEZE_PLAYER0

        MOV     freezeCounter_Player1, freezeFrameCount       ;Freeze player 1
        JMP     CLEAR_PIECE 

FREEZE_Player0:
        MOV     freezeCounter_Player0, freezeFrameCount       ;Freeze player 0    
        JMP     CLEAR_PIECE


HIT_DoubleGhostSpeed:
		CMP     currentPlayer, 0
        JE      DoubleSpeed_Ghost1
		
		MOV     doubleSpeedCounter_Ghost0, doubleSpeedFrameCount       ;Freeze player 0    
        JMP     CLEAR_PIECE

DoubleSpeed_Ghost1:
        MOV     doubleSpeedCounter_Ghost1, doubleSpeedFrameCount           
        JMP     CLEAR_PIECE


HIT_BIG_COIN:
        MOV     SI, currentPlayer
        SHL     SI, 1                  ;Word
        ADD     Score_Base[SI], 10
        JMP     CLEAR_PIECE

HIT_TELEPORT:
		MOV		AX,currentPlayer
		MOV		teleportIndicator,AL
		JMP		CLEAR_PIECE


;;; ============================================================================================
CLEAR_PIECE:
        mov     AX, newPosition         ;Clear the powerup
        CALL    RCtoMapIndex
        mov     levelMap[BX], 0        


MOVE_PLAYER:    
        mov     SI, currentPlayer
        SHL     SI, 1                   ;Word   
        mov     AX, Player_Base[SI]     ;Erase the player and redraw the cell
        CALL    RCtoMapSprite
        CALL    DrawSprite

        mov     SI, newPosition         ;Update position
        mov     DI, currentPlayer 
        SHL     DI, 1                   ;Word   
        mov     Player_Base[DI], SI    
        
		CALL	Teleport
		JMP      MOVE_GHOSTS_FRAME_START
;;; ============================================================================================
GAME_OVER:
        mov     AX, 3h          ;Return to text mode
        INT     10h

        mov     AH, 9h
        INT     21h

        mov     AH, 0
        INT     16h
        cmp     AH, 1Ch         ;Wait for an ENTER keypress
        JNE     GAME_OVER
        
EXIT:   
        mov     AX, 3h          ;Return to text mode
        INT     10h

        mov     AH, 4Ch         ;Exit the program
        INT     21h
MAIN    ENDP

;;; ============================================================================================
END     MAIN
