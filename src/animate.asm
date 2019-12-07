;;; ============================================================================================
        ;; in AX: New Position (R, C)
        ;; in BX: Old Position (R, C)
AnimatePlayer   PROC    NEAR
        mov     ap_newPosition, AX
        mov     ap_oldPosition, BX

        ;; Store old position in X, Y
        mov     AL, 32
        mul     BL
        mov     word ptr ap_currentPosition[0], AX ;X component

        mov     AL, 32
        mul     BH
        mov     word ptr ap_currentPosition[2], AX ;Y component

        mov     ap_Step_X, 0
        mov     ap_Step_Y, 0
        
        mov     AX, ap_newPosition
        sub     AX, ap_oldPosition      ;step = newPosition - oldPosition

        mov     CL, 3
        ;; Set animation step
        cmp     AL, 0   ;Column component
        jnz     ANIMATION_X_STEP
        cmp     AH, 0   ;Row component
        jnz     ANIMATION_Y_STEP
        JMP     END_ANIMATION
        
ANIMATION_X_STEP:
        mov     AH, 0
        CBW
        add     ap_Step_X, AX
        shl     ap_Step_X, CL
        jmp     ANIMATION_LOOP
ANIMATION_Y_STEP:
        mov     AL, AH
        CBW
        add     ap_Step_Y, AX
        shl     ap_Step_Y, CL
        jmp     ANIMATION_LOOP

ANIMATION_LOOP:
        ;; 16 ms delay (CX:DX in microseconds)
        mov     CX, 0h
        mov     DX, 3E80h
        mov     AH, 86h
        INT     15h

        ;; Move one step forward
        mov     AX, ap_Step_X
        add     word ptr ap_currentPosition[0], AX
        mov     AX, ap_Step_Y
        add     word ptr ap_currentPosition[2], AX

        ;; Draw previous and next cells
        mov     AX, ap_oldPosition
        call    RCtoMapSprite
        call    DrawSprite
        
        mov     AX, ap_newPosition
        call    RCtoMapSprite
        call    DrawSprite

        ;; Draw player at the new position
        MOV     CL, 10          ;Sprite_SIZE = 2^10
        MOV     SI, currentPlayer
        SHL     SI, CL
        ADD     SI, offset Sprite_Player_Base

        mov     CX, word ptr ap_currentPosition[0]
        mov     DX, word ptr ap_currentPosition[2]
        call    DrawSpriteXY

        ;; Check if the new position is reached
        mov     BX, ap_newPosition
        mov     AL, 32
        mul     BL
        mov     CX, AX          ;X component

        mov     AL, 32
        mul     BH
        mov     DX, AX          ;Y component

        cmp     CX, word ptr ap_currentPosition[0]
        JNE     ANIMATION_LOOP
        
        cmp     DX, word ptr ap_currentPosition[2]
        JNE     ANIMATION_LOOP

END_ANIMATION:  
        mov     DI, currentPlayer
        SHL     DI, 1
        mov     SI, ap_newPosition
        mov     Player_Base[DI], SI

        RET
AnimatePlayer   ENDP    
