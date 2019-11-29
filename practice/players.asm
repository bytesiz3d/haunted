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
Player_Base                     LABEL   WORD
Player_0                        DW      1200h
Player1                         DW      121Fh

Ghost_PER_PLAYER                EQU     1
Ghost_Base                      LABEL   WORD
Ghost_00                        DW      0000h
Ghost_10                        DW      001Fh

;;; Level and Game State map
levelMap                        DB      Grid_COLUMNS*(Grid_ROWS/4) dup(0)
                                DB      Grid_COLUMNS*(Grid_ROWS/4) dup(2)
                                DB      Grid_COLUMNS*(Grid_ROWS/4) dup(5)
                                DB      Grid_COLUMNS*(Grid_ROWS/4) dup(0)
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

INPUT_LOOP:
        MOV     AH, 1
        INT     16H

        JZ      INPUT_LOOP

IS_EXIT:
        CMP     AH, 01H
        JE      EXIT

IS_UP:
        CMP     AH, 48H
        JNE     IS_DOWN

        MOV     AX, Player_0        ;Erase the player and redraw the cell
        CALL    RCtoMapSprite
        CALL    DrawSprite
        
        SUB     Player_0, 0100h
        JMP     UPDATE_SQUARE

IS_DOWN:
        CMP     AH, 50H
        JNE     IS_RIGHT

        MOV     AX, Player_0        ;Erase the player and redraw the cell
        CALL    RCtoMapSprite
        CALL    DrawSprite

        ADD     Player_0, 0100h
        JMP     UPDATE_SQUARE

IS_RIGHT:
        CMP     AH, 4DH
        JNE     IS_LEFT

        MOV     AX, Player_0        ;Erase the player and redraw the cell
        CALL    RCtoMapSprite
        CALL    DrawSprite
         
        ADD     Player_0, 0001h
        JMP     UPDATE_SQUARE

IS_LEFT:
        CMP     AH, 4BH
        JNE     IS_EXIT

        MOV     AX, Player_0        ;Erase the player and redraw the cell
        CALL    RCtoMapSprite
        CALL    DrawSprite
 
        SUB     Player_0, 0001h
        JMP     UPDATE_SQUARE

;;; ----------------------------------------------------------------------------------

UPDATE_SQUARE:   
        MOV     AH, 0
        INT     16H

        mDrawPlayer 0
        JMP     INPUT_LOOP

EXIT:   
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
        ;; Out SI: Map Sprite offset
RCtoMapSprite       PROC     NEAR
        MOV     DI, AX

        MOV     CL, AL
        MOV     CH, 0
        
        MOV     AL, 0
        XCHG    AH, AL          ;Prepare the row index for multiplication

        MOV     BX, Grid_COLUMNS
        MUL     BX
        ADD     AX, CX          ;Store the cell index in AX

        MOV     BX, AX
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
