;;; ============================================================================================
        ;; in AH: Row, AL: Column
        ;; out BX: Map index
        ;; out DI: Row, Column
RCtoMapIndex    PROC    NEAR
        mov     DI, AX

        mov     CL, AL
        mov     CH, 0           ;Column

        mov     AL, 0
        XCHG    AH, AL

        mov     BX, Grid_COLUMNS
        MUL     BX              ;Row * Grid_COLUMNS
        ADD     AX, CX          ; + Column

        mov     BX, AX
        RET
RCtoMapIndex    ENDP

;;; ============================================================================================
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

;;; ============================================================================================
        ;; in AX: Square_Row, Square_Column
        ;; in SI: Sprite offset
DrawSprite     PROC    NEAR
        MOV     Square_R, AH
        MOV     Square_C, AL

        MOV     BH, 0
        MOV     BL, Square_RES
        ;; Start X
        MOV     AL, Square_C    ;C * Square_RES --> C * Square_RES + Square_RES
        CBW
        MUL     BL
        MOV     CX, AX
        
        ;; End X
        MOV     Square_XF, CX
        ADD     Square_XF, BX
        
        ;; Start Y
        MOV     AL, Square_R    ;R * Square_RES --> R * Square_RES + Square_RES
        CBW
        MUL     BL
        MOV     DX, AX
        
        ;; End Y
        MOV     Square_YF, DX
        ADD     Square_YF, BX

DRAW_LOOP:
        MOV     AH, 0CH
        LODSB                   ;Load [SI] into AL, increment SI
	CALL	CheckDoubleSpeed
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

;;; ============================================================================================
        ;; in CX: X position
        ;; in DX: Y position
        ;; in SI: Sprite offset
DrawSpriteXY    PROC    NEAR
        mov     Square_X, CX

        MOV     BH, 0
        MOV     BL, Square_RES

        ;; End X
        MOV     Square_XF, CX
        ADD     Square_XF, BX
        
        ;; End Y
        MOV     Square_YF, DX
        ADD     Square_YF, BX

DRAW_LOOP_XY:
        MOV     AH, 0CH
        LODSB                   ;Load [SI] into AL, increment SI
        INT     10H             ;Draw

        INC     CX
        CMP     CX, Square_XF   
        JB      DRAW_LOOP_XY
        ;; Finished row

        mov     CX, Square_X
        INC     DX
        CMP     DX, Square_YF   
        JB      DRAW_LOOP_XY
        ;; Finished all rows
        
        RET
DrawSpriteXY    ENDP
;;; ============================================================================================
DrawMap         PROC    NEAR
        MOV     Map_RC, 0000h   ;H: Row, L: Column
CELL_LOOP:      
        MOV     AX, Map_RC      ;Pass the current Row, Column
        CALL    RCtoMapSprite
        CALL    DrawSprite

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
