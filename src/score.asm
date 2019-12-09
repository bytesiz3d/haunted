;; SB_name1        db      20,?,20 dup(':')
;; SB_name2        db      20,?,20 dup(':') 
;; SB_string       db      5 dup('$') 
;; enter           db      "Please enter player Name: " 
;; SB_ext          db      "'s score: " 
;; SB_line         db      128 dup('_') 
;; SB_space        db      5(32)
;; score_player_0  dw      500 
;; score_player_1  dw      457  
;; SB_count        dw      0

;;; ============================================================================================
;;; Convert any number to string then print it on the score board
IntToString     PROC    NEAR
        MOV     SI, OFFSET SB_STRING +4
        MOV     AX, BX 
        MOV     DL, 10   
        MOV     CL, 0
LOOP1:
        DIV     DL
        ADD     AH, '0'
        MOV     [SI], AH 
        DEC     SI
        MOV     AH, 0 
        INC     CL
        CMP     AX, 0
        JNZ     LOOP1
        
        MOV     AH, 13H
        INC     SI 
        MOV     BX, 000FH
        MOV     BP, SI  
        MOV     DX, DI
        INT     10H  
        RET
IntToString     ENDP

;;; ============================================================================================
;;;Print line above score board then print players and their score
ScoreBoard      PROC    NEAR                                                                                   
        MOV     AL, 0
        MOV     CH, 0
        MOV     BX, 000FH
	MOV     BP, OFFSET SB_LINE
        MOV     AH, 13H   
        MOV     CL, 80H 
        MOV     DX, 2B00H
        INT     10H 
        
        MOV     CX, 0
        MOV     DX, 02C6H
        MOV     SI, OFFSET Sprite_Player_0
        call    DrawSpriteXY 

        MOV     CX, 0290H 
        MOV     DX, 02C6H
        MOV     SI, OFFSET Sprite_Player_1
        call    DrawSpriteXY 

        MOV     CH, 0

        MOV     AL, 0
        MOV     BX, 0036H
        MOV     BP, OFFSET p1Name+2
        MOV     AH, 13H   
        MOV     CL, p1Name+1 
        MOV     DX, 2D05H
        INT     10H 
        
        MOV     BP, OFFSET SB_EXT
        ADD     DX, CX 
        MOV     CX, 10
        INT     10H 
        
        MOV     BX, 0000H
        MOV     AH, 13H
        MOV     BP, OFFSET SB_SPACE
        ADD     DX, 11
        MOV     CX, 5
        INT     10H
        
        MOV     BX, SCORE_PLAYER_0
        MOV     DI, DX
        call    IntToString
        
	
	
        MOV     BX, 000CH
        MOV     BP, OFFSET p2Name+2   
        MOV     CL, p2Name+1
        MOV     DX, 2D57H
        INT     10H
        
        MOV     BP, OFFSET SB_EXT
        ADD     DX, CX 
        MOV     CX, 10
        INT     10H 
        
        MOV     BX, 0000H         
        MOV     AH, 13H
        MOV     BP, OFFSET SB_SPACE
        ADD     DX, 11
        MOV     CX, 5
        INT     10H
        
        MOV     BX, SCORE_PLAYER_1
        MOV     DI, DX
        call    IntToString 
        
	MOV     BX, 0000H         
        MOV     AH, 13H
        MOV     BP, OFFSET SB_SPACE
        MOV     DX, 2D39H
        MOV     CX, 5
        INT     10H

        ;; Divide total frame count by (30 FPS)
        ;; Print in the scoreboard
        MOV     AX, totalFrameCount
        CWD
        MOV     BX, 30
        DIV     BX
        MOV     BX, AX
       	
	MOV     DX, 2D39H
        MOV     DI, DX
        call    IntToString

        RET 
ScoreBoard      ENDP
