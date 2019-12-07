include macros.asm
;;; ============================================================================================
        .MODEL LARGE
        .STACK 64

;;; ============================================================================================
        .DATA
include data.asm

;;; ============================================================================================
        .CODE
;;; Main menu and Game utilities
include menu.asm
        ;; Haunted_MainMenu
        ;; Open, Read, CloseFile
        ;; LoadBuffer
        
;;; ============================================================================================
;;; Scoreboard
include score.asm
        ;; Scoreboard
        ;; InttoString
        
;;; ============================================================================================
;;; Notification bar
include NB.asm
        ;; NotificationBar
        
;;; ============================================================================================
;;; Draw procedures and utility functions
include draw.asm
        ;; DrawMap
        ;; RCtoMapIndex
        ;; RCtoMapSprite

        ;; in AX: Square_Row, Square_Column
        ;; in SI: Sprite offset
        ;; DrawSprite

        ;; in CX: X position
        ;; in DX: Y position
        ;; in SI: Sprite offset
        ;; DrawSpriteXY

include animate.asm
        ;; in AX: New Position (R, C)
        ;; in BX: Old Position (R, C)
        ;; AnimatePlayer
;;; ============================================================================================
;;; Powerup utilities
include power.asm
        ;; CheckDoubleSpeed
        ;; Teleport
        ;; ReduceTimers
        
;;; ============================================================================================
;;; Ghost logic
include ghost.asm
        ;; in SI: Player position offset
        ;; in DI: Ghost position offset
        ;; in BX: Ghost sprite offset
        ;; MoveGhost
        ;; ShoveGhost
        ;; MoveGhostX2Checker
        ;; CheckGhostCollision

;;; ============================================================================================
MAIN    PROC    FAR

        mov     AX, @DATA
        mov     DS, AX
        mov     ES, AX

        ;; Teleport sprite
        LEA     DI, Sprite_Teleport
        LEA     SI, tpFilename
        MOV     CX, SPRITE_SIZE
        CALL    LoadBuffer

        ;; Double ghost speed sprite
        LEA     DI, Sprite_x2_Speed
        LEA     SI, x2Filename
        MOV     CX, SPRITE_SIZE
        CALL    LoadBuffer

MAIN_MENU:      
        ;; Clear the screen
        mov     AX, 4F02H
        mov     BX, 0105H
        INT     10H   
        CALL    Haunted_MainMenu

        ;; New Game
        CALL    ResetGame
        
        ;; Load map
        LEA     DI, levelMap
        MOV     SI, Word Ptr lvChosen
     ;; LEA     SI, lv1Filename
        MOV     CX, GRID_COLUMNS*GRID_ROWS 
        CALL    LoadBuffer
        CALL    DrawMap         

	MOV	DI, OFFSET NB_msg1+1
	MOV	CL, BYTE PTR NB_msg1
	MOV	CH, 0
	MOV	SI, CX
	CALL	NotificationBar

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

	mov	currentGhost,0
        mov     AX, Player_0
        mov     DI, offset Ghost_00
        mov     BX, offset Sprite_Ghost_0
        CALL    MoveGhost
	CALL	MoveGhostX2Checker

	mov	currentGhost,1
        mov     AX, Player_1
        mov     DI, offset Ghost_10
        mov     BX, offset Sprite_Ghost_1
        CALL    MoveGhost
	CALL	MoveGhostX2Checker

;;; ============================================================================================
FRAME_START:
        ;; 33 ms delay (CX:DX in microseconds)
        mov     CX, 0h
        mov     DX, 8235h
        mov     AH, 86h
        INT     15h

        call    Scoreboard
        
        DEC     totalFrameCount
        JNZ     HIT_GHOST?
        JMP     GAME_OVER

HIT_GHOST?:     
        call    CheckGhostCollision

        ;; Check if any player reached the score target
        cmp     Score_Player_0, Score_TARGET
        JAE     FAR PTR PLAYER_0_WIN

        cmp     Score_Player_1, Score_TARGET
        JAE     FAR PTR PLAYER_1_WIN

        ;; Reduce active powerup timers
        call    ReduceTimers

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
        JMP     MAIN_MENU 

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

        ;; Powerups
        cmp     mapValue, SPRITE_ID_FREEZE
        je      HIT_FREEZE

        cmp     mapValue, SPRITE_ID_BIG_COIN
        je      HIT_BIG_COIN

        cmp     mapValue, SPRITE_ID_DAMAGE
        je      HIT_DAMAGE

        cmp     mapValue, SPRITE_ID_TELEPORT
        je      HIT_TELEPORT

        cmp     mapValue, SPRITE_ID_X2_SPEED
        je      HIT_X2_SPEED

        JMP     MOVE_PLAYER

