;; localPlayer    DB      ?
;; otherPlayer    DB      ?

;;; =================================================================================
        ;; Determines player numbers
InitSerial     PROC     NEAR
        ;; Initialize the transmission protocol
        MOV     DX, 3FBh        ;Line control register
        MOV     AL, 80h         ;Set Divisor Latch Access Bit
        OUT     DX, AL

        MOV     DX, 3F8h        ;Set LSB byte of Baud Rate Divisor
        MOV     AL, 0Ch
        OUT     DX, AL

        MOV     DX, 3F9h        ;Set MSB byte
        MOV     AL, 00h
        OUT     DX, AL

        MOV     DX, 3FBh        ;Set port configuration
        MOV     AL, 1Bh         ;Access RT buffer, Disable Set Break, Even Parity, One Stop bit, 8 bits
        OUT     DX, AL

        ;; Check if received 0
        CALL    SR_ReceiveByte
        CMP     BL, 0FFh        ;Error code
        JE      SERIAL_NO_INPUT

        ;; Set as input, reply with input
        mov     localPlayer, 1
        mov     otherPlayer, 0

        mov     BL, otherPlayer
        CALL    SR_SendByte
        
        RET

SERIAL_NO_INPUT:        
        ;; Send 1
        mov     localPlayer, 0
        mov     otherPlayer, 1
        mov     BL, otherPlayer
        CALL    SR_SendByte

        ;; 8 ms delay (CX:DX in microseconds)
        mov     CX, 0h
        mov     DX, 1000h
        mov     AH, 86h
        INT     15h

SERIAL_WAIT_ECHO:       
        ;; Check if received 0
        CALL    SR_ReceiveByte
        CMP     BL, 0FFh        ;Error code
        JE      SERIAL_WAIT_ECHO

        CMP     BL, localPlayer 
        JNE     SERIAL_WAIT_ECHO
        ;; Received 0

        RET
InitSerial     ENDP 

;;; =================================================================================
        ;; in BL: Byte to send
SR_SendByte        PROC    NEAR
        ;; Check that Transmitter Holding Register is Empty
        mov     dx, 03FDh       ;Line Status Register
        in      al, dx          ;Read Line Status
        test    al, 00100000b
        JZ      SC_NO_DATA      ;Not empty

        ;; Ready to transmit
        mov     dx, 03F8h       ;Transmit data register
        mov     al, bl
        out     dx, al

SC_NO_DATA:     
        RET
SR_SendByte        ENDP

;;; =================================================================================
        ;; out BL: character received
SR_ReceiveByte     PROC    NEAR
        ;; Check that data is ready
        mov     dx, 03FDh       ;Line Status Register
        in      al, dx          ;Read Line Status
        test    al, 1
        JZ      RC_NO_DATA

        ;; Ready to receive
        mov     dx, 03F8h       ;Transmit data register
        in      al, dx

        mov     bl, al
        RET
        
RC_NO_DATA:     
        mov     BL, 0FFh
        RET
SR_ReceiveByte     ENDP

;;; =================================================================================
        ;; in BX: Word to send
SR_SendWord        PROC    NEAR
        ;; Check that Transmitter Holding Register is Empty
        mov     dx, 03FDh       ;Line Status Register
        in      al, dx          ;Read Line Status
        test    al, 00100000b
        JZ      SC_NO_DATA      ;Not empty

        ;; Ready to transmit
        mov     dx, 03F8h       ;Transmit data register
        mov     AX, BX
        out     dx, AX

SCW_NO_DATA:     
        RET
SR_SendWord        ENDP

;;; =================================================================================
        ;; out BX: Word received
SR_ReceiveWord     PROC    NEAR
        ;; Check that data is ready
        mov     dx, 03FDh       ;Line Status Register
        in      al, dx          ;Read Line Status
        test    al, 1
        JZ      RC_NO_DATA

        ;; Ready to receive
        mov     dx, 03F8h       ;Transmit data register
        in      AX, dx

        mov     BX, AX
        RET
        
RCW_NO_DATA:     
        mov     BX, 0FFFFh
        RET
SR_ReceiveWord     ENDP

;;; =================================================================================
;;; =================================================================================
        ;; in BL: character to confirm
SR_RTX                  PROC    NEAR
        ;; TODO: combine receive + transmit, transmit + wait echo
        RET
SR_RTX                  ENDP    
