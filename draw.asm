DrawSprite     PROC    NEAR
        MOV     Square_R, AH
        MOV     Square_C, AL

        MOV     BH, 0
        MOV     BL, Square_RES
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
        LODSB                   ;Load [SI] into AL, increment SI
        INT     10H             ;Draw

        INC     CX
        CMP     CX, Square_XF   
        JB      DRAW_LOOP
        ;; Finished row

        MOV     AL, Square_C
        CBW
        MUL     BL
        MOV     CX, AX          ;Start X

        INC     DX
        CMP     DX, Square_YF   
        JB      DRAW_LOOP       
        ;; Finished all rows
        
        RET
DrawSprite     ENDP

;;; ----------------------------------------------------------------------------------
DrawMap         PROC    NEAR
        MOV     Map_Idx, 0000h  ;Current cell index
        MOV     Map_RC, 0000h   ;H: Row, L: Column
CELL_LOOP:      
        MOV     AX, Map_RC      ;Pass the current Row, Column
        CALL    RCtoMapSprite
        CALL    DrawSprite

        INC     Map_Idx

        INC     Map_C           ;Increment the column index
        CMP     Map_C, Grid_COLUMNS
        JB      SKIP_CR_ADJUST

        MOV     Map_C, 0h       ;Reset the column index
        INC     Map_R           ;Increment the row index

SKIP_CR_ADJUST:
        CMP     Map_R, Grid_ROWS
        JB      CELL_LOOP

        RET
DrawMap         ENDP

