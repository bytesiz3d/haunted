        .MODEL SMALL
        .STACK 64
        .DATA
        square1   dw      0000h, 3200h
                  dw      0032h, 3232h

        square2   dw      3200h, 6400h
                  dw      3232h, 6432h

        col       db      "Collision!", 10, 13, '$'
        no_col    db      "No Collision!", 10, 13, '$'

        .CODE
MAIN    PROC    FAR
        MOV     AX, @DATA
        MOV     DS, AX

        ;; Checking right1, left2
        MOV     AX, square1[2]  ;Upper right
        MOV     DX, square2[0]  ;Upper left

        CMP     AX, DX
        JNE     NO_RL_COLLISION

        MOV     AX, square1[6]  ;Lower right
        MOV     DX, square2[4]  ;Lower left
        JNE     NO_RL_COLLISION

        JMP     COLLISION

NO_RL_COLLISION:
        ;; Checking left1, right2
        MOV     AX, square1[0]  ;Upper left
        MOV     DX, square2[2]  ;Upper right

        CMP     AX, DX
        JNE     NO_LR_COLLISION

        MOV     AX, square1[4]
        MOV     DX, square2[6]

        CMP     AX, DX
        JNE     NO_LR_COLLISION

        JMP     COLLISION

NO_LR_COLLISION:
        ;; Checking down1, up2
        MOV     AX, square1[4]  ;Lower left
        MOV     DX, square2[0]  ;Upper left

        CMP     AX, DX
        JNE     NO_DU_COLLISION

        MOV     AX, square1[6]  ;Lower right
        MOV     DX, square2[2]  ;Upper right

        CMP     AX, DX
        JNE     NO_DU_COLLISION

        JMP     COLLISION

NO_DU_COLLISION:
        ;; Checking up1, down2
        MOV     AX, square1[0]  ;Upper left
        MOV     DX, square2[4]  ;Lower left

        CMP     AX, DX
        JNE     NO_UD_COLLISION

        MOV     AX, square1[2]  ;Upper right
        MOV     DX, square2[6]  ;Lower right

        CMP     ax, dx
        JNE     NO_UD_COLLISION

        JMP     COLLISION

NO_UD_COLLISION:
        MOV     DX, offset no_col
        MOV     AH, 9
        INT     21h
        HLT

COLLISION:
        MOV     DX, offset col
        MOV     AH, 9
        INT     21h
        HLT

MAIN    ENDP
END     MAIN








        
