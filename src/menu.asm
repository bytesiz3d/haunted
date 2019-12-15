;; HauntedWidth            EQU     320
;; HauntedHeight           EQU     89
;; HauntedFilename         DB      'practice\h.bin', 0
;; fileHandle       DW      ?
;; HauntedData             DB      HauntedWidth*HauntedHeight dup(0)
;; P1Name                  DB      10, ?, 10 dup("$")
;; P2Name                  DB      10, ?, 10 dup("$")
;; NewGame                 DB      0 , 0, 0 , "NEW GAME", 0 , 0 , 0
;; Quit                    DB      0 , 0, 0 , "QUIT", 0 , 0 , 0                 
;; playername              DB      'Player$', ' Name: $'
;; choose_msg              DB      17,"Choose Your level"
;; level1_msg              DB      14,"Level 1 ==> F1"
;; level2_msg              DB      14,"Level 2 ==> F2" 
;; lv1Filename             DB      "lv1", 0
;; lv2Filename             DB      "lv2", 0
;; lvChosen                DW      ?                
;;; ===============================================================================
;;; File handling
OpenFile        PROC    NEAR
        ;; Open file
        MOV     AH, 3Dh
        MOV     AL, 0 ; read only
        LEA     DX, HauntedFilename
        INT     21h
    
        ;; you should check carry flag to make sure it worked correctly
        ;; carry = 0 -> successful , file handle -> AX
        ;; carry = 1 -> failed , AX -> error code
        MOV     [fileHandle], AX
        RET
OpenFile        ENDP

;;; ===============================================================================
ReadData        PROC    NEAR
        MOV     AH, 3Fh
        MOV     BX, [fileHandle]
        MOV     CX, HauntedWidth * HauntedHeight ; number of bytes to read
        LEA     DX, HauntedData
        INT     21h
        RET
ReadData        ENDP 

;;; ===============================================================================
CloseFile       PROC    NEAR
        MOV     AH, 3Eh
        MOV     BX, [fileHandle]
        INT     21h
        RET
CloseFile       ENDP

;;; ===============================================================================
        ;; in SI: Filename offset, (null-terminated)
        ;; in DI: Destination offset
        ;; in CX: Number of bytes to read
LoadBuffer      PROC    NEAR
        ;; Open File
        MOV     AH, 3Dh
        MOV     AL, 0
        MOV     DX, SI
        INT     21h
        MOV     [fileHandle], AX

        ;; Read data
        MOV     AH, 3Fh
        MOV     BX, [fileHandle]
        ;; MOV     CX, SPRITE_SIZE
        MOV     DX, DI
        INT     21h

        ;; Close File
        MOV     AH, 3Eh
        MOV     BX, [fileHandle]
        INT     21h       

        RET
LoadBuffer      ENDP

;;; ===============================================================================
Haunted_MainMenu        PROC    NEAR
        CALL    OpenFile
        CALL    ReadData
        LEA     BX, HauntedData ;BL contains index at the current drawn pixel
        MOV     CX, 352         ;column                                    
        MOV     DX, 200         ;row                                                     
        MOV     AH, 0ch                                                         
        
drawLoop:                                                                  
        MOV     AL, [BX]                                                        
        cmp     al, 00                                                          
        je      cont                                                            
        INT     10h                                                            
cont:                                                              
        INC     CX                                                             
        INC     BX                                                             
        CMP     CX, HauntedWidth+352                                            
        JNE     drawLoop                                                               
        
        MOV     CX, 352                                                       
        INC     DX                                                             
        CMP     DX, HauntedHeight+200                                           
        JNE     drawLoop                                                               
        
        call    CloseFile                                                     
        call    CloseFile                                                     
        
        MOV     CH, 0DH                                                        
        MOV     CL, 0FH                                                        
        
CHANGECHOSEN:                                                      
        MOV     SI, OFFSET [NewGame]                                            
        MOV     DI, 0                                                           
        MOV     DL, 30 ;X                                                       
        MOV     DH, 30 ;Y                                                       
        XCHG    CL, CH                                                         
        

WriteNewGame:                                                      
        MOV     BL, CL                                                          
        MOV     AH, 2                                                           
        INC     DX                                                             
        INT     10H                                                            
        
        MOV     AH, 9 ;Display                                                  
        MOV     BH, 0 ;Page 0                                                   
        MOV     AL, [SI] ;Letter                                                
        INC     SI                                                             
        PUSH    CX                                                            
        MOV     CX, 1H ;5 times                                                 
        INT     10H                                                            
        POP     CX                                                             
        INC     DI                                                             
        CMP     DI, 10+4                                                        
        JL      WriteNewGame                                                    
        
        MOV     SI, OFFSET[QUIT]                                               
        MOV     DI, 0                                                           
        MOV     DL, 80 ;X                                                       
        MOV     DH, 30 ;Y                                                       
        
        
