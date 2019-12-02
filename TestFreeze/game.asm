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
        call    DrawSprite
ENDM    mDrawPlayer

        ;; in Pn, Gn: Player number, Ghost number
mDrawGhost      MACRO   Pn, Gn
        mov     AX, Ghost_Base[(Pn * Ghost_PER_PLAYER + Gn)*2]
        mov     SI, offset Sprite_Ghost_Base[Pn*Sprite_SIZE]
        call    DrawSprite
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
Score_TARGET                    EQU     90

;;; Level and Game State map
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

        MOV     AX, @DATA
        MOV     DS, AX

        ;; Clear the screen
        MOV     AX, 4F02H
        MOV     BX, 0105H
        INT     10H   
       
        CALL    DrawMap         

        mDrawPlayer 1
        mDrawPlayer 0

        mDrawGhost  0, 0
        mDrawGhost  1, 0
        
        JMP     FRAME_START
MOVE_GHOSTS_FRAME_START:
        ;; 33 ms delay (CX:DX in microseconds)
        MOV     CX, 0H
        MOV     DX, 8235H
        MOV     AH, 86H
        INT     15H
        
        ;; Delay ghosts
        inc     ghostCounter
        cmp     ghostCounter, ghostDelay
        jb      FRAME_START

        mov     ghostCounter, 0

        MOV     SI, offset Player_0
        MOV     DI, offset Ghost_00
        call    MoveGhost

        MOV     SI, offset Player_1
        MOV     DI, offset Ghost_10
        call    MoveGhost

        mDrawGhost 0, 0
        mDrawGhost 1, 0
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
               
        JMP     READ_INPUT

PLAYER_0_WIN:
PLAYER_1_WIN:   
        JMP     GAME_OVER

READ_INPUT:
        ;; Read input, jump back if no input was received
        MOV     AH, 1
        INT     16H
        JZ      MOVE_GHOSTS_FRAME_START

        MOV     AH, 0
        INT     16h             ;Clear the key queue, keep the value in AH

MOVED?:
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

GET_NEW_POS:    
        ;; Get the new position
        MOV     SI, currentPlayer
        SHL     SI, 1           ;Word
        MOV     DI, Player_Base[SI]
        MOV     newPosition, DI

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

;;; ----------------------------------------------------------------------------------

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

;;; ----------------------------------------------------------------------------------

TEST_NEW_POSITION:      
        ;; Get the map value
        MOV     AX, newPosition
        CALL    RCtoMapIndex
        MOV     DL, levelMap[BX]
        MOV     mapValue, DL

        cmp     mapValue, SPRITE_ID_WALL
        je      HIT_WALL
        
        cmp     mapValue, SPRITE_ID_COIN
        je      HIT_COIN

        cmp     mapValue, SPRITE_ID_POWERUP
        je      HIT_POWERUP

        jmp     MOVE_PLAYER

;;; ----------------------------------------------------------------------------------

HIT_WALL:
        JMP      MOVE_GHOSTS_FRAME_START     ;Jump back

HIT_GHOST:
        ;; TODO: Ghost collision
        ;; JMP     GAME_OVER

HIT_COIN:
        mov     SI, currentPlayer
        SHL     SI, 1                   ;Word   
        inc     Score_Base[SI]          
        jmp     CLEAR_PIECE

HIT_POWERUP:
        ;; TODO: Activate Powerup
        ;; Freeze test
        CMP     currentPlayer, 0
        JNZ     FREEZE_PLAYER0

        MOV     freezeCounter_Player1, 50       ;Freeze player 1
        JMP     CLEAR_PIECE 

FREEZE_Player0:
        MOV     freezeCounter_Player0, 50       ;Freeze player 0    
        JMP     CLEAR_PIECE

;;; ----------------------------------------------------------------------------------
CLEAR_PIECE:
        MOV     AX, newPosition         ;Clear the powerup
        CALL    RCtoMapIndex
        MOV     levelMap[BX], 0        

MOVE_PLAYER:    
        mov     SI, currentPlayer
        SHL     SI, 1                   ;Word   
        mov     AX, Player_Base[SI]     ;Erase the player and redraw the cell
        CALL    RCtoMapSprite
        CALL    DrawSprite

        mov     SI, newPosition        ;Update position
        mov     DI, currentPlayer 
        SHL     DI, 1                   ;Word   
        mov     Player_Base[DI], SI    
        mDrawPlayer currentPlayer
        
        JMP      MOVE_GHOSTS_FRAME_START

;;; ----------------------------------------------------------------------------------
GAME_OVER:
EXIT:   
        MOV     AX, 3H          ;Return to text mode
        INT     10H
        
        mov     AH, 2           ;GG
        mov     dl, 'G'
        mov     cx, 40
ggz:    int     21h
        loop    ggz

        mov     AH, 0
        int     16h
        
        MOV     AX, 3H          ;Return to text mode
        INT     10H

        MOV     AH, 4CH         ;Exit the program
        INT     21H
MAIN    ENDP
;;; ----------------------------------------------------------------------------------
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
        MOV     DI, AX

        MOV     CL, AL
        MOV     CH, 0

        MOV     AL, 0
        XCHG    AH, AL

        MOV     BX, Grid_COLUMNS
        MUL     BX
        ADD     AX, CX

        MOV     BX, AX
        RET
RCtoMapIndex    ENDP

        ;; in AH: Row, AL: Column
        ;; Out SI: Map Sprite offset
RCtoMapSprite   PROC     NEAR
        call    RCtoMapIndex
        MOV     BL, levelMap[BX]    ;Retrieve the cell value
        MOV     BH, 0
        
        MOV     AX, Sprite_SIZE ;To get the offset of the sprite
        MUL     BX              ;Multiply the cell value by SPRITE_SIZE
        
        ADD     AX, offset Sprite_Map_Base      ;Add the offset to the base
        MOV     SI, AX                          ;Load the address of the sprite

        MOV     AX, DI
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
