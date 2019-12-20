;.model small
;.stack 64
;.data 
;	Value_S db ?
;	Value_R db ?
;	point    dw 0D00h
;	point2   dw 0100h
;.code
;main proc far
;	mov ax , @data
;	mov ds , ax
Chat Proc near
		
	mov bl,0
	mov ax,0600h
	mov bh,01Fh
	mov cx,0
	mov dx,0B4fh
	int 10h	

	mov bl,0
	mov ax,0600h
	mov bh,4Fh
	mov cx,0C00h
	mov dx,184fh
	int 10h

	mov bx,0
	mov al,0
	mov cx,0

	mov ah,2
	mov dx,0C00h
	int 10h

	mov ah , 9
	mov dx , offset p1Name+2 
	int 21h

	mov ah,2
	mov dx,0000h
	int 10h

	mov ah , 9
	mov dx , offset p2Name+2 
	int 21h
	
	mov ah,2
	mov dx,word ptr point
	int 10h 
	mov bh,0    
	
	call UARTConf  	
send?Receive?:
	mov dx , 3FDH    ; Line Status Register
	in al , dx 
  	test al , 1
  	JZ next
	call Receive
	mov al,1 
	mov dx , 3FDH 
        out dx,al   
next:
	mov ah,1
	int 16h
        jz send?Receive?
        mov ah,0
	int 16h
	call Send
	jmp send?Receive?

exit1:
MOV SelectMode, 0
 	;mov     AH, 4Ch         ;Exit the program
 	;INT     21h
	RET
	JMP FAR PTR MAIN_MENU
Chat	ENDP

UARTConf Proc near

	mov dx,3fbh 			; Line Control Register
        mov al,10000000b		;Set Divisor Latch Access Bit
    	out dx,al			;Out it
    
        mov dx,3f8h			
    	mov al,0ch			
    	out dx,al
    
    	mov dx,3f9h
    	mov al,00h
    	out dx,al

    	mov dx,3fbh
    	mov al,00011011b
    	out dx,al
	ret
UARTConf endp

Send Proc near 
	
   	mov Value_S,al
	
	
	mov ah,4Fh
	cmp byte ptr point,ah
	jb snot_end_line

	mov ah,18h
	cmp byte ptr point[1],ah
	jb scheck_enter1

	mov word ptr point,1800h
	mov ah,2
	mov dx,word ptr point
	int 10h 
	mov bl,0
	mov ax,0601h
	mov bh,04Fh
	mov cx,0D00h
	mov dx,184fh
	int 10h
	jmp sDisplay

snot_end_line:

	mov ah,18h
	cmp byte ptr point[1],ah
	jb scheck_enter1
	cmp al,0Dh
	jne sDisplay
	mov word ptr point,1800h
	mov bl,0
	mov ax,0601h
	mov bh,04Fh
	mov cx,0D00h
	mov dx,184fh
	int 10h
	jmp sDisplay

scheck_enter1:
	cmp al , 0dh
	jne sDisplay
	mov byte ptr point,00h	
	inc byte ptr point[1]	
	jmp sDisplay
	
sDisplay:
	mov ah , 2
	mov dx,word ptr point
	int 10h 
	
	cmp al , 08h
	jnz S_notBackSpace
	

	mov ah , 2 
	mov dl , VALUE_S
	int 21h

	mov ah , 2
	mov dl , 20h
	int 21h

S_notBackSpace:
	
	mov ah , 3h 
	mov bh , 0h 
	int 10h
	mov word ptr point,dx

	mov dx ,3FDH		; Line Status Register
	AGAIN1:
  	In al,dx 			;Read Line Status
	test al , 00100000b
	jz AGAIN1

	mov dx , 3F8H		; Transmit data register
    mov  al,Value_S
  	out dx , al 
	
	mov  al,Value_S
	cmp al,27
    jnz return
    jmp far ptr MAIN_MENU
    
return:
	mov dl , VALUE_S
	mov ah ,2 
  	int 21h
	ret
Send    endp

Receive proc near 

	mov dx , 03F8H
	in al , dx 
	mov VALUE_R , al
	mov al, VALUE_R
	cmp al,27
    jnz rec
    jmp far ptr MAIN_MENU
rec:	
	mov ah,4Fh
	cmp byte ptr point2,ah
	jb not_end_line

	mov ah,0bh
	cmp byte ptr point2[1],ah
	jb check_enter1

	mov word ptr point2,0B00h
	mov ah,2
	mov dx,word ptr point2
	int 10h 

	mov bl,0
	mov ax,0601h
	mov bh,01Fh
	mov cx,0100h
	mov dx,0B4fh
	int 10h
	jmp Display

not_end_line:

	mov ah,0bh
	cmp byte ptr point2[1],ah
	jb check_enter1
	cmp al,0Dh
	jne Display
	mov word ptr point2,0B00h
	mov bl,0
	mov ax,0601h
	mov bh,01Fh
	mov cx,0100h
	mov dx,0B4fh
	int 10h
	jmp Display

check_enter1:
	cmp al,0Dh
	jne Display
	mov byte ptr point2,00h	
	inc byte ptr point2[1]	
	jmp Display
	
Display:
	mov ah,2
	mov dx,word ptr point2
	int 10h 
	
	cmp al,08h
	jnz notBackSpace

	mov ah,2
	mov dl, VALUE_R
	int 21h	
	mov ah,2
	mov dl,20h
	int 21h
	

notBackSpace:
	
    mov dl , VALUE_R
	mov ah ,2 
  	int 21h
	
	mov ah,3h 
	mov bh,0h 
	int 10h
	mov word ptr point2,dx
	ret

Receive endp
