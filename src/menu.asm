;; HauntedWidth            EQU     320
;; HauntedHeight           EQU     89
;; HauntedFilename         DB      'practice\h.bin', 0
;; fileHandle       DW      ?
;; HauntedData             DB      HauntedWidth*HauntedHeight dup(0)
;; P1Name                  DB      10, ?, 10 dup("$")
;; P2Name                  DB      10, ?, 10 dup("$")
;; NewGame                 DB      0 , 0, 0 , "NEW GAME", 0 , 0 , 0
;; Quit                    DB      0 , 0, 0 , "QUIT", 0 , 0 , 0                 
;; playername              DB      'Player', ' Name: $'
;; choose_msg              DB      17,"Choose Your level"
;; level1_msg              DB      14,"Level 1 ==> F1"
;; level2_msg              DB      14,"Level 2 ==> F2" 
;; lv1Filename             DB      "lv1", 0
;; lv2Filename             DB      "lv2", 0
;; lvChosen                DW      ?                
;;; ===============================================================================
;;; File handling
OpenFile        PROC    NEAR
        ;; Open file
        MOV     AH, 3Dh
        MOV     AL, 0 ; read only
        LEA     DX, HauntedFilename
        INT     21h
    
        ;; you should check carry flag to make sure it worked correctly
        ;; carry = 0 -> successful , file handle -> AX
        ;; carry = 1 -> failed , AX -> error code
        MOV     [fileHandle], AX
        RET
OpenFile        ENDP

;;; ===============================================================================
ReadData        PROC    NEAR
        MOV     AH, 3Fh
        MOV     BX, [fileHandle]
        MOV     CX, HauntedWidth * HauntedHeight ; number of bytes to read
        LEA     DX, HauntedData
        INT     21h
        RET
ReadData        ENDP 

;;; ===============================================================================
CloseFile       PROC    NEAR
        MOV     AH, 3Eh
        MOV     BX, [fileHandle]
        INT     21h
        RET
CloseFile       ENDP

;;; ===============================================================================
        ;; in SI: Filename offset, (null-terminated)
        ;; in DI: Destination offset
        ;; in CX: Number of bytes to read
LoadBuffer      PROC    NEAR
        ;; Open File
        MOV     AH, 3Dh
        MOV     AL, 0
        MOV     DX, SI
        INT     21h
        MOV     [fileHandle], AX

        ;; Read data
        MOV     AH, 3Fh
        MOV     BX, [fileHandle]
        ;; MOV     CX, SPRITE_SIZE
        MOV     DX, DI
        INT     21h

        ;; Close File
        MOV     AH, 3Eh
        MOV     BX, [fileHandle]
        INT     21h       

        RET
LoadBuffer      ENDP

;;; ===============================================================================
Haunted_MainMenu        PROC    NEAR
        CALL    OpenFile
        CALL    ReadData
        LEA     BX, HauntedData ;BL contains index at the current drawn pixel
        MOV     CX, 352         ;column                                    
        MOV     DX, 200         ;row                                                     
        MOV     AH, 0ch                                                         
        
drawLoop:                                                                  
        MOV     AL, [BX]                                                        
        cmp     al, 00                                                          
        je      cont                                                            
        INT     10h                                                            
cont:                                                              
        INC     CX                                                             
        INC     BX                                                             
        CMP     CX, HauntedWidth+352                                            
        JNE     drawLoop                                                               
        
        MOV     CX, 352                                                       
        INC     DX                                                             
        CMP     DX, HauntedHeight+200                                           
        JNE     drawLoop                                                               
        
        call    CloseFile                                                     
        call    CloseFile 

		Call GetPlayersNames
		
        MOV     CH, 0
        MOV     AL, 0
        MOV     BX, 0000H
        MOV     BP, OFFSET SB_space
        MOV     AH, 13H   
        MOV     CL, 127 
        MOV     DX, 1E00H
        INT     10H  
               
        MOV     CH, 0DH                                                        
        MOV     CL, 0FH                                                        
 
		


 
