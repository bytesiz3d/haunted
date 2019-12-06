WWW             EQU     SPRITE_ID_WALL
_C_             EQU     SPRITE_ID_COIN
_F_             EQU     SPRITE_ID_FREEZE
_B_             EQU     SPRITE_ID_BIG_COIN
_D_             EQU     SPRITE_ID_DAMAGE
_T_             EQU     SPRITE_ID_TELEPORT
_G_             EQU     SPRITE_ID_X2_SPEED
___             EQU     0
levelMap        DB      WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW,WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW  
                DB      WWW, ___, _C_, _C_, _C_, _T_, _C_, _C_, _C_, WWW, _C_, _B_, _C_, WWW, _C_, _C_, _C_,_C_, _C_, _C_, _C_, _C_, _C_, _C_, _C_, WWW, _C_, _C_, _C_, ___, ___, WWW  
                DB      WWW, _C_, _C_, _C_, _C_, _C_, _C_, _C_, _C_, WWW, _C_, _C_, _C_, WWW, _C_, _C_, _C_,_C_, _C_, _C_, _C_, _T_, _C_, _C_, _C_, WWW, _C_, _C_, _C_, WWW, ___, WWW  
                DB      WWW, _C_, WWW, _C_, _C_, _C_, ___, _C_, _C_, WWW, _C_, _C_, _C_, WWW, _C_, _B_, _C_,_C_, WWW, _C_, _C_, _C_, _C_, _C_, _C_, WWW, _C_, _C_, _C_, WWW, ___, WWW  
                DB      WWW, _C_, WWW, _C_, _C_, _C_, ___, _C_, _C_, WWW, _C_, ___, _C_, WWW, _C_, _C_, _C_,_C_, WWW, _C_, _C_, _C_, _C_, _C_, _C_, WWW, _G_, _C_, _C_, WWW, ___, WWW  
                DB      WWW, _C_, WWW, _C_, _C_, _C_, ___, WWW, _C_, WWW, _C_, _C_, _C_, WWW, _C_, _C_, _C_,_C_, WWW, _G_, _C_, _C_, _C_, WWW, _C_, WWW, _C_, _C_, _C_, WWW, ___, WWW  
                DB      WWW, ___, WWW, _C_, _C_, _C_, ___, WWW, WWW, WWW, _C_, WWW, ___, WWW, ___, _C_, ___,_C_, WWW, _C_, _C_, ___, _C_, WWW, WWW, WWW, _C_, WWW, _C_, WWW, ___, WWW  
                DB      WWW, ___, WWW, _C_, _C_, _C_, ___, WWW, _C_, WWW, _C_, WWW, ___, WWW, _C_, _C_, ___,_C_, WWW, _C_, _C_, ___, _C_, WWW, _C_, WWW, _C_, WWW, _C_, WWW, ___, WWW  
                DB      WWW, ___, WWW, _G_, _C_, _C_, _C_, WWW, _C_, WWW, ___, WWW, ___, WWW, _C_, _C_, ___,_C_, WWW, _C_, _C_, ___, _C_, WWW, _C_, WWW, _C_, WWW, _C_, WWW, ___, WWW  
                DB      WWW, ___, WWW, _C_, _C_, _C_, _C_, WWW, _C_, WWW, ___, WWW, ___, WWW, _C_, _C_, ___,_C_, WWW, _C_, _C_, ___, _C_, WWW, _C_, WWW, _C_, WWW, _C_, WWW, ___, WWW  
                DB      WWW, ___, WWW, WWW, WWW, WWW, _C_, WWW, _C_, WWW, ___, WWW, ___, WWW, _C_, _C_, ___,_C_, WWW, WWW, WWW, WWW, _C_, WWW, _C_, WWW, _C_, WWW, _C_, WWW, ___, WWW  
                DB      WWW, ___, _C_, _C_, _C_, WWW, _C_, WWW, _C_, WWW, ___, WWW, ___, WWW, _C_, _C_, _C_,_C_, _C_, _C_, _C_, WWW, _F_, WWW, _C_, WWW, _C_, WWW, _C_, WWW, _C_, WWW  
                DB      WWW, ___, _C_, ___, _C_, _C_, WWW, WWW, _C_, _C_, ___, WWW, ___, _C_, _C_, _C_, _C_,_C_, _C_, _C_, _C_, _C_, WWW, WWW, _C_, _C_, _C_, WWW, _C_, _C_, _C_, WWW  
                DB      WWW, _C_, _C_, ___, _D_, _C_, WWW, WWW, _C_, _C_, ___, WWW, _C_, _C_, _C_, _C_, _C_,_D_, _C_, _C_, _C_, _C_, WWW, WWW, _C_, _C_, _C_, WWW, _C_, _C_, _C_, WWW  
                DB      WWW, _C_, _C_, ___, _C_, _C_, _C_, WWW, ___, ___, ___, WWW, _C_, _C_, ___, _C_, _C_,_C_, _C_, ___, _C_, _C_, _C_, WWW, _C_, _C_, _C_, WWW, _C_, ___, _C_, WWW  
                DB      WWW, _C_, _C_, ___, _C_, _C_, _C_, WWW, _C_, _C_, _C_, WWW, _G_, _C_, _C_, _C_, _C_,_C_, _C_, _C_, _C_, _C_, _C_, WWW, _C_, _C_, _C_, WWW, _C_, _C_, _C_, WWW  
                DB      WWW, _T_, _C_, _C_, _C_, _C_, _C_, _C_, _C_, _F_, _C_, WWW, _C_, _C_, _C_, _C_, _C_,_C_, _C_, _C_, _C_, _C_, _C_, _B_, _C_, _C_, _C_, WWW, _T_, _C_, _C_ ,WWW  
                DB      WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW,WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW, WWW  
        ;; Reserved for status/notification bars
                DB      ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___  
                DB      ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___  
                DB      ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___  
                DB      ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___  
                DB      ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___  
                DB      ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___  
