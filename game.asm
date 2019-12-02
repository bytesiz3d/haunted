        ;; in num: Player number
mDrawPlayer     MACRO   playerNum
        mov     AX, Sprite_SIZE
        mov     SI, playerNum
        mul     SI
        mov     SI, AX          ;playerNum * Sprite_SIZE
        
        mov     BX, playerNum
        shl     BX, 1           ;playerNum * 2
        
        mov     AX, Player_Base[BX]
        add     SI, offset Sprite_Player_Base
        CALL    DrawSprite
ENDM    mDrawPlayer

        ;; in Pn, Gn: Player number, Ghost number
mDrawGhost      MACRO   Pn, Gn
        mov     AX, Ghost_Base[(Pn * Ghost_PER_PLAYER + Gn)*2]
        mov     SI, offset Sprite_Ghost_Base[Pn*Sprite_SIZE]
        CALL    DrawSprite
ENDM    mDrawGhost

mDrawEntities   MACRO
        mDrawPlayer     0
        mDrawPlayer     1

        mDrawGhost      0, 0
        mDrawGhost      1, 0
ENDM    mDrawEntities
;;; ----------------------------------------------------------------------------------
        .MODEL LARGE
        .STACK 64
;;; ----------------------------------------------------------------------------------
        .DATA
;;; DrawSprite variables
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
mg_playerOffset                 DW      ?
mg_ghostOffset                  DW      ?
;;; Sprites
include sprites.asm
        
;;; Entity positions (AH: Row, AL: Column)
newPosition                     DW      ?
currentPlayer                   DW      ?      
Player_Base                     LABEL   WORD
Player_0                        DW      1202h
Player_1                        DW      121Dh

Ghost_PER_PLAYER                EQU     1
Ghost_Base                      LABEL   WORD
Ghost_00                        DW      0602h
Ghost_10                        DW      061Dh

;;; Player scores
Score_Base                      LABEL   BYTE
Score_Player_0                  DW      0000h
Score_Player_1                  DW      0000h
Score_TARGET                    EQU     30

;;; Level and Game State map
freezeFrameCount                EQU     60      
ghostDelay                      EQU     15
ghostCounter                    DB      0
freezeCounter_Player0           DB      0
freezeCounter_Player1           DB      0
mapValue                        DB      ?
include map.asm
;; levelMap                        DB      Grid_COLUMNS*(Grid_ROWS/4) dup(SPRITE_ID_WALL)  ;Sprite Numbers
;;                                 DB      Grid_COLUMNS*(Grid_ROWS/4) dup(SPRITE_ID_POWERUP)
;;                                 DB      Grid_COLUMNS*(Grid_ROWS/4) dup(SPRITE_ID_COIN)
;;                                 DB      Grid_COLUMNS*(Grid_ROWS/4) dup(SPRITE_ID_EMPTY)
;;; ----------------------------------------------------------------------------------
        .CODE
MAIN    PROC    FAR

        mov     AX, @DATA
        mov     DS, AX

        ;; Clear the screen
        mov     AX, 4F02H
        mov     BX, 0105H
        INT     10H   
       
        CALL    DrawMap         

        mDrawPlayer 1
        mDrawPlayer 0

        mDrawGhost  0, 0
        mDrawGhost  1, 0
        
        JMP     FRAME_START


;;; ============================================================================================
        
PLAYER_0_WIN:   
PLAYER_1_WIN:   
        JMP     GAME_OVER

;;; ============================================================================================
        
MOVE_GHOSTS_FRAME_START:
        ;; 33 ms delay (CX:DX in microseconds)
        mov     CX, 0H
        mov     DX, 8235H
        mov     AH, 86H
        INT     15H
        
	;; Loop over all ghosts
        ;; TODO: Don't hardcode
	;; Exit if any ghost has the same position as the current player
        mov     AX, Player_0
        cmp	AX, Ghost_00
        JE      PLAYER_1_WIN
        cmp	AX, Ghost_10
        JE      PLAYER_1_WIN

        mov     AX, Player_1
        cmp	AX, Ghost_00
        JE      PLAYER_0_WIN
        cmp	AX, Ghost_10
        JE      PLAYER_0_WIN

        ;; Delay ghosts
        inc     ghostCounter
        cmp     ghostCounter, ghostDelay
        JB      FRAME_START

        mov     ghostCounter, 0

        mov     SI, offset Player_0
        mov     DI, offset Ghost_00
        CALL    MoveGhost

        mov     SI, offset Player_1
        mov     DI, offset Ghost_10
        CALL    MoveGhost

        mDrawGhost 0, 0
        mDrawGhost 1, 0

;;; ============================================================================================
        
FRAME_START:
        cmp     Score_Player_0, Score_TARGET
        JAE     PLAYER_0_WIN

        cmp     Score_Player_1, Score_TARGET
        JAE     PLAYER_1_WIN

        CMP     freezeCounter_Player0, 0           ;Check if player0 has been freezed
        JZ      SKIP_PLAYER_0_FREEZE
        DEC     freezeCounter_Player0
SKIP_PLAYER_0_FREEZE:   

        CMP     freezeCounter_Player1, 0           ;Check if player0 has been freezed
        JZ      SKIP_PLAYER_1_FREEZE
        DEC     freezeCounter_Player1
SKIP_PLAYER_1_FREEZE:   

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
        JMP     GAME_OVER

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

        cmp     mapValue, SPRITE_ID_POWERUP
        JE      HIT_POWERUP

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
        ;; TODO: Make powerup activation modular 
        ;; Freeze test
        CMP     currentPlayer, 0
        JNZ     FREEZE_PLAYER0

        MOV     freezeCounter_Player1, freezeFrameCount       ;Freeze player 1
        JMP     CLEAR_PIECE 

FREEZE_Player0:
        MOV     freezeCounter_Player0, freezeFrameCount       ;Freeze player 0    
        JMP     CLEAR_PIECE

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

        mov     SI, newPosition        ;Update position
        mov     DI, currentPlayer 
        SHL     DI, 1                  ;Word   
        mov     Player_Base[DI], SI    
        mDrawPlayer currentPlayer
        
        JMP      MOVE_GHOSTS_FRAME_START

;;; ============================================================================================

GAME_OVER:
EXIT:   
        mov     AX, 3h          ;Return to text mode
        INT     10h
        
        mov     AH, 2           ;GG
        mov     DL, 'G'
        mov     CX, 40
ggz:    INT     21h
        loop    ggz

        mov     AH, 0
        INT     16h
        
        mov     AX, 3h          ;Return to text mode
        INT     10h

        mov     AH, 4Ch         ;Exit the program
        INT     21h
MAIN    ENDP

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
        mov     BL, levelMap[BX]    ;Retrieve the cell value
        mov     BH, 0
        
        mov     AX, Sprite_SIZE ;To get the offset of the sprite
        MUL     BX              ;Multiply the cell value by SPRITE_SIZE
        
        ADD     AX, offset Sprite_Map_Base      ;Add the offset to the base
        mov     SI, AX                          ;Load the address of the sprite

        mov     AX, DI
        RET
RCtoMapSprite   ENDP

;;; ----------------------------------------------------------------------------------
;;; Ghost logic
include ghost.asm
        ;; in SI: Player position offset
        ;; in DI: Ghost position offset
        ;; MoveGhost
;;; ----------------------------------------------------------------------------------
END     MAIN