WriteChat:

        MOV     BX, 000DH
        MOV     BP, OFFSET chatting+1
        MOV     CL, BYTE PTR chatting
        MOV     DX, 2031H
		CALL	PrintCharacters

WriteSendInvite:
 
        MOV     BX, 000DH
        MOV     DX, 2331H
        MOV     BP, OFFSET newGame+1
        MOV     CL, BYTE PTR newGame
		CALL	PrintCharacters

WriteQuit:
        MOV     BX, 000DH
        MOV     DX, 2631H
        MOV     BP, OFFSET quit+1
        MOV     CL, BYTE PTR quit
		CALL	PrintCharacters


WriteSB:

        MOV     BX, 000FH
		MOV     BP, OFFSET SB_LINE
        MOV     CL, 80H 
        MOV     DX, 2B00H
		CALL	PrintCharacters


WaitTillChose:
		
		
		CALL	SR_ReceiveByte
		
		cmp		bl, 3CH ; f2		
		jne	NotF2
		
		CMP		sendG,1
		JNE		gameInvitation
		JMP		StartGame
		
		gameInvitation:
		;print notification he invited me
        MOV     BX, 00FH
        MOV     DX, 2C04H
        MOV     BP, OFFSET P2Name+2
        MOV     CL, BYTE PTR P2Name[1]
		CALL	PrintCharacters
		
		mov		dx,2C04H
		add		dL,BYTE PTR P2Name[1]
		
        MOV     BX, 00FH
        MOV     BP, offset RcvGInviteNotification+1
        MOV     CL, BYTE PTR RcvGInviteNotification
		CALL	PrintCharacters		
		mov		rcvG,1
		
		
		
NotF2:


		cmp		bl, 3BH ; f1		
		jne	NotF1
		
		CMP		sendC,1
		JNE		ChatInvitation
		JMP		ChatMode
		
		ChatInvitation:
		
		;print notification he invited me
		
		
		
        MOV     BX, 00FH
        MOV     DX, 2E04H
        MOV     BP, OFFSET P2Name+2
        MOV     CL, BYTE PTR P2Name[1]
		CALL	PrintCharacters
		
		mov		dx,2E04H
		add		dL,BYTE PTR P2Name[1]
		
        MOV     BX, 00FH
        MOV     BP, offset RcvCInviteNotification+1
        MOV     CL, BYTE PTR RcvCInviteNotification
		CALL	PrintCharacters

		
		
		
		
		mov		rcvC,1

NotF1:

GetUserInput:

		mov 	ah, 1
		int 	16h
		
		jz		WaitTillChose
		
		mov		BL,AH
		mov		BH,AL
		
		again:	CALL	SR_SendByte
		cmp		dx,03FDh
		je		again
		
		PUSH ES
		MOV AX, 0000H
		MOV ES, AX
		MOV ES:[041AH], 041EH
		MOV ES:[041CH], 041EH				; Clears keyboard buffer
		POP ES
		


        CMP     BH, 27  ;esc                                                       
        JE      Exit0                                                         

        CMP     BL, 3BH ;f1
        JE      choseChat

        CMP     BL, 3CH ;f2
        JE      choseGame

		JMP		WaitTillChose

choseGame:

		
		CMP		rcvG,1
		je		StartGame
		mov		sendG,1
		;print notification you invited him
        MOV     BX, 00FH
        MOV     DX, 2C04H
        MOV     BP, OFFSET SentGInviteNotification+1
        MOV     CL, BYTE PTR SentGInviteNotification
		CALL	PrintCharacters

		mov		dx,2C04H
		add		dL,BYTE PTR SentCInviteNotification
		
        MOV     BX, 00FH
        MOV     BP, OFFSET P2Name+2
        MOV     CL, BYTE PTR P2Name[1]
		CALL	PrintCharacters

		JMP		WaitTillChose

