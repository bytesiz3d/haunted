;;; ============================================================================================
CheckDoubleSpeed         PROC    NEAR
	
	CMP     AL,15
	JNE	CheckDone
	
	CMP	currentGhost,1
	JE	Ghost__1
	
	ADD     AL,x2SpeedCounter_Ghost0
	JMP 	CheckDone
	
Ghost__1:	
	ADD     AL,x2SpeedCounter_Ghost1
	
CheckDone:
	RET
CheckDoubleSpeed         ENDP

;;; ============================================================================================
Teleport   PROC     NEAR

	CMP	teleportIndicator,2
	JE 	EndTeleport
		
	CMP	teleportIndicator,1		
	JE	teleport_player0

        mov	teleportIndicator,2
        mov     AX, Player_1		
        CALL    RCtoMapSprite
        CALL    DrawSprite

        mov	newPosition,021DH
        mov     SI, newPosition         ;Update position
        mov     Player_1, SI    
	jmp	EndTeleport
		
teleport_player0:
	mov	teleportIndicator,2		
	mov     AX, Player_0		
        CALL    RCtoMapSprite
        CALL    DrawSprite

        mov	newPosition,0202H
        mov     SI, newPosition         ;Update position
        mov     Player_0, SI    
		
EndTeleport:
        RET
Teleport        ENDP

;;; ============================================================================================
ReduceTimers    PROC    NEAR
        ;; Reduce active freeze timers
        CMP     freezeCounter_Player0, 0           
        JZ      END_PLAYER_0_FREEZE
        DEC     freezeCounter_Player0
END_PLAYER_0_FREEZE:   

        CMP     freezeCounter_Player1, 0           
        JZ      END_PLAYER_1_FREEZE
        DEC     freezeCounter_Player1
END_PLAYER_1_FREEZE:   

        ;; Reduce active double ghost speed timers
        CMP     x2SpeedCounter_Ghost0, 0           
        JZ      END_GHOST_0_X2_SPEED
        DEC     x2SpeedCounter_Ghost0
END_GHOST_0_X2_SPEED:   

        CMP     x2SpeedCounter_Ghost1, 0           
        JZ      END_GHOST_1_X2_SPEED
        DEC     x2SpeedCounter_Ghost1
END_GHOST_1_X2_SPEED:   
        RET
ReduceTimers    ENDP