WriteQuit:                                                         
        MOV     AH, 2                                                           
        INC     DX                                                             
        INT     10H                                                            
        MOV     BL, CH                                                          
        
        MOV     AH, 9 ;Display                                                  
        MOV     BH, 0 ;Page 0                                                   
        MOV     AL, [SI] ;Letter                                                
        INC     SI                                                             
        PUSH    CX                                                            
        MOV     CX, 1H ;5 times                                                 
        INT     10H                                                            
        POP     CX                                                             
        INC     DI                                                             
        CMP     DI, 6+4                                                         
        JL      WriteQuit                                                       
        
        
WaitTillChoose:                                                    
        MOV     AH, 0                                                           
        INT     16h                                                            
        CMP     AH, 4BH                                                         
        JE      CHANGECHOSEN                                                    
        CMP     AH, 4DH                                                         
        JE      CHANGECHOSEN                                                    
        
        CMP     AH, 1CH                                                         
        JE      Chosen                                                          
        
        JMP     WaitTillChoose                                                 
        
Chosen:                                                            
        CMP     CL, 0DH                                                        
        JE      StartGame                                                       
        mov     AX, 3h          ;Return to text mode
        INT     10h
        MOV     AH, 4CH         ;Exit the program
        INT     21H 

StartGame:
        
        MOV     CH, 0
        MOV     AL, 0
        MOV     BX, 0000H
        MOV     BP, OFFSET SB_space
        MOV     AH, 13H   
        MOV     CL, 120 
        MOV     DX, 1E1DH
        INT     10H
        
        MOV     CH, 0
        MOV     AL, 0
        MOV     BX, 000DH
        MOV     BP, OFFSET choose_msg+1
        MOV     AH, 13H   
        MOV     CL, BYTE PTR choose_msg 
        MOV     DX, 2337H
        INT     10H  
        
        MOV     BX, 00FH
        MOV     BP, OFFSET level1_msg+1
        MOV     AH, 13H   
        MOV     CL, BYTE PTR level1_msg 
        MOV     DX, 2539H
        INT     10H     
        
        MOV     BP, OFFSET level2_msg+1
        MOV     AH, 13H   
        MOV     CL, BYTE PTR level2_msg 
        MOV     DX, 2639H
        INT     10H     
        
IS_CHOSEN:  
        
        MOV     AH, 0                                                           
        INT     16h                                                            
        CMP     AH, 3BH                                                         
        JNE     IS_F2
             
        MOV     SI, OFFSET lv1Filename
        MOV     WORD PTR lvChosen, SI
        jmp     PLAYERS_NAMES
IS_F2:        
        CMP     AH, 3CH                                                         
        jNE     IS_CHOSEN
        
        MOV     SI, OFFSET lv2Filename
        MOV     WORD PTR lvChosen, SI
        
PLAYERS_NAMES:  

        MOV     CH, 0
        MOV     AL, 0
        MOV     BX, 0000H
        MOV     BP, OFFSET SB_space
        MOV     AH, 13H   
        MOV     CL, 20 
        MOV     DX, 2337H
        INT     10H  
               
        MOV     DX, 2539H
        INT     10H  
       
        MOV     DX, 2639H
        INT     10H  
        
        
        MOV     DL, 31 ;X               
        MOV     DH, 30 ;Y                                       
        MOV     AH, 2
        INT     10H
        mov     ah, 9
        mov     dx, offset playername
        int     21h
        mov     ah, 2
        mov     dl, '1'
        int     21h 
        mov     ah, 9
        mov     dx, offset playername[7]
        int     21h 
        
        mov     ah, 0AH
        mov     dx, offset P1Name
        int     21h 
        
        
        MOV     DL, 81 ;X               
        MOV     DH, 30 ;Y                                       
        MOV     AH, 2
        INT     10H
        mov     ah, 9
        mov     dx, offset playername
        int     21h
        mov     ah, 2
        mov     dl, '2'
        int     21h 
        mov     ah, 9
        mov     dx, offset playername[7]
        int     21h 
        
        
        mov     ah, 0AH
        mov     dx, offset P2Name
        int     21h 
        RET
Haunted_MainMenu        ENDP
        
;;; ===============================================================================
        ;; Reset all game state variables
ResetGame       PROC    NEAR
        
        CALL    RandomRC
        mov     Player_0, AX

        CALL    RandomRC
        mov     Player_1, AX

        CALL    RandomRC
        mov     Ghost_00, AX

        CALL    RandomRC
        mov     Ghost_10, AX

        mov     Score_Player_0, 0000h
        mov     Score_Player_1, 0000h
        
        mov     freezeCounter_Player0, 0
        mov     freezeCounter_Player1, 0

        mov     x2SpeedCounter_Ghost0, 0
        mov     x2SpeedCounter_Ghost1, 0

        mov     ghostCounter, ghostDelay
        mov     totalFrameCount, 30 * 60

        RET
ResetGame       ENDP 
        
