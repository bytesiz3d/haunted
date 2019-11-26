                    .MODEL LARGE
;------------------------------------------------------
                    .STACK 64      
;------------------------------------------------------                    

                    .DATA

WindowResolution_X			EQU  320
WindowResolution_Y			EQU  200
GRIDCOLUMNS					EQU  8
GRIDROWS					EQU  5  
CellResolution_X			DW  ?	
CellResolution_Y			DW  ?

; TO GET GRID WITH SQUARE CELLS : GRIDCOLUMNS / GRIDROWS = WindowResolution_X / WindowResolution_Y

;--------------------------------------------------------




                    .CODE                                                 
MAIN                PROC FAR        
                    MOV AX,@DATA    
                    MOV DS,AX     
                    
					
					MOV AH,0
					MOV AL,13H
					INT 10H
					                   
					
					CALL DRAWGRID
					
					  
                    
                    MOV AH,4CH 
                    INT 21H

MAIN                ENDP
;-------------------------------------------------



DrawGrid                PROC NEAR

					
					
					PUSH AX
					PUSH CX
					PUSH DX
					PUSH BX
					PUSH SP
					PUSH BP
					PUSH SI
					PUSH DI
					
					MOV AX,WindowResolution_X
					MOV DX,0
					MOV CX,GRIDCOLUMNS               
					DIV CX
					MOV CellResolution_X,AX
					
					
					MOV AX,WindowResolution_Y   
					MOV DX,0
					MOV CX,GRIDROWS               
					DIV CX
					MOV CellResolution_Y,AX
					MOV AL,5
					MOV AH,0ch
					
					MOV CX,CellResolution_X
					
					COLUMNLOOP1:
					MOV DX,0
									
					COLUMNLOOP2:
					    INT 10H
					    INC DX
						CMP DX,WindowResolution_Y
						JL COLUMNLOOP2
					
					ADD CX,CellResolution_X
					CMP CX,WindowResolution_X
					JL COLUMNLOOP1
					
					
					
					MOV DX,CellResolution_Y
					
					
					
					ROWLOOP1:
					MOV CX,0
									
					ROWLOOP2:
					    INT 10H
					    INC CX
						CMP CX,WindowResolution_X
						JL ROWLOOP2
					
					ADD DX,CellResolution_Y
					CMP DX,WindowResolution_Y
					JL ROWLOOP1
					
					POP DI
					POP SI
					POP BP
					POP SP
					POP BX
					POP DX
					POP CX
					POP AX
					
					
                    RET
					
DrawGrid                ENDP    



;--------------------------------------------------
                    END MAIN        