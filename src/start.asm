;;; ============================================================================================
InitGame        PROC    NEAR

        CMP     localPlayer, 0
        JNE     IG_NOT_PRIMARY

        ;; Initialize the seed
        ;; Get system clock tick count IN DX
        MOV     AX, 0
        INT     1Ah
        mov     rrc_seed, DX
        
        call    ResetGame

        ;; Place data where it should be
        mov     AX, Player_0
        mov     word ptr IG_inputData, AX

        mov     AX, Player_1 
        mov     word ptr IG_inputData[2], AX

        mov     AX, Ghost_00
        mov     word ptr IG_inputData[4], AX

        mov     AX, Ghost_10
        mov     word ptr IG_inputData[6], AX

        mov     AX, rrc_seed
        mov     word ptr IG_inputData[8], AX

        mov     IG_counter, 2 * 5 ;5 words
        ;; Send data
IG_SEND_GAME_DATA:
        mov     SI, 2 * 5
        sub     SI, IG_counter  ;Get the current index

        ;; Send the character
        mov     BL, byte ptr IG_inputData[SI]
        call    SR_SendCharacter

IG_WAIT_ECHO_DATA:      
        ;; Repeat until echo is received
        call    SR_ReceiveCharacter
        cmp     BL, byte ptr IG_inputData[SI]
        JNE     IG_WAIT_ECHO_DATA
        
        dec     IG_counter
        JNZ     IG_SEND_GAME_DATA

        ;; Finished sending data
        RET

IG_NOT_PRIMARY:
        mov     IG_counter, 2 * 5 ;5 words
        ;; Read data
IG_RECEIVE_GAME_DATA:  
        call    SR_ReceiveCharacter
        cmp     BL, 0FFh        ;Error code
        JE      IG_RECEIVE_GAME_DATA

        ;; Write data
        mov     SI, 2 * 5       ;5 words
        sub     SI, IG_counter  ;Get the current index

        ;; Send echo
        mov     byte ptr IG_inputData[SI], BL
        call    SR_SendCharacter
        
        dec     IG_counter
        JNZ     IG_RECEIVE_GAME_DATA
        ;; Finished receiving data

        ;; Place data where it should be
        mov     AX, word ptr IG_inputData
        mov     Player_0, AX

        mov     AX, word ptr IG_inputData[2]
        mov     Player_1, AX

        mov     AX, word ptr IG_inputData[4]
        mov     Ghost_00, AX

        mov     AX, word ptr IG_inputData[6]
        mov     Ghost_10, AX

        mov     AX, word ptr IG_inputData[8]
        mov     rrc_seed, AX

        mov     Score_Player_0, 0000h
        mov     Score_Player_1, 0000h
        
        mov     freezeCounter_Player0, 0
        mov     freezeCounter_Player1, 0

        mov     x2SpeedCounter_Ghost0, 0
        mov     x2SpeedCounter_Ghost1, 0

        mov     ghostCounter, ghostDelay
        mov     totalFrameCount, 30 * 60

        RET
InitGame        ENDP
