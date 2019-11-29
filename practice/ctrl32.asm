        .MODEL SMALL
        .STACK 64
;;; ------------------------------------------------------
        .DATA
;;; DrawSquare variables
Square_R                        DB      0
Square_C                        DB      0
Square_YF                       DW      ?
Square_XF                       DW      ?

Square_Side                     DB      32

;;; DrawGrid variables
Grid_WindowResolution_X         EQU     1024
Grid_WindowResolution_Y         EQU     768
GRID_COLUMNS                    EQU     32
GRID_ROWS                       EQU     24  
Grid_CellResolution_X           DW      32	
Grid_CellResolution_Y           DW      32

;;; Sprites
SPRITE_SIZE                     EQU     32*32
Sprite_BlueSquare               DB      32 dup(32 dup(1))
Sprite_BlackSquare              DB      32 dup(32 dup(0))

;;; Entity positions (AH: Row, AL: Column)
Box0                         DW      0000h

;;; ------------------------------------------------------
        .CODE
MAIN    PROC    FAR

        MOV     AX, @DATA
        MOV     DS, AX

        ;; Clear the screen
        MOV     AX, 4F02H
        MOV     BX, 0105H
        INT     10H

        CALL    DrawGrid

        MOV     AX, Box0
        MOV     SI, offset Sprite_BlueSquare
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

        MOV     AX, Box0
        MOV     SI, offset Sprite_BlackSquare
        CALL    DrawSquare

        SUB     Box0, 0100h
        JMP     MOVE_SQUARE

IS_DOWN:
        CMP     AH, 50H
        JNE     IS_RIGHT

        MOV     AX, Box0
        MOV     SI, offset Sprite_BlackSquare
        CALL    DrawSquare

        ADD     Box0, 0100h
        JMP     MOVE_SQUARE

IS_RIGHT:
        CMP     AH, 4DH
        JNE     IS_LEFT

        MOV     AX, Box0
        MOV     SI, offset Sprite_BlackSquare
        CALL    DrawSquare

        ADD     Box0, 0001h
        JMP     MOVE_SQUARE

IS_LEFT:
        CMP     AH, 4BH
        JNE     IS_EXIT

        MOV     AX, Box0
        MOV     SI, offset Sprite_BlackSquare
        CALL    DrawSquare

        SUB     Box0, 0001h
        JMP     MOVE_SQUARE

;;; ------------------------------------------------------

MOVE_SQUARE:   
        MOV     AH, 0
        INT     16H
        MOV     SI, offset Sprite_BlueSquare
        MOV     AX, Box0
        CALL    DrawSquare
        
        JMP     INPUT_LOOP

EXIT:   
        MOV     AX, 3H          ;Return to text mode
        INT     10H
        
        MOV     AH, 4CH         ;Exit the program
        INT     21H

MAIN    ENDP
;;; ------------------------------------------------------
        ;; in SI: Sprite offset
        ;; in AX: Square_Row, Square_Column
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
        
        INC     CX              ;Padding the left side
        INC     DX              ;Padding the lower side

DRAW_LOOP:
        MOV     AH, 0CH
        MOV     AL, [SI]
        INT     10H             ;Draw

        INC     CX
        CMP     CX, Square_XF   ;Finished row
        INC     SI              ;Increment color index
        JB      DRAW_LOOP
        
        MOV     AL, Square_C
        CBW
        MUL     Square_Side

        MOV     CX, AX          ;Start X
        INC     CX              ;Padding the left Square_Side

        INC     DX
        CMP     DX, Square_YF   ;Finished all rows
        INC     SI
        JB      DRAW_LOOP       
        
        RET
DrawSquare     ENDP
;;; ------------------------------------------
DrawGrid        PROC
        ;; MOV     AX, Grid_WindowResolution_X
        ;; MOV     DX, 0
        ;; MOV     CX, GRID_COLUMNS
        ;; DIV     CX
        ;; MOV     Grid_CellResolution_X, AX


        ;; MOV     AX, Grid_WindowResolution_Y
        ;; MOV     DX, 0
        ;; MOV     CX, GRID_ROWS
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
;;; ------------------------------------------
END     MAIN
