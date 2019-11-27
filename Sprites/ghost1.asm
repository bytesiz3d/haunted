.model large
.stack 64
.data 
;          1   2   3   4   5   6   7   8   9   10  11  12  13  14  15   16
player1 DB 0  ,0  ,0  ,0  ,0  ,0  ,6  ,6  ,6  ,6  ,0  ,0  ,0  ,0  ,0  , 0   
	    DB 0  ,0  ,0  ,0  ,0  ,6  ,15 ,15 ,15 ,15 ,6  ,0  ,0  ,0  ,0  , 0 
	    DB 0  ,0  ,0  ,0  ,6  ,15 ,15 ,15 ,15 ,15 ,15 ,6  ,0  ,0  ,0  , 0 
	    DB 0  ,0  ,0  ,6  ,15 ,15 ,15 ,15 ,15 ,15 ,15 ,15 ,6  ,0  ,0  , 0 
	    DB 0  ,0  ,0  ,6  ,15 ,15 ,15 ,15 ,15 ,15 ,15 ,15 ,6  ,0  ,0  , 0 
	    DB 0  ,0  ,6  ,15 ,6  ,6  ,15 ,15 ,15 ,6  ,6  ,15 ,15 ,6  ,0  , 0 
	    DB 0  ,0  ,6  ,6  ,6  ,6  ,15 ,15 ,15 ,6  ,6  ,6  ,15 ,6  ,0  , 0 
	    DB 0  ,0  ,6  ,6  ,6  ,6  ,15 ,15 ,15 ,6  ,6  ,6  ,15 ,6  ,0  , 0 
	    DB 0  ,0  ,6  ,15 ,6  ,6  ,15 ,15 ,15 ,15 ,6  ,6  ,15 ,6  ,0  , 0 
	    DB 0  ,0  ,6  ,15 ,15 ,15 ,15 ,15 ,15 ,15 ,15 ,15 ,15 ,6  ,0  , 0 
	    DB 0  ,6  ,15 ,15 ,15 ,15 ,15 ,6  ,6  ,15 ,15 ,15 ,15 ,6  ,0  , 0 
	    DB 0  ,6  ,15 ,15 ,15 ,15 ,15 ,6  ,6  ,15 ,15 ,15 ,15 ,6  ,6  , 6 
	    DB 0  ,6  ,6  ,6  ,15 ,15 ,15 ,15 ,15 ,15 ,15 ,6  ,6  ,15 ,15 , 6 
	    DB 0  ,0  ,0  ,6  ,15 ,15 ,15 ,15 ,15 ,15 ,6  ,15 ,15 ,15 ,15 , 6 
	    DB 0  ,0  ,0  ,6  ,6  ,6  ,15 ,15 ,15 ,15 ,6  ,6  ,15 ,15 ,6  , 6 
	    DB 0  ,0  ,0  ,0  ,0  ,6  ,6  ,6  ,6  ,6  ,6  ,6  ,6  ,6  ,0  , 0 

xy   DB 100,100    ;x,y
size1 equ 16
.code    

MAIN PROC FAR
    MOV AX,@DATA
    MOV DS,AX 
    
    MOV AX,4F02H
    MOV BX,105H
    ;MOV AX,0013h
    INT 10H
    
    CALL DrawShape
    
    mov ah,0 
    int 16h
HLT
MAIN ENDP


DrawShape PROC NEAR 
;///////////
;Draw Square
;///////////
    mov dh,0
    mov ch,0   
    mov cl,xy     ;column 
    mov dl,xy+1     ;row
    mov si,offset player1   ;color
    mov ah,0ch
    mov bl,size1
    mov bh,size1
    
L2:  
 L1:mov al,[si]
    int 10h
    inc si
    inc cx
    dec bl
    cmp bl,0
    jnz L1 
    mov bl,size1    
    mov cl,xy
    inc dx
    dec bh   
    cmp bh,0
    jnz L2  
 RET
DrawShape ENDP
     END MAIN 
     
