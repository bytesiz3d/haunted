;Data
;	Value_S db ?
;	Value_R db ?
;	point    dw 0D00H
;	point2   dw 0100H

Chat PROC NEAR
	MOV AX, 0D00H
	MOV WORD PTR point, AX
	MOV AX, 0100H
	MOV WORD PTR point2, AX

	MOV BL,0
	MOV AX,0600H
	MOV BH,01FH
	MOV CX,0
	MOV DX,0B4FH
	INT 10H	

	MOV BL,0
	MOV AX,0600H
	MOV BH,4FH
	MOV CX,0C00H
	MOV DX,184FH
	INT 10H

	MOV BX,0
	MOV AL,0
	MOV CX,0

	MOV AH,2
	MOV DX,0C00H
	INT 10H

	MOV AH , 9
	MOV DX , offset p1Name+2 
	INT 21H

	MOV AH,2
	MOV DX,0000H
	INT 10H

	MOV AH , 9
	MOV DX , offset p2Name+2 
	INT 21H
	
	MOV AH,2
	MOV DX,word PTR point
	INT 10H 
	MOV BH,0    
	
	CALL UARTConf  	
send?Receive?:
	MOV DX , 3FDH    ; Line StAtus Register
	in AL , DX 
  	test AL , 1
  	JZ next
	CALL Receive
	;MOV AL,1 
	;MOV DX , 3FDH 
    ;OUT DX,AL   
next:
	MOV AH,1
	INT 16H
    JZ send?Receive?
    MOV AH,0
	INT 16H
	CALL Send
	JMP send?Receive?

exit1:
	JMP FAR PTR MAIN_MENU
	RET	
Chat	ENDP

UARTConf PROC NEAR

	MOV DX,3FBH 			; Line ControL Register
    MOV AL,10000000b		;Set Divisor LAtCH ACCess Bit
    OUT DX,AL				;OUT it
    
    MOV DX,3F8H			
    MOV AL,0CH			
    OUT DX,AL
    
    MOV DX,3F9H
    MOV AL,00H
    OUT DX,AL

    MOV DX,3FBH
    MOV AL,00011011b
    OUT DX,AL
	RET
UARTConf ENDP

Send PROC NEAR 
	
   	MOV Value_S,AL
	
	
	MOV AH,4FH
	CMP byte PTR point,AH
	jb snot_end_Line

	MOV AH,18H
	CMP byte PTR point[1],AH
	jb S_Check_enter1

	MOV word PTR point,1800H
	MOV AH,2
	MOV DX,word PTR point
	INT 10H 
	MOV BL,0
	MOV AX,0601H
	MOV BH,04FH
	MOV CX,0D00H
	MOV DX,184FH
	INT 10H
	JMP S_Display

snot_end_Line:

	MOV AH,18H
	CMP byte PTR point[1],AH
	jb S_Check_enter1
	CMP AL,0DH
	jne S_Display
	MOV word PTR point,1800H
	MOV BL,0
	MOV AX,0601H
	MOV BH,04FH
	MOV CX,0D00H
	MOV DX,184FH
	INT 10H
	JMP S_Display

S_Check_enter1:
	CMP AL , 0DH
	jne S_Display
	MOV byte PTR point,00H	
	inC byte PTR point[1]	
	JMP S_Display
	
S_Display:
	MOV AH , 2
	MOV DX,word PTR point
	INT 10H 
	
	CMP AL , 08H
	JNZ S_NotBackspace
	

	MOV AH , 2 
	MOV DL , Value_S
	INT 21H

	MOV AH , 2
	MOV DL , 20H
	INT 21H

S_NotBackspace:
	
	

	MOV DX ,3FDH		; Line StAtus Register
	AGAIN1:
  	In AL,DX 			;ReAd Line StAtus
	test AL , 00100000b
	JZ AGAIN1

	MOV DX , 3F8H		; TrAnsmit dAtA register
    MOV  AL,Value_S
  	OUT DX , AL 
	
	MOV  AL,Value_S
	CMP AL,27
    JNZ Return
    JMP FAR PTR exit1
    
Return:
	MOV DL , Value_S
	MOV AH ,2 
  	INT 21H

  	MOV AH , 3H 
	MOV BH , 0H 
	INT 10H
	MOV word PTR point,DX

	RET
Send    ENDP

Receive PROC NEAR 

	MOV DX , 03F8H
	in AL , DX 
	MOV Value_R , AL
	MOV AL, Value_R
	CMP AL,27
    JNZ REC
    JMP FAR PTR exit1
REC:	
	MOV AH,4FH
	CMP byte PTR point2,AH
	jb not_end_Line

	MOV AH,0BH
	CMP byte PTR point2[1],AH
	jb Check_enter1

	MOV word PTR point2,0B00H
	MOV AH,2
	MOV DX,word PTR point2
	INT 10H 

	MOV BL,0
	MOV AX,0601H
	MOV BH,01FH
	MOV CX,0100H
	MOV DX,0B4FH
	INT 10H
	JMP Display

not_end_Line:

	MOV AH,0BH
	CMP byte PTR point2[1],AH
	jb Check_enter1
	CMP AL,0DH
	jne Display
	MOV word PTR point2,0B00H
	MOV BL,0
	MOV AX,0601H
	MOV BH,01FH
	MOV CX,0100H
	MOV DX,0B4FH
	INT 10H
	JMP Display

Check_enter1:
	CMP AL,0DH
	jne Display
	MOV byte PTR point2,00H	
	inC byte PTR point2[1]	
	JMP Display
	
Display:
	MOV AH,2
	MOV DX,word PTR point2
	INT 10H 
	
	CMP AL,08H
	JNZ NotBackspace

	MOV AH,2
	MOV DL , Value_R
	INT 21H
	MOV AH,2
	MOV DL ,20H
	INT 21H
	

NotBackspace:
	
    MOV DL , Value_R
	MOV AH ,2 
  	INT 21H
	
	MOV AH,3H 
	MOV BH,0H 
	INT 10H
	MOV word PTR point2,DX
	
	mov	sendC,0
	mov	sendG,0
	mov	rcvC,0
	mov rcvG,0
	
	RET

Receive ENDP
