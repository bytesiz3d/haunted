        ;; in AX: Player position       
        ;; in DI: Ghost position offset
        ;; in BX: Ghost sprite offset
MoveGhost       PROC    NEAR
        mov     mg_ghostOffset, DI
        mov     mg_ghostSpriteOffset, BX
        
        ;; Calculate the pair
        ;; AX:  Player
        mov     BX, [DI] 
        mov     mg_nextStep, 0000h

        ;; Compare Rows
        cmp     AH, BH
        ja      SET_R_1         ;Player below ghost
        jb      SET_R_FF        ;Player above ghost
        jmp     SET_R_0

SET_R_1:
        mov     mg_nextStep_R, 1
        jmp     SET_R_0
SET_R_FF:
        mov     mg_nextStep_R, 0FFh
        jmp     SET_R_0
SET_R_0:

        ;; Compare Columns
        cmp     AL, BL
        ja      SET_C_1         ;Player right of ghost
        jb      SET_C_FF        ;Player left of ghost
        jmp     SET_C_0

SET_C_1:
        mov     mg_nextStep_C, 1
        jmp     SET_C_0
SET_C_FF:
        mov     mg_nextStep_C, 0FFh
        jmp     SET_C_0
SET_C_0:

        ;; Store the calculated pair
        mov     AX, mg_nextStep
        mov     mg_Step0, AX

ROW_VALID?:
        cmp     mg_nextStep_R, 0
        jz      COLUMN_VALID?   ;Skip

        ;; Check if the row move is valid
        mov     BX, mg_ghostOffset 
        mov     BX, [BX]
        add     BH, mg_nextStep_R

        ;; Get the map value of the suggested move
        MOV     AX, BX
        CALL    RCtoMapIndex
        MOV     DL, levelMap[BX]
        MOV     mapValue, DL

        cmp     mapValue, SPRITE_ID_WALL
        jne     COLUMN_VALID?
        
        mov     mg_nextStep_R, 0
COLUMN_VALID?:
        cmp     mg_nextStep_C, 0
        jz      EVALUATE_STEPS  ;Skip

        ;; Check if the column move is valid
        mov     BX, mg_ghostOffset 
        mov     BX, [BX]
        add     BL, mg_nextStep_C

        ;; Get the map value of the suggested move
        MOV     AX, BX
        CALL    RCtoMapIndex
        MOV     DL, levelMap[BX]
        MOV     mapValue, DL

        cmp     mapValue, SPRITE_ID_WALL
        jne     EVALUATE_STEPS

        mov     mg_nextStep_C, 0
EVALUATE_STEPS:
        mov     AL, mg_nextStep_R
        and     AL, mg_nextStep_C
        jnz     RANDOMIZE

        mov     AL, mg_nextStep_R
        or      AL, mg_nextStep_C
        jnz     SET_STEP

        ;; Invert (R, C)
        mov     AX, mg_Step0
        neg     AH
        neg     AL
        mov     mg_nextStep, AX

RANDOMIZE:
        ;; Separating the two moves
        mov     AX, mg_nextStep
        mov     mg_Step0, 0
        mov     mg_Step1, 0
        add     byte ptr mg_Step0, AL
        add     byte ptr mg_Step1[1], AH
        
        ;; Get system clock tick count
        ;; Exchange the two moves n times (n = lower byte of clock tick count)
        MOV     AX, 0
        INT     1Ah
        MOV     CL, DL
RANDOMIZE_LOOP:
        MOV     AX, mg_Step0
        XCHG    mg_Step1, AX
        XCHG    mg_Step0, AX
        LOOP    RANDOMIZE_LOOP
        ;; Set the desired move
        mov     AX, mg_Step0
        mov     mg_nextStep, AX

SET_STEP:
        ;; Erase ghost, redraw cell
        mov     BX, mg_ghostOffset
        MOV     AX, [BX]        
        CALL    RCtoMapSprite
        CALL    DrawSprite

        ;; Update position
        mov     BX, mg_ghostOffset
        MOV     AX, [BX]
        add     AL, mg_nextStep_C
        add     AH, mg_nextStep_R
        mov     [BX], AX
        
        ;; Draw ghost
        mov     SI, mg_ghostSpriteOffset
        CALL    DrawSprite
        RET
        
MoveGhost       ENDP

;;; ====================================================================
        ;; in DI: Ghost position offset
        ;; in BX: Ghost sprite offset
ShoveGhost      PROC    NEAR
        MOV     AX, 0h
        CALL    MoveGhost        
        RET
ShoveGhost      ENDP
