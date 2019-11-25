SQUARE MACRO X , Y
LOCAL DRAWLOOP

MOV CX , X
MOV DX , Y
MOV AL , 15
MOV AH , 0CH

MOV BX , X
ADD BX , 50   ;SQUARE BOUNDRIES

MOV DI , Y
ADD DI , 50   ;SQUARE BOUNDRIES

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

.CODE

MAIN PROC FAR
                 
MOV AH , 0
MOV AL , 13H
INT 10H              ;video mode

MOV AX , 0600H
MOV BH , 07
MOV CX , 0
MOV DX , 184FH
INT 10H              ;clear screen

MOV SI , 100
MOV DI , 120             
                 
INPUTLOOP: SQUARE SI , DI        

MOV AH , 1
INT 16H

JNZ ISUP
JMP INPUTLOOP

ISUP : CMP AH , 48H
       JNZ ISDOWN
       SUB DI , 50
       JMP INPUTLOOP

ISDOWN : CMP AH , 50H
         JNZ ISRIGHT
         ADD DI , 50
         JMP INPUTLOOP

ISRIGHT : CMP AH , 4DH
          JNZ ISLEFT
          ADD SI , 50
          JMP INPUTLOOP
                           
ISLEFT : CMP AH , 4BH
         JNZ INPUTLOOP
         SUB SI , 50
         JMP INPUTLOOP

    
HLT
MAIN ENDP
END MAIN