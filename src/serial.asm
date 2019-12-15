;; chosenNumber    DB      ?
;; otherNumber     DB      ?

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

        CALL    SR_ReceiveCharacter
        CMP     BL, 0FFh        ;Error code
        JE      SERIAL_NO_INPUT

        ;; Set as input, reply with input
        mov     chosenNumber, BL
        mov     otherNumber, BL
        xor     otherNumber, 01
        CALL    SR_SendCharacter

SERIAL_WAIT_INPUT:
        CALL    SR_ReceiveCharacter
        CMP     BL, 0FFh        ;Error code
        JE      SERIAL_WAIT_INPUT

        CMP     BL, chosenNumber 
        JNE     SERIAL_WAIT_INPUT
        ;; Received my character
        JMP     SERIAL_FINISHED

SERIAL_NO_INPUT:        
        ;; Get system clock tick count IN DX
        MOV     AX, 0
        INT     1Ah

        SHR     DL, 1
        MOV     chosenNumber, 0
        JNC     SERIAL_SET_0
        ADD     chosenNumber, 1
SERIAL_SET_0:

        ;; Set as number
        MOV     AL, chosenNumber
        XOR     AL, 01
        MOV     otherNumber, AL

        ;; Send other number
        MOV     BL, otherNumber
        CALL    SR_SendCharacter

SERIAL_WAIT_REPLY:      
        CALL    SR_ReceiveCharacter
        CMP     BL, 0FFh        ;Error code
        JE      SERIAL_WAIT_REPLY

        CMP     BL, otherNumber 
        JNE     SERIAL_WAIT_REPLY
        ;; Received the other character

        ;; Confirm and exit
        mov     BL, otherNumber
        CALL    SR_SendCharacter
        JMP     SERIAL_FINISHED
        
SERIAL_FINISHED:        
        RET
InitSerial     ENDP 

;;; =================================================================================
        ;; in BL: Byte to send
SR_SendCharacter        PROC    NEAR
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
SR_SendCharacter        ENDP

;;; =================================================================================
        ;; out BL: character received
SR_ReceiveCharacter     PROC    NEAR
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
SR_ReceiveCharacter     ENDP
