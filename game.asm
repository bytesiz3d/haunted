        ;; in num: Player number
mDrawPlayer     MACRO   num
        mov     AX, Player_Base[num*2]
        mov     SI, offset Sprite_Player_Base[num*Sprite_SIZE]
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
        .MODEL MEDIUM
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
Map_Idx                         DW      ?

;;; Sprites
include sprites.asm
        
;;; Entity positions (AH: Row, AL: Column)
New_Position                    DW      ?
Player_Base                     LABEL   WORD
Player_0                        DW      1200h
Player1                         DW      121Fh

Ghost_PER_PLAYER                EQU     1
Ghost_Base                      LABEL   WORD
Ghost_00                        DW      0000h
Ghost_10                        DW      001Fh

;;; Player scores
Score_Base                      LABEL   BYTE
Score_Player_0                  DW      0000h
Score_Player_1                  DW      0000h
Score_TARGET                    EQU     12

;;; Level and Game State map
levelMap                        DB      Grid_COLUMNS*(Grid_ROWS/4) dup(SPRITE_ID_WALL)  ;Sprite Numbers
                                DB      Grid_COLUMNS*(Grid_ROWS/4) dup(SPRITE_ID_POWERUP)
                                DB      Grid_COLUMNS*(Grid_ROWS/4) dup(SPRITE_ID_COIN)
                                DB      Grid_COLUMNS*(Grid_ROWS/4) dup(SPRITE_ID_EMPTY)

;;; Current cell value
Map_Value                       DB      ?
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

        mDrawPlayer 0
        mDrawPlayer 1

        mDrawGhost  0, 0
        mDrawGhost  1, 0
        
FRAME_START:
        ;; TODO: Insert frame delay
        
        cmp     Score_Player_0, Score_TARGET
        JAE     GAME_OVER_INTER_JMP

        cmp     Score_Player_1, Score_TARGET
        JAE     GAME_OVER_INTER_JMP

        ;; call    MoveGhosts

        ;; Read input, jump back if no input was received
        MOV     AH, 1
        INT     16H
        JZ      FRAME_START

        MOV     AH, 0
        INT     16h             ;Clear the key queue, keep the value in AH

MOVED?:
        CMP     AH, 01H
        JE      GAME_OVER_INTER_JMP

        ;; Get the new position
        MOV     DI, Player_0
        MOV     New_Position, DI

        CMP     AH, 48H
        JE      IS_UP

        CMP     AH, 50H
        JE      IS_DOWN

        CMP     AH, 4DH
        JE      IS_RIGHT
        
        CMP     AH, 4BH
        JE      IS_LEFT

        JMP     FRAME_START

IS_UP:
        SUB     New_Position, 0100h
        JMP     TEST_NEW_POSITION

IS_DOWN:
        ADD     New_Position, 0100h
        JMP     TEST_NEW_POSITION

IS_RIGHT:
        ADD     New_Position, 0001h
        JMP     TEST_NEW_POSITION

IS_LEFT:
        SUB     New_Position, 0001h
        JMP     TEST_NEW_POSITION

;;; ----------------------------------------------------------------------------------
GAME_OVER_INTER_JMP:
        JMP     GAME_OVER
;;; ----------------------------------------------------------------------------------
TEST_NEW_POSITION:      
        ;; Get the map value
        MOV     AX, New_Position
        CALL    RCtoMapIndex
        MOV     DL, levelMap[BX]
        MOV     Map_Value, DL

        cmp     Map_Value, SPRITE_ID_WALL
        je      HIT_WALL
        
        cmp     Map_Value, SPRITE_ID_COIN
        je      HIT_COIN

        cmp     Map_Value, SPRITE_ID_POWERUP
        je      HIT_POWERUP

        jmp     MOVE_PLAYER

HIT_WALL:
        JMP     FRAME_START     ;Jump back

HIT_GHOST:
        ;; TODO: Ghost collision
        ;; JMP     GAME_OVER

HIT_COIN:
        inc     Score_Player_0          ;TODO: Add multiplier
        jmp     CLEAR_PIECE

HIT_POWERUP:
        ;; TODO: Activate Powerup
        jmp     CLEAR_PIECE 

;;; ----------------------------------------------------------------------------------
CLEAR_PIECE:
        MOV     AX, New_Position        ;Clear the powerup
        CALL    RCtoMapIndex
        MOV     levelMap[BX], 0        

MOVE_PLAYER:    
        mov     AX, Player_0            ;Erase the player and redraw the cell
        CALL    RCtoMapSprite
        CALL    DrawSprite

        mov     DI, New_Position        ;Update position
        mov     Player_0, DI    
        mDrawPlayer 0
        
        JMP     FRAME_START

;;; ----------------------------------------------------------------------------------
GAME_OVER:
EXIT:   
        MOV     AX, 3H          ;Return to text mode
        INT     10H
        
        mov     AH, 2           ;GG
        mov     dl, 'G'
        mov     cx, 20
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
;;; Draw procedures
include draw.asm
        ;; in AX: Square_Row, Square_Column
        ;; in SI: Sprite offset
        ;; DrawSprite
        
        ;; DrawMap
;;; ----------------------------------------------------------------------------------
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
RCtoMapSprite       PROC     NEAR
        call    RCtoMapIndex
        MOV     BL, levelMap[BX]    ;Retrieve the cell value
        MOV     BH, 0
        
        MOV     AX, Sprite_SIZE ;To get the offset of the sprite
        MUL     BX              ;Multiply the cell value by SPRITE_SIZE
        
        ADD     AX, offset Sprite_Map_Base      ;Add the offset to the base
        MOV     SI, AX                          ;Load the address of the sprite

        MOV     AX, DI
        RET
RCtoMapSprite        ENDP
;;; ----------------------------------------------------------------------------------
END     MAIN
