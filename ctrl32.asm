        .MODEL SMALL
        .STACK 64

        .DATA
sqX     dw      0
sqY     dw      0
side    dw      32
color   dw      15h
        
        .CODE
MAIN    PROC    FAR

        MOV     AX, @DATA
        MOV     DS, AX

        CALL    DRAW_SQUARE

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
        DEC     sqY

        JMP     MOVE_SQUARE

IS_DOWN:
        CMP     AH, 50H
        JNE     IS_RIGHT
        INC     sqY

        JMP     MOVE_SQUARE

IS_RIGHT:
        CMP     AH, 4DH
        JNE     IS_LEFT
        INC     sqX

        JMP     MOVE_SQUARE

IS_LEFT:
        CMP     AH, 4BH
        JNE     IS_EXIT
        DEC     sqX

MOVE_SQUARE:   
        MOV     AH, 0
        INT     16H
        CALL    DRAW_SQUARE

        JMP     INPUT_LOOP

EXIT:   
        MOV     AX, 3H          ;Return to text mode
        INT     10H
        
        MOV     AH, 4CH         ;Exit the program
        INT     21H
MAIN    ENDP
;;; ------------------------------------------
DRAW_SQUARE     PROC    NEAR
        inc     color
        
        ;; Clear the screen
        MOV     AX, 4F02H
        MOV     BX, 0105H
        INT     10H
        
        ;; Start X
        MOV     AX, sqX
        MUL     side
        MOV     CX, AX

        ;; End X
        MOV     SI, CX
        ADD     SI, side

        ;; Start Y
        MOV     AX, sqY
        MUL     side
        MOV     BX, AX

        ;; End Y
        MOV     DI, BX
        ADD     DI, side

DRAW_LOOP:
        MOV     AH, 0CH
        MOV     AL, color
        MOV     DX, BX
        INT     10H             ;Draw

        INC     CX
        CMP     CX, SI          ;Finished row
        JB      DRAW_LOOP
        
        MOV     AX, sqX
        MUL     side
        MOV     CX, AX          ;Start X

        INC     BX
        CMP     BX, DI          ;Finished all rows
        JB      DRAW_LOOP       
        
        RET
DRAW_SQUARE     ENDP
;;; ------------------------------------------
END     MAIN