choseChat:

		
		CMP		rcvC,1
		je		ChatMode
		mov		sendC,1
		;print notification you invited him
        MOV     BX, 00FH
        MOV     DX, 2E04H
        MOV     BP, OFFSET SentCInviteNotification+1
        MOV     CL, BYTE PTR SentCInviteNotification
		CALL	PrintCharacters
		
		mov		dx,2E04h
		add		dL,BYTE PTR SentCInviteNotification
		
        MOV     BX, 00FH
        MOV     BP, OFFSET P2Name+2
        MOV     CL, BYTE PTR P2Name[1]
		CALL	PrintCharacters


		
		
		JMP		WaitTillChose



ChatMode:
		mov    AX, 3h          ;Return to text mode
        INT    10h
        MOV    SelectMode, 1     
        RET    


Exit0:
        mov     AX, 3h          ;Return to text mode
        INT     10h
        MOV     AH, 4CH         ;Exit the program
        INT     21H 
   


StartGame:



		MOV    SelectMode, 0		
        MOV     CH, 0
        MOV     AL, 0
        MOV     BX, 0000H
        MOV     BP, OFFSET SB_space
        MOV     AH, 13H   
        MOV     CL, 120 
        MOV     DX, 1E1DH
        INT     10H
        
        MOV     DX, 2100H
        INT     10h

        ;; Clear the screen
        mov     AX, 4F02H
        mov     BX, 0105H
        INT     10H   


		
		CMP		sendG,1
		je		ChooseMap
		
		MOV     BX, 000DH
        MOV     DX, 2A0AH
        MOV     BP, OFFSET connectingScreen+1
        MOV     CL, BYTE PTR connectingScreen
		CALL	PrintCharacters

		
		
		LEA DI,P1Name[1]
		LEA SI,P2Name[1]
		MOV CH,0
		MOV	CL,[DI-1]
		INC CL
		
exchangenames0:
		
		MOV AL,[DI]
		MOV AH,[SI]
		MOV [DI],AH
		MOV [SI],AL
		INC SI
		INC DI
		LOOP exchangenames0

IS_CHOSEN0:  
		
		
		CALL	SR_ReceiveByte
		
        CMP     BL, 1                                                         
        JNE     level2
             
        MOV     SI, OFFSET lv1Filename
        MOV     WORD PTR lvChosen, SI
        RET
level2:        
        CMP     BL, 2                                                         
        jNE     IS_CHOSEN0
        
        MOV     SI, OFFSET lv2Filename
        MOV     WORD PTR lvChosen, SI

		
		ret
		
		
		
		

ChooseMap:		

        MOV     CH, 0
        MOV     AL, 0
        MOV     BX, 000DH
        MOV     BP, OFFSET choose_msg+1
        MOV     AH, 13H   
        MOV     CL, BYTE PTR choose_msg 
        MOV     DX, 2337H
        INT     10H  
        
        MOV     BX, 00FH
        MOV     BP, OFFSET level1_msg+1
        MOV     AH, 13H   
        MOV     CL, BYTE PTR level1_msg 
        MOV     DX, 2539H
        INT     10H     
        
        MOV     BP, OFFSET level2_msg+1
        MOV     AH, 13H   
        MOV     CL, BYTE PTR level2_msg 
        MOV     DX, 2639H
        INT     10H     
        
IS_CHOSEN:  
        
        MOV     AH, 0                                                           
        INT     16h                                                            
        CMP     AH, 3BH                                                         
        JNE     IS_F2
             
        MOV     SI, OFFSET lv1Filename
        MOV     WORD PTR lvChosen, SI

        mov		bl,1
again01: call	SR_SendByte
		cmp		dx,03FDh
		je		again01
		
		RET
