                    .MODEL SMALL
;------------------------------------------------------
                    .STACK 64      

;------------------------------------------------------                    

                    .DATA


;--------------------------------------------------------
                    .CODE                                                 
MAIN                PROC FAR        
                    MOV AX,@DATA    
                    MOV DS,AX     
                    
					MOV AH,0
					MOV AL,13H
					INT 10H
					                   
					MOV AL,5
					MOV AH,0ch
	
					MOV CX,16
					COLUMNLOOP1:
					MOV DX,0
									
					COLUMNLOOP2:
					    INT 10H
					    INC DX
						CMP DX,200
						JL COLUMNLOOP2
					
					ADD CX,16
					CMP CX,320
					JL COLUMNLOOP1
					
					MOV DX,10
					
					ROWLOOP1:
					MOV CX,0
									
					ROWLOOP2:
					    INT 10H
					    INC CX
						CMP CX,320
						JL ROWLOOP2
					
					ADD DX,10
					CMP DX,200
					JL ROWLOOP1
					
					
                    MOV AH,4CH 
                    INT 21H

MAIN                ENDP
;-------------------------------------------------
                    END MAIN        