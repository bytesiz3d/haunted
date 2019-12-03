.Model Small
.Stack 64
.Data


HauntedWidth EQU 320
HauntedHeight EQU 89
HauntedFilename DB 'h.bin', 0
HauntedFilehandle DW ?
HauntedData DB HauntedWidth*HauntedHeight dup(0)
NewGame						DB  0,0,0,'NEW GAME',0,0,0
Quit						DB  0,0,0,'QUIT',0,0,0                 

.Code
MAIN PROC FAR
					MOV AX , @DATA
					MOV DS , AX
				
					MOV AX,4F02H
					MOV BX,0105H
					;MOV Ax,0013h
					INT 10h
					
					CALL OpenFile
					CALL ReadData
					
					LEA BX , HauntedData ; BL contains index at the current drawn pixel
					
					MOV CX,320		;column
					MOV DX,70 ;row
					MOV AH,0ch
					
				drawLoop:
					MOV AL,[BX]
					cmp al,00
					je cont
					INT 10h 
					cont:
					INC CX
					INC BX
					CMP CX,HauntedWidth+320
				JNE drawLoop 
					
					MOV CX , 320
					INC DX
					CMP DX ,HauntedHeight+70
				JNE drawLoop
				
					call CloseFile
					
					; return control to operating system
				;	MOV AH , 4ch
				;	INT 21H
    
	
					call CloseFile
				

					MOV CH,08FH
					MOV CL,0FAH
					
					
					
					CHANGECHOSEN:					
					
					MOV SI,OFFSET [NewGame]
					MOV DI,0
					MOV DL,30 ;X		
					MOV DH,30 ;Y			
					XCHG CL,CH
									
					;Green (A) on white(F) background
					WriteNEwGame:
					
					MOV BL,CL
					MOV AH,2
					INC DX
					INT 10H
					
					
					
					MOV AH,9 ;Display
					MOV BH,0 ;Page 0
					MOV AL,[SI] ;Letter D
					INC SI
					PUSH CX
					MOV CX,1H ;5 times
					INT 10H
					POP CX
					INC DI
					CMP DI,10+4
					JL WriteNEwGame
					
					
					
					
					MOV SI,OFFSET [QUIT]
					MOV DI,0
					MOV DL,80 ;X
					MOV DH,30 ;Y
					 
					
					WriteQuit:
					
			
					MOV AH,2
					INC DX
					INT 10H
					MOV BL,CH
					
					
					MOV AH,9 ;Display
					MOV BH,0 ;Page 0
					MOV AL,[SI] ;Letter D
					INC SI
					PUSH CX
					MOV CX,1H ;5 times
					INT 10H
					POP CX
					INC DI
					CMP DI,6+4
					JL WriteQuit
										
					
					WaitTillChoose:
					MOV AH,0
					INT 16h
					CMP AH,4BH
					JE CHANGECHOSEN
					CMP AH,4DH
					JE CHANGECHOSEN
					
					CMP AH,1CH
					JE Chosen
					
					JMP WaitTillChoose
					
					Chosen:
					CMP CL,08FH
					JE StartGame
					MOV AH,4CH 
                    INT 21H
					
					StartGame:
	
	
	
MAIN ENDP




OpenFile PROC 

    ; Open file

    MOV AH, 3Dh
    MOV AL, 0 ; read only
    LEA DX, HauntedFilename
    INT 21h
    
    ; you should check carry flag to make sure it worked correctly
    ; carry = 0 -> successful , file handle -> AX
    ; carry = 1 -> failed , AX -> error code
     
    MOV [HauntedFilehandle], AX
    
    RET

OpenFile ENDP

ReadData PROC

    MOV AH,3Fh
    MOV BX, [HauntedFilehandle]
    MOV CX,HauntedWidth*HauntedHeight ; number of bytes to read
    LEA DX, HauntedData
    INT 21h
    RET
ReadData ENDP 


CloseFile PROC
	MOV AH, 3Eh
	MOV BX, [HauntedFilehandle]

	INT 21h
	RET
CloseFile ENDP

END MAIN