IS_F2:        
        CMP     AH, 3CH                                                         
        jNE     IS_CHOSEN
        
        MOV     SI, OFFSET lv2Filename
        MOV     WORD PTR lvChosen, SI
        
		mov		bl,2
		again2: call	SR_SendByte
		cmp		dx,03FDh
		je		again2
		
        RET
Haunted_MainMenu        ENDP
        
;;; ===============================================================================
        ;; Reset all game state variables
ResetGame       PROC    NEAR
        
        CALL    RandomRC
        mov     Player_0, AX

        CALL    RandomRC
        mov     Player_1, AX

        CALL    RandomRC
        mov     Ghost_00, AX

        CALL    RandomRC
        mov     Ghost_10, AX

        mov     Score_Player_0, 0000h
        mov     Score_Player_1, 0000h
        
        mov     freezeCounter_Player0, 0
        mov     freezeCounter_Player1, 0

        mov     x2SpeedCounter_Ghost0, 0
        mov     x2SpeedCounter_Ghost1, 0

        mov     ghostCounter, ghostDelay
        mov     totalFrameCount, 30 * 60
		
		mov		sendC,0
		mov		rcvC,0

		mov		sendG,0
		mov		rcvG,0
		

        RET
ResetGame       ENDP 
        
GetPlayersNames		PROC	NEAR


PLAYERS_NAMES: 
        MOV     DL, 31 ;X               
        MOV     DH, 30 ;Y                                       
        MOV     AH, 2
        INT     10H
        mov     ah, 9
        mov     dx, offset playername
        int     21h

entername:
		mov ah,2
		mov dl,45
		mov	dh,30
		int 10h 
		mov ah,0AH
		mov dx,offset P1Name
		int 21h 
		
		cmp	P1Name[1],0
		je	entername


        CALL    InitSerial


		cmp 	localplayer,0		
		jne		rcv_first

		
		lea si, P1Name
		inc si
		mov ch,0
		mov cl, P1Name[1]
		inc cl 
		
sendLocalPlayername1:
		
		mov bl, [si]
		inc si
			
		notsent1:
		call	SR_SendByte
		cmp 	dx, 03FDh
		je		notsent1
				
		loop 	sendLocalPlayername1


		; first recieve other player name size 
		
		
		notrcv11:
		call	SR_ReceiveByte
		cmp 	dx, 03FDh
		je		notrcv11
		mov ch,0
		mov cl,bl
		mov P2Name[1],cl
		lea si,P2Name[2]
		
		recieveOtherPlayername1:
		
notrcv1:
		call	SR_ReceiveByte
		cmp 	dx, 03FDh
		je		notrcv1

		
		mov [si],bl
		inc si 

		loop recieveOtherPlayername1
							
		ret

rcv_first:

notrcv00:
		call	SR_ReceiveByte
		cmp 	dx, 03FDh
		je		notrcv00

		mov ch,0
		mov cl,bl
		mov P2Name[1],cl
		lea si,P2Name[2]

recieveOtherPlayername0:
		
notrcv0:

		call	SR_ReceiveByte
		cmp 	dx, 03FDh
		je		notrcv0

		
		mov [si],bl
		inc si 

loop recieveOtherPlayername0


		lea si, P1Name
		inc si
		mov ch,0
		mov cl, P1Name[1]
		inc cl
		
sendLocalPlayername0:
		
		mov bl, [si]
		inc si
		
		
notsent0:
		call	SR_SendByte
		cmp 	dx, 03FDh
		je		notsent0
				
		loop 	sendLocalPlayername0
		
ret		
GetPlayersNames		ENDP


PrintCharacters		PROC	near

;BX : color
;DX : position
;BP	: offset chars
;CL	: BYTE PTR number of chars

        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX

        MOV     CH, 0
        MOV     AL, 0
        MOV     AH, 13H   
        INT     10H
        
		POP     DX
		POP		CX
		POP     BX
		POP		AX
		
		RET

PrintCharacters		ENDP