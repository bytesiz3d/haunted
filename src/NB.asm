;;SB_line               DB  128 dup('_')  
;;SB_space              DB  128(32)       
;;NB_msg1				DB	31 , "Level 1: Press ESC to Exit game"
;;NB_msg2				DB	31 , "Level 2: Press ESC to Exit game"
;;NB_msg3				DB	53 , "GAME OVER Press Enter to go to Level 2 or ESC to Exit"
;;NB_msg4				DB	27 , "GAME OVER Press ESC to Exit"  

NotificationBar proc near
    MOV CH,0
    MOV AL,0
    MOV BX,000Fh
	MOV BP,offset SB_line
    MOV AH,13h   
    MOV CL,80h 
    MOV DX,2D00h
    INT 10h 
	
	MOV BX,0000h
    MOV AH,13h
    MOV BP,OFFSET SB_space
    MOV DX,2F00h
    MOV CL,128
    INT 10h

	MOV BX,000Eh
    MOV AH,13h
    MOV BP,DI
    MOV DX,2F01h
    MOV CX,SI
    INT 10h
	
    RET
NotificationBar ENDP