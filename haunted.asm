.MODEL SMALL
.STACK 64
.DATA
message	db	9, 9, "Haunted House", 13, 10, 10, 9, 9, "Game Over", "$"
.CODE
MAIN	PROC	FAR
	; Initialzing the data segment
	MOV	AX, @DATA
	MOV	DS, AX

	; Display the super cool message
	MOV	AH, 9
	MOV DX, OFFSET message
	INT	21H

	; Exit
	MOV	AH, 0
	INT 21H
MAIN	ENDP
END	MAIN
