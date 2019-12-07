WWW             EQU     SPRITE_ID_WALL
_C_             EQU     SPRITE_ID_COIN
_F_             EQU     SPRITE_ID_FREEZE
_B_             EQU     SPRITE_ID_BIG_COIN
_D_             EQU     SPRITE_ID_DAMAGE
_T_             EQU     SPRITE_ID_TELEPORT
_G_             EQU     SPRITE_ID_X2_SPEED
___             EQU     SPRITE_ID_EMPTY

;;; Will be read from a file
levelMap        DB      GRID_ROWS * GRID_COLUMNS dup(?)
