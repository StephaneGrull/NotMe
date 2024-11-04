ORG 4200h
    LD SP, 0C000h           ; Tout les progs commencent par cette instruction
    LD DE, 2050H ;(X1=20, Y=50)
    LD H, 50H ;(X2=50)
    CALL 0A06H
    boucle:
    JP boucle