include macros.asm
;;; ============================================================================================
        .MODEL LARGE
        .STACK 64

;;; ============================================================================================
        .DATA
include data.asm

;;; ============================================================================================
        .CODE
;;; Main menu
include menu.asm
        ;; Haunted_MainMenu
        ;; LoadSprites
        
;;; ============================================================================================
;;; Scoreboard
include score.asm
        ;; Scoreboard
        ;; InttoString
        
;;; ============================================================================================
;;; Draw procedures and utility functions
include draw.asm
        ;; RCtoMapIndex
        ;; RCtoMapSprite
        ;; in AX: Square_Row, Square_Column
        ;; in SI: Sprite offset
        ;; DrawSprite
        ;; DrawMap

;;; ============================================================================================
;;; Powerup utilities
include power.asm
        ;; CheckDoubleSpeed
        ;; Teleport
        ;; ReduceTimers
        
;;; ============================================================================================
;;; Ghost logic
include ghost.asm
        ;; in SI: Player position offset
        ;; in DI: Ghost position offset
        ;; in BX: Ghost sprite offset
        ;; MoveGhost
        ;; ShoveGhost
        ;; MoveGhost2XChecker
        ;; CheckGhostCollision

;;; ============================================================================================
MAIN    PROC    FAR

        mov     AX, @DATA
        mov     DS, AX
        mov     ES, AX

        ;; Clear the screen
        mov     AX, 4F02H
        mov     BX, 0105H
        INT     10H   


		X:
		
		LEA     DI, Sprite_Teleport
        LEA     SI, tpFilename
        CALL    LoadSprite

        ;; Double ghost speed sprite
        LEA     DI, Sprite_x2_Speed
        LEA     SI, x2Filename
        CALL    LoadSprite
      
        CALL    DrawMap         

		
		
		
		
		
		
		Get_mouse_info:  ;----> CX : X - DX : Y - BX = 1 left btn pressed , = 2 rigtt , = 3 both
		mov     AX, 3 
        mov     BX, 0
        INT     33H
		
		CMP		BX,1
		JNE		Get_mouse_info
		
		;; in AH: Row, AL: Column
	
		mov		AH,DL
		mov		AL,CL
		
		CALL RCtoMapIndex
		
		
		CMP		BX,576
		JL		notoption
		
		CMP		BX,620
		JL		Get_mouse_info
		JE		choseCoin
		
		CMP		BX,627
		JG		Get_mouse_info
		JE		chose2X

		CMP		BX,621
		JE		choseBigCoin
		
		CMP		BX,622
		JE		choseWall
		
		CMP		BX,623
		JE		choseNull
		
		CMP		BX,624
		JE		choseFreeze
		
		CMP		BX,625
		JE		choseDamage
		
		CMP		BX,626
		JE		choseTeleport
		
		choseCoin:
		mov	    DL,_C_
		JMP		Get_mouse_info
		
		
		chose2X:
		mov		DL,_G_
		JMP		Get_mouse_info
		
		choseBigCoin:
		mov	    DL,_B_
		JMP		Get_mouse_info
		
		
		choseWall:
		mov		DL,WWW
		JMP		Get_mouse_info
		
		choseNull:
		mov	    DL,___
		JMP		Get_mouse_info
		
		
		choseFreeze:
		mov		DL,_F_
		JMP		Get_mouse_info
		
		choseDamage:
		mov	    DL,_D_
		JMP		Get_mouse_info
		
		
		choseTeleport:
		mov		DL,_T_
		JMP		Get_mouse_info
		
		notoption:
		
		mov		levelMap[BX],DL
				
		JMP		X

		
MAIN    ENDP

;;; ============================================================================================
END     MAIN