;;; ============================================================================================
HIT_WALL:
        JMP      MOVE_GHOSTS_FRAME_START     ;Jump back

;;; ______________________________________________
HIT_COIN:
        mov     SI, currentPlayer
        SHL     SI, 1                   ;Word   
        inc     Score_Base[SI]          
        JMP     CLEAR_PIECE

;;; ______________________________________________
HIT_FREEZE:
        CMP     currentPlayer, 0
        JNZ     FREEZE_PLAYER0

        MOV     freezeCounter_Player1, freezeFrameCount       ;Freeze player 1
        JMP     CLEAR_PIECE 

FREEZE_Player0:
        MOV     freezeCounter_Player0, freezeFrameCount       ;Freeze player 0    
        JMP     CLEAR_PIECE


;;; ______________________________________________
HIT_x2_SPEED:
	CMP     currentPlayer, 0
        JE      x2Speed_Ghost1
		
	MOV     x2SpeedCounter_Ghost0, x2SpeedFrameCount       ;Freeze player 0    
        JMP     CLEAR_PIECE

X2Speed_Ghost1:
        MOV     x2SpeedCounter_Ghost1, x2SpeedFrameCount           
        JMP     CLEAR_PIECE


;;; ______________________________________________
HIT_BIG_COIN:
        MOV     SI, currentPlayer
        SHL     SI, 1                  ;Word
        ADD     Score_Base[SI], 10
        JMP     CLEAR_PIECE

;;; ______________________________________________
HIT_DAMAGE:
        MOV     SI, currentPlayer
        XOR     SI, 1                  ;To get other player
        SHL     SI, 1                  ;Word
        CMP     Score_Base[SI], 10
        JL      CLEAR_PIECE

        SUB     Score_Base[SI], 10
        JMP     CLEAR_PIECE

;;; ______________________________________________
HIT_TELEPORT:
        MOV     AX,currentPlayer
        MOV     teleportIndicator,AL
        JMP	CLEAR_PIECE

;;; ============================================================================================
CLEAR_PIECE:
        mov     AX, newPosition         ;Clear the powerup
        CALL    RCtoMapIndex
        mov     levelMap[BX], 0        


MOVE_PLAYER:    
        ;; mov     SI, currentPlayer
        ;; SHL     SI, 1                   ;Word   
        ;; mov     AX, Player_Base[SI]     ;Erase the player and redraw the cell
        ;; CALL    RCtoMapSprite
        ;; CALL    DrawSprite

        ;; mov     SI, newPosition         ;Update position
        ;; mov     DI, currentPlayer 
        ;; SHL     DI, 1                   ;Word   
        ;; mov     Player_Base[DI], SI    

        mov     SI, currentPlayer
        SHL     SI, 1                   ;Word   
        mov     BX, Player_Base[SI]     ;Previous position
        mov     AX, newPosition
        CALL    AnimatePlayer
        
	CALL	Teleport
	JMP     MOVE_GHOSTS_FRAME_START

;;; ============================================================================================
GAME_OVER:
	MOV	DI, OFFSET NB_msg4+1
	MOV	CL, BYTE PTR NB_msg4
	MOV	CH, 0
	MOV	SI, CX
	CALL	NotificationBar

	
       ; mov     AX, 3h          ;Return to text mode
       ; INT     10h

       ; mov     AH, 9h
       ; INT     21h

        mov     AH, 0
        INT     16h
        cmp     AH, 01h         ;Wait for an ESC keypress
        JNE     GAME_OVER
        
        JMP     MAIN_MENU

EXIT:   
        mov     AX, 3h          ;Return to text mode
        INT     10h

        mov     AH, 4Ch         ;Exit the program
        INT     21h
MAIN    ENDP

;;; ============================================================================================
END     MAIN
