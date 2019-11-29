CLEAR_SCREEN MACRO

mov ax,0600h
mov bh,07
mov cx,0
mov dx,184FH
int 10h

ENDM CLEAR_SCREEN


SQUARE MACRO X, Y, L
LOCAL DRAWLOOP
CLEAR_SCREEN
MOV CX , X
MOV DX , Y
MOV AL , 15
MOV AH , 0CH

MOV BX , X
ADD BX , L   ;SQUARE BOUNDRIES

MOV DI , Y
ADD DI , L   ;SQUARE BOUNDRIES

DRAWLOOP: INT 10H

INC CX        ;INC COLUMN
CMP BX ,CX    
JNZ DRAWLOOP  

MOV CX , X
INC DX        ;INC ROW
CMP  DI , DX   
JNZ DRAWLOOP   


ENDM SQUARE   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.MODEL LARGE
.Stack
.Data

xPos DW 0
yPos DW 0
L 	EQU	20
.CODE

MAIN PROC FAR

MOV AX , @DATA
MOV DS , AX
                 
MOV AH , 0
MOV AL , 13H
INT 10H              ;video mode
; MOV AX , 0600H
; MOV BH , 07
; MOV CX , 0
; MOV DX , 184FH
; INT 10H              ;clear screen            

SQUARE xPos, yPos, L                        
INPUTLOOP: 

MOV AH , 1
INT 16H

JNZ ISUP
JMP INPUTLOOP

ISUP : CMP AH , 48H
      JNZ ISDOWN
      SUB yPos , L
	  JMP CLEAR_AND_DRAW

ISDOWN :CMP AH , 50H
        JNZ ISRIGHT
        ADD yPos , L
		JMP CLEAR_AND_DRAW

ISRIGHT : CMP AH , 4DH
         JNZ ISLEFT
         ADD xPos , L
		 JMP CLEAR_AND_DRAW
		 
ISLEFT : CMP AH , 4BH
        JNZ INPUTLOOP
        SUB xPos , L
		JMP CLEAR_AND_DRAW
		
CLEAR_AND_DRAW:
		MOV AH , 0
	  INT 16H
      SQUARE xPos, yPos, L
		JMP INPUTLOOP
HLT
MAIN ENDP
END MAIN