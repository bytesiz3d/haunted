        ;; in num: Player number
mDrawPlayer     MACRO   playerNum
        MOV     AX, Sprite_SIZE
        MOV     SI, playerNum
        MUL     SI
        MOV     SI, AX          ;playerNum * Sprite_SIZE
        
        MOV     BX, playerNum
        SHL     BX, 1           ;playerNum * 2
        
        MOV     AX, Player_Base[BX]
        ADD     SI, offset Sprite_Player_Base
        CALL    DrawSprite
ENDM    mDrawPlayer

        ;; in Pn, Gn: Player number, Ghost number
mDrawGhost      MACRO   Pn, Gn
        mov     AX, Ghost_Base[(Pn * Ghost_PER_PLAYER + Gn)*2]
        mov     SI, offset Sprite_Ghost_Base[Pn*Sprite_SIZE]
        CALL    DrawSprite
ENDM    mDrawGhost

mDrawEntities   MACRO
        mDrawPlayer     0
        mDrawPlayer     1

        mDrawGhost      0, 0
        mDrawGhost      1, 0
ENDM    mDrawEntities
