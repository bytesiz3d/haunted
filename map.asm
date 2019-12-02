sW              EQU     SPRITE_ID_WALL
sC              EQU     SPRITE_ID_COIN
levelMap        DB     sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW, sW  
                DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
                DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
                DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
                DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
                DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
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
                DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
                DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
                DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
                DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
                DB     sW, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sW  
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
