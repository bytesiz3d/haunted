        .MODEL SMALL
        .STACK 64
;;; ----------------------------------------------------------------------------------
        .DATA
;;; DrawSquare variables
Square_R                        DB      ?
Square_C                        DB      ?
Square_YF                       DW      ?
Square_XF                       DW      ?

Square_Side                     DB      32

;;; DrawGrid variables
Grid_WindowResolution_X         EQU     1024
Grid_WindowResolution_Y         EQU     768
Grid_COLUMNS                    EQU     32
Grid_ROWS                       EQU     24
Grid_CellResolution_X           DW      32	
Grid_CellResolution_Y           DW      32

;;; DrawMap variables
Map_RC                          DW      ?
Map_Idx                         DW      ?

;;; Sprites
SPRITE_SIZE                     EQU     32*32
Sprite_Base                     LABEL   BYTE
Sprite_BlackSquare              DB      SPRITE_SIZE dup(0) ;Sprite number 0
Sprite_BlueSquare               DB      SPRITE_SIZE dup(1) ;Sprite number 1
Sprite_RedSquare                DB      SPRITE_SIZE dup(4) ;Sprite number 2, etc..
Sprite_WhiteSquare              DB      SPRITE_SIZE dup(15)
Sprite_GreenSquare              DB      SPRITE_SIZE dup(47)
Sprite_OrangeSquare             DB      SPRITE_SIZE dup(43)

;;; Entity positions (AH: Row, AL: Column)
Player0                         DW      1200h

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
        ;; CALL    DrawGrid
        
        MOV     AX, Player0
        MOV     SI, offset Sprite_GreenSquare
        CALL    DrawSquare

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

        MOV     AX, Player0        ;Erase the player and redraw the cell
        CALL    RCtoSpriteOffset
        CALL    DrawSquare
        
        SUB     Player0, 0100h
        JMP     UPDATE_SQUARE

IS_DOWN:
        CMP     AH, 50H
        JNE     IS_RIGHT

        MOV     AX, Player0        ;Erase the player and redraw the cell
        CALL    RCtoSpriteOffset
        CALL    DrawSquare

        ADD     Player0, 0100h
        JMP     UPDATE_SQUARE

IS_RIGHT:
        CMP     AH, 4DH
        JNE     IS_LEFT

        MOV     AX, Player0        ;Erase the player and redraw the cell
        CALL    RCtoSpriteOffset
        CALL    DrawSquare
         
        ADD     Player0, 0001h
        JMP     UPDATE_SQUARE

IS_LEFT:
        CMP     AH, 4BH
        JNE     IS_EXIT

        MOV     AX, Player0        ;Erase the player and redraw the cell
        CALL    RCtoSpriteOffset
        CALL    DrawSquare
 
        SUB     Player0, 0001h
        JMP     UPDATE_SQUARE

;;; ----------------------------------------------------------------------------------

UPDATE_SQUARE:   
        MOV     AH, 0
        INT     16H

        MOV     AX, Player0        ;Draw the player at the updated position
        MOV     SI, offset Sprite_GreenSquare
        CALL    DrawSquare

        JMP     INPUT_LOOP

EXIT:   
        MOV     AX, 3H          ;Return to text mode
        INT     10H
        
        MOV     AH, 4CH         ;Exit the program
        INT     21H
MAIN    ENDP
;;; ----------------------------------------------------------------------------------
        ;; in AX: Square_Row, Square_Column
        ;; in SI: Sprite offset
DrawSquare     PROC    NEAR

        MOV     Square_R, AH
        MOV     Square_C, AL

        MOV     BH, 0
        MOV     BL, Square_Side
        ;; Start X
        MOV     AL, Square_C
        CBW
        MUL     BL
        MOV     CX, AX
        
        ;; End X
        MOV     Square_XF, CX
        ADD     Square_XF, BX
        
        ;; Start Y
        MOV     AL, Square_R
        CBW
        MUL     BL
        MOV     DX, AX
        
        ;; End Y
        MOV     Square_YF, DX
        ADD     Square_YF, BX

DRAW_LOOP:
        MOV     AH, 0CH
        MOV     AL, [SI]
        INT     10H             ;Draw

        INC     CX
        INC     SI              ;Increment color index
        CMP     CX, Square_XF   ;Finished row
        JB      DRAW_LOOP
        
        MOV     AL, Square_C
        CBW
        MUL     Square_Side

        MOV     CX, AX          ;Start X

        INC     DX
        CMP     DX, Square_YF   ;Finished all rows
        JB      DRAW_LOOP       
        
        RET
DrawSquare     ENDP
;;; ----------------------------------------------------------------------------------
DrawGrid        PROC
        ;; MOV     AX, Grid_WindowResolution_X
        ;; MOV     DX, 0
        ;; MOV     CX, Grid_COLUMNS
        ;; DIV     CX
        ;; MOV     Grid_CellResolution_X, AX


        ;; MOV     AX, Grid_WindowResolution_Y
        ;; MOV     DX, 0
        ;; MOV     CX, Grid_ROWS
        ;; DIV     CX
        ;; MOV     Grid_CellResolution_Y, AX
        
        MOV     AL, 5
        MOV     AH, 0ch

        MOV     CX, Grid_CellResolution_X
	
COLUMNLOOP1:
        MOV     DX, 0
	
COLUMNLOOP2:
        INT     10H
        INC     DX
        CMP     DX, Grid_WindowResolution_Y
        JL      COLUMNLOOP2
        
        ADD     CX, Grid_CellResolution_X
        CMP     CX, Grid_WindowResolution_X
        JL      COLUMNLOOP1
        
        MOV     DX, Grid_CellResolution_Y
	
ROWLOOP1:
        MOV     CX, 0
	
ROWLOOP2:
        INT     10H
        INC     CX
        CMP     CX, Grid_WindowResolution_X
        JL      ROWLOOP2
        
        ADD     DX, Grid_CellResolution_Y
        CMP     DX, Grid_WindowResolution_Y
        JL      ROWLOOP1
        
        RET 

DrawGrid        ENDP
;;; ----------------------------------------------------------------------------------
DrawMap         PROC

        MOV     Map_Idx, 0000h  ;Current cell index
        MOV     Map_RC, 0000h   ;H: Row, L: Column
CELL_LOOP:      
        MOV     AX, Map_RC      ;Pass the current Row, Column
        CALL    RCtoSpriteOffset
        CALL    DrawSquare

        INC     Map_Idx

        INC     byte ptr Map_RC[0]      ;Increment the column index
        CMP     byte ptr Map_RC[0], Grid_COLUMNS
        JB      SKIP_CR_ADJUST

        MOV     byte ptr Map_RC[0], 0h  ;Reset the column index
        INC     byte ptr Map_RC[1]      ;Increment the row index

SKIP_CR_ADJUST:
        CMP     byte ptr Map_RC[1], Grid_ROWS
        JB      CELL_LOOP

        RET
DrawMap         ENDP
;;; ----------------------------------------------------------------------------------
        ;; in AH: Row, AL: Column
        ;; Out SI: Sprite offset
RCtoSpriteOffset       PROC
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
        
        MOV     AX, SPRITE_SIZE ;To get the offset of the sprite
        MUL     BX              ;Multiply the cell value by SPRITE_SIZE
        
        ADD     AX, offset Sprite_Base  ;Add the offset to the base
        MOV     SI, AX                  ;Load the address of the sprite

        MOV     AX, DI
        RET
RCtoSpriteOffset        ENDP
;;; ----------------------------------------------------------------------------------
END     MAIN
