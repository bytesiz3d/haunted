sW              EQU     SPRITE_ID_WALL
sC              EQU     SPRITE_ID_COIN
sF              EQU     SPRITE_ID_FREEZE
sB             EQU     SPRITE_ID_BIG_COIN
levelMap        DB     sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW  
                DB     sW, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, sW  
                DB     sW, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, sW  
                DB     sW, 00, 00, 00, 00, 00, sF, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, sF, 00, 00, 00, 00, sW  
                DB     sW, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, sW  
                DB     sW, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, sW  
                DB     sW, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sW  
                DB     sW, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sW  
                DB     sW, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sW  
                DB     sW, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sW  
                DB     sW, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sW  
                DB     sW, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sW  
                DB     sW, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sW  
                DB     sW, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sW  
                DB     sW, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sW  
                DB     sW, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sW  
                DB     sW, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sW  
                DB     sW, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sC, sW  
                DB     sW, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, sW  
                DB     sW, 00, 00, 00, 00, 00, 00, sB, 00, 00, 00, 00, 00, sF, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, sW  
                DB     sW, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, sW  
                DB     sW, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, sW  
                DB     sW, 00, 00, 00, 00, 00, 00, 00, 00, sB, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, sW  
                DB     sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW  

;; levelMap        DB     sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
;;         DB     sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW  
