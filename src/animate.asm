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
        ;; Reduce the delay:
        ;; SUB     DX, 4000
        SHR     DX, 1
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

;;; ============================================================================================
SpawnCoin       PROC    NEAR
        ;; Choose a random RC
        ;; If the point is empty, insert a coin
        ;; If not, repeat

        MOV     AX, totalFrameCount
        CWD
        MOV     BX, 30 * 4      ;30 frames * 4 seconds
        DIV     BX
        CMP     DX, 0           ;Does the current totalFrameCount divide 120 frames?
        JZ      SC_SPAWN
        RET

SC_SPAWN:      
        CALL    RandomRC

        MOV     AX, totalFrameCount
        CWD
        MOV     CX, 30 * 4 * 4  ;30 frames * 4 seconds * 5 times
        DIV     CX
        CMP     DX, 0           ;Does the current totalFrameCount divide 480 frames?
        JNZ     SC_NORMAL_COIN
        
        mov     levelMap[BX], SPRITE_ID_BIG_COIN
        mov     AX, DI
        mov     SI, offset Sprite_Big_Coin
        call    DrawSprite
        RET
        
SC_NORMAL_COIN: 
        mov     levelMap[BX], SPRITE_ID_COIN
        mov     AX, DI
        mov     SI, offset Sprite_Coin
        call    DrawSprite
        RET
SpawnCoin       ENDP

;;; ============================================================================================
        ;; Returns a random empty (R, C) pair in AX
RandomRC        PROC    NEAR
RRC_CALCULATE:  
        ;; MOV     AX, 0
        ;; INT     1Ah
        ;; mov     rrc_seed, DX

        ;; Working code here?
        MOV     DX, rrc_seed
        
        MOV     AX, DX
        MOV     DX, 0
        MUL     AX
        MOV     DH, DL
        MOV     DL, AH

        MOV     rrc_seed, DX
        
        MOV     AL, DL 
        MOV     AH, 0
        MOV     DL, 32  ;C % 32
        DIV     DL
        MOV     DL, AH

        MOV     AL, DH
        MOV     AH, 0
        MOV     DH, 18  ;R % 18
        DIV     DH
        MOV     DH, AH
        
        MOV     AX, DX
        CALL    RCtoMapIndex

        mov     AL, levelMap[BX]
        CMP     AL, SPRITE_ID_EMPTY
        JNE     RRC_CALCULATE

        MOV     AX, DI
        RET
RandomRC        ENDP
