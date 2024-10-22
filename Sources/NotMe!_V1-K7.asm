; NOT ME, 2024                                            ;
; A game fot gamejam organized by 
; Code Assembler Z80 by DarkSteph                         ;
CLS                 equ 0D2Fh
SETSCR              equ 0D30h
SETCOL              equ 0636h
CHRCOL              equ 062Eh
PUTSTR              equ 0D0Ch
DELAY               equ 07F6h
KEY                 equ 07E0h
PUTCHR              equ 0C62h
ADDVIDTOKENP1       equ E70Ch
ADDVIDTOKENP2       equ E728h
INITADDRESSWORD     equ 21C3h
WORDSNUMBER         equ 0x22
PRINTLETTERADD      equ 9601h
E_AIGU              equ 7Bh  
E_GRAVE             equ 7Dh
A_ACCENT            equ 60h   

MACRO DELAYMACRO mavar
    repeat {mavar}
    CALL DELAY
    rend
MEND

;TODO 
; Mettre en place le systeme de fin de jeu lorsque qu'un joueur perd [OK]
; Mettre en place le systeme de fin quand un joueur Gagne en trouvant toutes les lettres [OK]
; mettre en place l'affichage du pendu de chaque joueur [OK]
    ; bug sur l'affichage : lorsque l'on trouve une bonne lettre, une mauvaise lettre suivante n'affiche pas le pendu [OK]
    ; Bug lorque l'on choisit 1 player [OK]
; Suite de petits carres pour les jambes.
; Mettre en place la gestion du tirage au sort du mot [OK]
; Mettre en place l'écran de titre. [OK]
; bug 1 player lorsqu'on trouve le mot

ORG 4C00h
    LD SP, 0C000h           ; Tout les progs commencent par cette instruction
start:
    CALL CLS                ; Clear screen
initColors:                 ; 0=black(0)(00), 1=yellow(3)(01), 2=blue(4)(10), 3=white(7)(11), 4=half light = false
    LD BC, colors_title     ; Load colors table to BC
    CALL SETCOL             ; Set palet colors (4 colors)
gameScreenTitle:
    LD A, 0                 ; Load color screen 0=black
    CALL SETSCR             ; Set screen color 0, black (do cls in same time)
    LD HL, splashScreen     ; Load splashScreen adress in HL
    LD DE, 0xC000           ; Load Adress Screen begin 
    LD BC, 0xDF00           ; Load image length in byte
    CALL ShowScreen
    gameScreenTitleKeyDetection:            ; Waiting to press a key
        CALL KEY                            ; Test if a key is pressed
        JR C, gameScreenTitlekeyDetection   ; Loop if key not pressed
    ;JP main
preMain:                        ; Load first screen and history
    LD BC, colors_pre_game      ; 0=black(0)(00), 1=white(7)(01), 2=cyan(6)(10), 3=green(2)(11), 4=half light = false
    CALL SETCOL                 ; Set palet colors (4 colors)
    LD A, 0                     ; Load color screen 0=black
    CALL SETSCR                 ; Set color 0, black (do cls in same time)
    LD C, 2                     ; Load color pen 2=Cyan
    CALL CHRCOL                 ; Apply color 2 to pen
    DELAYMACRO 10
    LD BC, h01:         ; Load Adress sentence "Annee 1453, les temps sont durs."
    LD DE, 0A0Ah        ; X, Y positions
    CALL PutstrDelay    ; Displays text
    LD BC, h05:         ; Load Adress sentence "Le maire de la ville d'Hectorland"
    LD DE, 0A15h        ; X, Y positions
    CALL PutstrDelay    ; Displays text on screen
    LD BC, h10:         ; Load Adress sentence "vous a trouve chez lui, dans son lit."
    LD DE, 0A20h        ; X, Y positions
    CALL PutstrDelay    ; Displays text on screen
    LD BC, h15:         ; Load Adress sentence "Et pas tout seul, avec sa femme."
    LD DE, 0A2Bh        ; X, Y positions
    CALL PutstrDelay    ; Displays text on screen
    LD C, 3             ; Load color pen 3=Green
    CALL CHRCOL         ; Text color = 3 (green)
    LD BC, h20:         ; Load Adress sentence "Ni une, ni deux, ni trois d'ailleurs,"
    LD DE, 0A3Bh        ; X, Y positions
    CALL PutstrDelay    ; Displays text on screen
    LD BC, h22:         ; Load Adress sentence "helloStr"
    LD DE, 0A46h        ; X, Y positions
    CALL PutstrDelay    ; Displays text on screen
    LD BC, h25:         ; Load Adress sentence "helloStr"
    LD DE, 0A51h        ; X, Y positions
    CALL PutstrDelay    ; Displays text on screen
    LD BC, h27:         ; Load Adress sentence "helloStr"
    LD DE, 0A5Ch        ; X, Y positions
    CALL PutstrDelay    ; Displays text on screen
    LD BC, h30:         ; Load Adress sentence "helloStr"
    LD DE, 0A6Ch        ; X, Y positions
    CALL PutstrDelay    ; Displays text on screen
    LD BC, h32:         ; Load Adress sentence "helloStr"
    LD DE, 0A77h        ; X, Y positions
    CALL PutstrDelay    ; Displays text on screen
    LD C, 1             ; Load color pen 1=White
    CALL CHRCOL         ; Text color = 0 (black)
    LD BC, h35:         ; Load Adress sentence "helloStr"
    LD DE, 0A87h        ; X, Y positions
    CALL PutstrDelay    ; Displays text on screen
    LD BC, h40:         ; Load Adress sentence "helloStr"
    LD DE, 0A92h        ; X, Y positions
    CALL PutstrDelay    ; Displays text on screen
    LD BC, h45:         ; Load Adress sentence "helloStr"
    LD DE, 0A9Dh        ; X, Y positions
    CALL PutstrDelay    ; Displays text on screen
    LD BC, h50:         ; Load Adress sentence "helloStr"
    LD DE, 3FA8h        ; X, Y positions
    CALL PutstrDelay    ; Displays text on screen
    LD C, 2             ; Load Color pen 2=Cyan
    CALL CHRCOL         ; Apply text color=2 (Cyan)
    ; Show rect text background
    LD BC, backgroundText01
    CALL 0D5Dh
    ; End show rect text background
    LD C, 0             ; Load Color pen 2=Cyan
    CALL CHRCOL         ; Apply text color=2 (Cyan)
    LD BC, pressKeyStr  ; Show str "Appuyez sur une touche"
    LD DE, 30C8h        ; X, Y positions
    CALL PutstrDelay    ; Displays text on screen
    preMainKeyDetection:
        CALL KEY                    ; Test if a key is pressed
        JR C, preMainkeyDetection   ; Loop if key not pressed
main:   ; If key is pressed, next 
    colorInit:
        LD BC, colors_games     ; Load colors table to BC
        CALL SETCOL             ; Set palet colors (4 colors)
        LD A, 0                 ; Load color 0 (Black) in A
        CALL SETSCR             ; Set color screen 0 : black (do cls in same time)
        LD C, 2                 ; Load Color pen 2=Cyan
        CALL CHRCOL             ; Apply text color=2 (Cyan)
    choosePlayerNumber:
        LD BC, nbrPlayerStr     ; Show str "Nombre de joueur(s) (1 ou 2):"   
        LD DE, 1555h            ; X, Y positions
        CALL PUTSTR             ; Displays text on screen  
        choosePlayerKeyDetection:
            CALL KEY            ; Test if a key is pressed
            JR C, choosePlayerkeyDetection
            Oneplayer:          
                CP 0x31         ; Test if key 1 is pressed
                JR Z, storePlayers
            Twoplayers:
                CP 0x32         ; Test if key 2 is pressed
                JR NZ, choosePlayerKeyDetection ; if not key 1 and not key 2 return to loop
            storeplayers:
            LD (playersNumber),A    ; Store Key (in reg A) to playerNumber (1 or 2)
            LD C,A                  ; Put A (CHR value) to C (param)
            LD DE, C555h            ; Destination Adress
            CALL PUTCHR             ; Display CHR in screen (1 or 2) 
            DELAYMACRO 2
            ; Beguin Name of players
            debugrecupchr:
                LD BC, namePlayer       ; Load Adress sentence "Entrez votre pseudo, fin avec ENTER"
                LD DE, 0588h            ; X, Y positions
                CALL PUTSTR             ; Display CHR in screen (1 or 2) 
                LD BC, player1Temp      ; Load Adress sentence "Player 1"
                LD DE, 0592h            ; X, Y positions
                CALL PUTSTR             ; Display CHR in screen (1 or 2) 
                LD BC, deuxpoints       ; Load Adress sentence "Player 1"
                LD DE, 3593h            ; X, Y positions
                CALL PUTSTR             ; Display CHR in screen (1 or 2) 
                LD DE, 4092h            ; Destination Adress
                LD IX, player1          ; Load adress of player name
                PUSH DE
                preDebugCHR:
                    CALL KEY                ; Test if a key is pressed
                    JR C, preDebugCHR       ; Loop if key not pressed
                    CP 0x30                 ; Compare with 0
                    JR Z, goToNamePlayer2   ; If Key is 0, end player 1 and go to player 2
                    LD (IX), A
                    INC IX
                    LD C,A                  ; Put A (CHR value) to C (param)
                    POP DE
                    PUSH DE
                    CALL PUTCHR             ; Display CHR in screen (1 or 2) 
                    POP DE
                    LD A, D
                    ADD A, 0x7
                    LD D, A
                    PUSH DE
                    JR preDebugCHR
                    goToNamePlayer2:
                        LD (IX), 0
                        ;Test si 1 joueur
                        LD A, (playersNumber)
                        debugChangeName:
                        CP 0x31
                        CALL Z, changeNamePlayer2
                        JR Z, wordChoose
                        LD BC, player2Temp      ; Load Adress sentence "Player 1"
                        LD DE, 059Ch            ; X, Y positions
                        CALL PUTSTR             ; Display CHR in screen (1 or 2) 
                        LD BC, deuxpoints          ; Load Adress sentence "Player 1"
                        LD DE, 359Dh            ; X, Y positions
                        CALL PUTSTR             ; Display CHR in screen (1 or 2) 
                        LD DE, 409Ch            ; Destination Adress
                        LD IX, player2
                        PUSH DE
                        namePlayer2
                            CALL KEY            ; Test if a key is pressed
                            JR C, namePlayer2   ; Loop if key not pressed
                            CP 0x30
                            JR Z, endNamePlayer
                            LD (IX), A
                            INC IX
                            LD C,A                  ; Put A (CHR value) to C (param)
                            POP DE
                            PUSH DE
                            CALL PUTCHR             ; Display CHR in screen (1 or 2) 
                            DELAYMACRO 1
                            POP DE
                            LD A, D
                            ADD A, 0x7
                            LD D, A
                            PUSH DE
                            JR namePlayer2

                    endNamePlayer:
                    LD (IX), 0
    wordChoose:
        CALL CLS                    ; Clear screen
        randomLoop:                 ; Choose number for determine word to play
            CALL random             ; 
            CP 0
            JR Z, randomLoop        ; 
            CP WORDSNUMBER
            JR NC, randomLoop
            ;JR Z, storeWordAdress
        storeWordAdress:            ; With word number, determine word adress
            LD HL,firstWord         ; Load adress of first word
            LD B, A                 ; Load word number
            PUSH HL
            loopStoreWordAdress:    ; For each word
                LD A, (HL)
                INC HL
                CP 0
                JR NZ, loopStoreWordAdress
                POP IX
                PUSH HL
                DJNZ loopStoreWordAdress:       ; Until B = 0, INC adress word (in foction of len word)
            POP HL
            LD (tempAdressWord), HL
            LD DE,  F2C8h
    printWordTiret:
        LD A,(HL)
        CP 0x0             ; le chiffre 0 en hexa : 48
        JR Z, next
        PUSH HL             ; Save Add word on stack
        ; Calcul len Word
        LD A,(lenWord)
        INC A               ; Add 1 to len word
        LD (lenWord),A
        ;End Calcul len Word
        ; Draw Tiret
        LD HL,  WordTiret   
        PUSH DE
        LD BC, 0x2
        LDIR
        ; End Draw Tiret
        POP DE
        INC DE, DE, DE
        POP HL
        INC HL
        JR printWordTiret
    next:
        drawBackground:
            LD BC, Background01     ; Adress for rec01 table
            CALL 0D5Dh              ; Draw rect
            LD BC, Background02     ; Adress for rec01 table
            CALL 0D5Dh              ; Draw rect
            LD BC, Background03     ; Adress for rec01 table
            CALL 0D5Dh              ; Draw rect
            LD BC, rope01           ; Adress for rec01 table
            CALL 0D5Dh              ; Draw rect
            LD C, 2                 ; Load pen color
            CALL CHRCOL             ; Set color chr = 2
            LD BC, player1
            LD DE, 20A8h            ; X, Y positions
            CALL PUTSTR             ; Displays text on screen
            LD BC, player2
            LD DE, 90A8h            ; X, Y positions
            CALL PUTSTR             ; Displays text on screen
            LD HL, tokenSprite
            LD DE, ADDVIDTOKENP1
            CALL drawLineWithPixel
            ; player 2 crossed out if one player chooses
            LD A, (playersNumber)
            CP 0x31
            CALL Z, CrossedPlayer
            LD A, (playersNumber)
            CP 0x32
            CALL Z, RopePlayer2   
    showExitMessage:        ; Show Exit message on bottom right screen
        LD C, 2             ; Load text color
        CALL CHRCOL         ; Text color = 2 
        LD BC,exitMessage   ; Adress sentence "helloStr"
        LD DE, 90D0h        ; Y, X positions
        CALL PUTSTR         ; Displays text on screen
    initVariables:                      ; Init variables
        LD HL, penduPlayer1Tete          ; Load adresse of pendu player 1 head
        LD (player1OffsetPendu), HL     ; Save Offset(HL) in player1OffsetPendu variable
        LD (player2OffsetPendu), HL     ; Save Offset(HL) in player2OffsetPendu variable
        LD HL, PRINTLETTERADD           ; Load adress of first tiret (letter to find)
        LD (tempPrintLetter), HL        ; Save adress of first tiret in tempPrintLetter variable
    mainLoop:
        CALL KEY                        ; Test if a key is pressed
        JR C, mainLoop                  ; Loop if key not pressed
        PUSH AF
        LD (lastLetterChooseCHR), A     ; Store the letter chosen by player
        CP 0x20                         ; If key is SPACE
        JR Z, exit                      ; Exit game
        POP AF
        PUSH AF
        CALL PrintLetter            
        POP AF
        CALL ShowLettersPlayerChoice        ; Print letter if letter is in word or decrease PlayerScore if letter is not in word
        CALL ShowLettersPlayer
        ; Detect if player letter was in word
        CALL LetterWasInWord
        CALL PlayerLost                     ; The routine LetterWasInWord return 0 (player loose) or 1 (player not loose) in reg A
        CP 0
        JR Z, mainloopNext
        CALL PlayerWin
        CP 0
        JR Z, mainloopNext
        ;debug:
        LD A, (playersNumber)
        CP 0x31
        JR Z,  mainloopNext
        CALL ChangeTokenPlayer              ; Change token to another player
        CALL ChangeActivePlayer             ; Change active player
        mainloopNext: 
            JP mainLoop
Exit:
    CALL CLS                ; Clear screen
    LD C, 2                 ; Load pen color
    CALL CHRCOL             ; Text color = 3 (green)
    LD BC, end01            ; "Voulez-vous rejouer une partie (O/N) ?"
    LD DE, 023Ah            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    chooseYesorNoLoop:
            CALL KEY        ; Test if a key is pressed
            JR C, chooseYesorNoLoop ; If no, goto start loop
    debugjaune:                 ; If yes
        CP 0x4F                 ; Test key "O"
        JP Z, suite            ; If "o" goto "ExitOK"
        CP 0x6F                 ; Test key "O"
        JP Z, suite            ; If "O" goto "ExitOK"
        CP 0x4E                 ; Test key "N"
        JR Z, exitOK              ; If "N", goto "suite"
        CP 0x6E
        JR Z, exitOK              ; If "n", goto "suite"
        JP  chooseYesorNoLoop   ; If not O and not N goto start loop
    suite:                      ; init all the variables
        LD A, 0x36
        LD (player1Score), A
        LD (player2Score), A
        LD HL, 0x0
        LD (player1OffsetPendu), HL
        LD (player2OffsetPendu), HL
        LD (tempPrintLetter), HL
        LD A, 1
        LD (activePlayer), A
        LD A, 0
        LD (detectedWord), A
        LD HL, 0x21C3
        LD (tempAdressWord), HL
        LD HL, 0xE001
        LD (adressLetterChoice), HL
        JP main                         ; Goto main to start a new game
exitOK:
    CALL CLS                ; Clear screen
    LD C, 3
    CALL CHRCOL             ; Text color = 3 (green)
    LD BC, end02            ; "Merci d'avoir jouer à ce jeu"
    LD DE, 0A17h            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    DELAYMACRO 3
    LD BC, end03            ; "Jeu pour GamJAm"
    LD DE, 0A21h            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    LD C, 2
    CALL CHRCOL             ; Text color = 3 (green)
    LD BC, end04            ; "Retro Programmers United For Obscurs Systemes"
    LD DE, 0A2Bh            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    DELAYMACRO 3
    LD BC, end05            ; "Graphimes : Henri BLUM"
    LD DE, 0A49h            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    LD BC, end06            ; "Code assembleur : DarkSteph"
    LD DE, 0A53h            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    DELAYMACRO 5
    LD C, 3
    CALL CHRCOL             ; Text color = 3 (green)
    LD BC, end07            ; "A bientot"
    LD DE, 0A85h            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    exitEndLoop:
        JR exitEndLoop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  Game Routines                          ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PutstrDelay:
    CALL PUTSTR         ; Displays text on screen
    DELAYMACRO 6        ; Call Delay
    RET
DrawLineWithPixel:
    LD A, 0                             ; Counter
    boucleDrawLineWithPixel:            ; Loop
        CP 7                            ; Compare with 7
        RET Z                           ; If yes, RET
        LDI                             ; If no, draw image
        LDI
        CALL DrawLineWithPixelMacro
        INC A                           ; Increase compteur
        JR boucleDrawLineWithPixel      ; Go to start loop
DrawLineWithPixelMacro:
    DEC DE, DE
    PUSH HL
    LD HL, 0x40
    ADD HL, DE
    LD DE, HL
    POP HL
    RET
ShowScreen:
    boucleAffEndScreen:             ; Displaying the image on the screen loop
        PUSH BC                     ; Save BC on Stack
        ;DELAYMACRO 1
        LD BC, 60                   ; Len of line     
        LDIR                        ; Copy to screen
        INC DE, DE, DE, DE          ; Go to next screen line
        POP BC                      ; Load BC from Stack
        DJNZ boucleAffEndScreen     ; Loop to voucleAffEndScreen
        RET
Random:
    PUSH HL
    PUSH DE
    LD HL,(RandData)
    LD A,R
    LD D,A
    LD E,(HL)
    ADD HL,DE
    ADD A,L
    XOR H
    LD (RandData),HL
    POP DE
    POP HL
    LD (myRandomNumber), A
    RET
CrossedPlayer:
    LD BC, crossedPlayer2   ; Adress for rec01 table
    CALL 0D5Dh              ; Draw rect
    RET
RopePlayer2:
    LD BC, rope02           ; Adress for rec01 table
    CALL 0D5Dh              ; Draw rect
    RET
DetectLetterWord:
    ; For letters in word, detect if letter player is the same
    ; if so : Show letter in the word space and don't draw "pendu"
    ; if no : Draw "pendu"
    ; change token to another player
    LD IX, (tempAdressWord)
    detectLoop:
        LD C, A
        LD A, (tempAdressWord)
        CP 0
        RET Z
        CP C
    RET
PrintLetter:            ; Letter is in A
    LD C, 2             ; Load pen color
    CALL CHRCOL         ; Text color = 2
    LD C,A                              ; Put A (CHR value) to C (param)
    LD DE, (tempPrintLetter)            ; Destination Adress
    CALL PUTCHR                         ; Display CHR in screen (1 or 2) 
    LD A, E
    ADD A, 0xA
    LD E, A
    LD (tempPrintLetter), DE
    RET

ShowLettersPlayerChoice:            ; Draw the letter instead of the dash of the word 
    LD IX, (tempAdressWord)         ; Load IX adress of the word
    LD DE, INITADDRESSWORD          ; Load DE destination adress on screen
    PUSH AF
    LD A, 0                         ; Init detectedWord
    LD (detectedWord), A            ; Init detectedWord
    POP AF
    beguinShowLettersPlayerChoice:
        PUSH AF                     ; Save A (Key pressed) on Stack
        ; Detect end of word (0)
        LD A, (IX+0)
        CP 0
        JP Z, endShowLettersPlayerChoice
        ; End detect end of word
        POP AF                  
        CP (ix+0)
        PUSH AF
        PUSH DE
        JR NZ, increaseLetter
    showLetter:
        LD C, 3
        CALL CHRCOL             ; Text color = 3 (green)
        LD C,   (ix+0)          ; Put C (CHR value) to C (param)
        CALL PUTCHR             ; Display CHR in screen (Letter Word) 
        ; Update lenWord, each letter found = lenWord -1
        LD A, (lenWord)
        SUB 1
        LD (lenWord), A
        ; End update
        ; Change DetectedWord
        LD A, 1
        LD (detectedWord), A
    increaseLetter:
        POP DE
        POP AF
        INC IX
        INC D, D, D, D, D, D, D, D, D, D, D, D
        JP beguinShowLettersPlayerChoice:
    endShowLettersPlayerChoice:
        POP AF
        RET
ShowLettersPlayer:
    ; Show any letters on screen choosen by players
    ; in GREEN if letter is in word
    ; in BLUE if letter is not in word
    PUSH AF, BC, DE         ; Save registres to Stack
    LD A, (detectedWord)    ; Load detectedWord 0=not find, 1=find
    CP 0                    ; Compare with 0
    JR Z, showletternotfind ; If 0, go to showletternotfind
    LD C, 3                 ; If not set color chr to GREEN
    CALL CHRCOL                 
    JR showLettersPlayerNext           
    showletternotfind:      
        LD C, 2                         ; Set color chr to BLUE
        CALL CHRCOL 
        showLettersPlayerNext:          ; Draw letter on screen
        LD A, (lastLetterChooseCHR)     ; Put C (CHR value) to C (param)
        LD C, A
        LD DE, (adressLetterChoice)     ; Destination Adress
        CALL PUTCHR                     ; Display CHR in screen (Letter Word) 
        INC DE, DE, DE, DE, DE, DE, DE, DE, DE
        LD (adressLetterChoice), DE
        POP DE, BC, AF
        RET       
ChangeActivePlayer:      
    ; Routine for change active player           
    LD A, (activePlayer)    ; Load active player
    CP 1                    ; Compare with 1
    JR NZ, player2to1       ; If no, active player is player 2, go to player2to1
    ; Active player is player 1
    INC A                   ; Increase A (A=1 to 2)
    LD (activePlayer), A    ; Store A in activePlayer variable
    RET                     ; End routine
    player2to1:                 
        DEC A                   ; Decrease A (A=2 to 1)
        LD (activePlayer), A    ; Store A in activePlayer variable       
        RET                 ; End routine                 
ChangeTokenPlayer:
    ; Change sprite token to another player
    ; Player 1 to Player 2 or Player 2 to Player 1
    LD A, (activePlayer)        ; Load active player value
    CP 1                        ; Compare with 1
    JR Z, toPlayer2             ; If not, goto player 2
    toPlayer1:                  ; If yes, player active is Player 1
        LD IX, tokenMaskPlayer  
        LD (IX+4), 159
        LD BC, tokenMaskPlayer
        CALL 0D5Dh ; Draw rect
        LD HL, tokenSprite
        LD DE, ADDVIDTOKENP1
        CALL drawLineWithPixel
        ;JR endChangeToken
        RET
    toPlayer2:
        LD IX, tokenMaskPlayer
        LD (IX+4), 47
        LD BC, tokenMaskPlayer
        CALL 0D5Dh ; Draw rect
        LD HL, tokenSprite
        LD DE, ADDVIDTOKENP2
        CALL drawLineWithPixel
    ;endChangeToken:
        RET
LetterWasInWord:
    LD A, (detectedWord)
    CP 0
    JR Z, noLetterInWord
    LD A, 0
    LD (detectedWord), A    ; Reinit detectedWord 0
    RET NZ
    noletterInWord:
        LD A, (activePlayer)
        CALL DecreaseScorePlayer
        CALL PrintPendu
    RET
DecreaseScorePlayer:        ; Reg A = Active Player  
    CP 1                    ; Detect player active
    JR Z, nextDecreaseScorePlayer
    LD A, (player2Score)
    DEC A
    LD (player2Score), A
    RET
    nextDecreaseScorePlayer:
        LD A, (player1Score)
        DEC A
        LD (player1Score), A
    RET
PrintPendu:
    LD A, (activePlayer)            ; Load in A the active player (1 or 2)
    CP 1                            ; Compare with 1
    JR NZ, printPenduPlayer2        ; If no, goto to printPenduPlayer2
    ; test leg start
    LD BC,(player1OffsetPendu)
    LD A,(BC)
    CP 1
    CALL Z, DrawLeg
    ; Test callback Drawleg function. If 1 ret, however continu
    CP 1
    RET Z
    ; Test leg end
    ; Start Maj address player1OffsetPendu
    LD BC, (player1OffsetPendu)     ; Load adress of offsetPendu
    INC BC                          ; INC address for escape octet 1 (leg or not leg)
    LD (player1OffsetPendu), BC     ; Save address of offsetPendui
    ; End Maj address player1OffsetPendu
    LD BC, (player1OffsetPendu)     ; If yes, Load BC adress first things of pendu 
    CALL 0D5Dh ; Draw rect          ; Draw on screen
    LD HL, (player1OffsetPendu)     ; Add for arrive on next thing of pendu
    INC HL, HL, HL, HL, HL
    LD (player1OffsetPendu), HL
    RET
    printPenduPlayer2:
        ; test leg start
        LD BC,(player2OffsetPendu)
        LD A,(BC)
        CP 1
        CALL Z, DrawLeg
        ; Test callback Drawleg function. If 1 ret, however continu
        CP 1
        RET Z
        LD IX, (player2OffsetPendu)
        LD A, (IX+5)
        ADD A, 100
        LD (IX+5), A
        LD BC, (player2OffsetPendu)     ; Load BC adress first things of pendu 
        INC BC
        CALL 0D5Dh ; Draw rect          ; Draw on screen
        LD A, (IX+5)
        SUB A, 100
        LD (IX+5), A
        ; Start Maj address player1OffsetPendu
        LD BC, (player2OffsetPendu)     ; Load adress of offsetPendu player 2
        INC BC                          ; INC address to escape octet 1 (leg or not leg)
        LD (player2OffsetPendu), BC     ; Save address of offsetPendui
        LD HL, (player2OffsetPendu)     ; Add for arrive on next thing of pendu
        INC HL, HL, HL, HL, HL
        LD (player2OffsetPendu), HL
    RET
DrawLeg:
; Determine if left leg or right leg
    LD A, (activePlayer)            ; Load activePlayer (1 or 2)
    CP 1                            ; Compare with 1
    JR Z, determinePlayer1Leg       ; If so, jump to detereminePlayer1Leg
    ; If not, determinePlayer2leg
    LD A, (player2Leg)              ; Load player2Leg (0 = left leg, 1 = right leg)
    CP 0                            ; Compare with 0
    CALL Z, DrawLeftLeg             ; If yes call DrawLefLeg
    CP 2                            ; Test the calback of DrawLefLeg function
    JR NZ, endLeg                    ; If yes, jump to endLeg
    CALL DrawRightLeg               ; If no, call DrawrightLeg
    JR Z, endLeg                    ; jump to endLeg
    determinePlayer1Leg:
        LD A, (player1Leg)          ; Load player1Leg (0 = left leg, 1 = right leg)
        CP 0                        ; Compare with 0
        CALL Z, DrawLeftLeg         ; If yes call DrawLefLeg
        CP 2                        ; Test the calback of DrawLefLeg function
        JR NZ, endLeg                ; If yes, jump to endLeg
        CALL DrawRightLeg            ; If no, call DrawrightLeg
    endLeg:
    RET
DrawLeftLeg:
; Draw the leg from one square that shifts 7 times
    LD B, 0x6       ; Set counter value
    LD A, (activePlayer)
    CP 1
    JR Z, drawLeftLegLoop
    LD IX, penduPlayerLeftLeg
    LD A, (IX+5)
    ADD 100
    LD (IX+5), A
    drawLeftLegLoop:
        PUSH BC                 ; Save compteur on the stack
        LD BC, penduPlayerLeftleg   ; Load adrees of penduPlayerLeg
        INC BC                  ; INC address to escape octet 1 (leg or not leg)
        PUSH BC                 ; Save BC on stack befor CALL 0D5D
        CALL 0D5Dh              ; Draw on screen
        debug001:
        POP IX                  ; Load IX (adress of penduPlayerLeg) with stack
        LD A, (IX+3)            ; Load in A the value of Y coordinate of penduPlayerLeg
        ADD 4                   ; Add 4 
        LD (IX+3), A            ; Save new value of Y coordinate
        LD A, (IX+4)            ; Load in A the value of X coordinate of penduPlayerLeg
        SUB 2                   ; Sub 2 
        LD (IX+4), A            ; Save new value of X coordinate
        POP BC                  ; Load in BC the value of counter form stack
        DJNZ drawLeftLegLoop        ; Loop
        ; At the end of loop
        LD IX, penduPlayerLeftLeg   ; Load in IX the adress of penduPlayerLeg
        LD (IX+4), 0x73         ; Set the Y value to initial
        LD (IX+5), 0x4C         ; Set the X value to initial
        LD A, 1                 ; Set A to 1 -> return of function
        POP BC                  ; POP BC for clean stack
        setLeg:
            ; Set leftleg to 1 (next will be rightLeg)
            LD A,(activePlayer)
            CP 1
            JR Z, setLegPlayer1
            LD A, 2
            LD (player2Leg), A
            RET
            setLegPlayer1:
                LD A, 2
                LD (player1Leg), A
                RET
DrawRightLeg:
; Draw the leg from one square that shifts 7 times
    LD B, 0x6       ; Set counter value
    LD A, (activePlayer)
    CP 1
    JR Z, drawRightLegLoop
    LD IX, penduPlayerRightLeg
    LD A, (IX+5)
    ADD 100
    LD (IX+5), A
    drawRightLegLoop:
        PUSH BC                     ; Save compteur on the stack
        LD BC, penduPlayerRightleg  ; Load adrees of penduPlayerLeg
        INC BC                      ; INC address to escape octet 1 (leg or not leg)
        PUSH BC                     ; Save BC on stack befor CALL 0D5D
        CALL 0D5Dh                  ; Draw on screen
        debug002:
        POP IX                  ; Load IX (adress of penduPlayerLeg) with stack
        LD A, (IX+3)            ; Load in A the value of Y coordinate of penduPlayerLeg
        ADD 4                   ; Add 4 
        LD (IX+3), A            ; Save new value of Y coordinate
        LD A, (IX+4)            ; Load in A the value of X coordinate of penduPlayerLeg
        ADD 2                   ; Sub 2 
        LD (IX+4), A            ; Save new value of X coordinate
        POP BC                  ; Load in BC the value of counter form stack
        DJNZ drawRightLegLoop        ; Loop
        ; At the end of loop
        LD IX, penduPlayerRightLeg   ; Load in IX the adress of penduPlayerLeg
        LD (IX+4), 0x73         ; Set the Y value to initial
        LD (IX+5), 0x50         ; Set the X value to initial
        LD A, 1                 ; Set A to 1 -> return of function
        POP BC                  ; POP BC for clean stack
        RET
PlayerWin:
    LD A, (lenWord)
    CP 0
    RET NZ
    DELAYMACRO 2
    CALL CLS
    LD BC, colors_title     ; Load colors table to BC
    CALL SETCOL             ; Set palet colors (4 colors)        
    DELAYMACRO 1
    LD A, (activePlayer)
    CP 1
    JR Z, playerWinEndPlayer1
    CALL EndPlayer1
    RET
    playerWinEndPlayer1:
        CALL EndPlayer2
    ;endPlayerWinEnd:
    RET
PlayerLost:
    LD HL, player1Score     ; Adress player 1 score
    LD A, (activePlayer)    ; Detect active player
    CP 1                    ; if player 1
    JR Z, nextPlayerLost    ; next
    INC HL                  ; if player 2, increase adresse score (player 2)
    nextPlayerLost:
        LD A,(HL)
        CP 0x30
        JR Z,endPlayerLost
        LD A, 1                 ; Player not lost
        RET
        endPlayerLost:
            CALL ShowWordifLostOrWin
            DELAYMACRO 2
            CALL CLS
            DELAYMACRO 1
            LD BC, colors_title     ; Load colors table to BC
            CALL SETCOL             ; Set palet colors (4 colors)
            ; test if one player, if so go to enPlayer2Lost
            ;debugperdu:
            LD A, (playersNumber)
            CP 0x31
            LD A, 0
            CALL Z, OnePlayerLost
            CP 1
            JR Z, finEndPlayer
            LD A, (activePlayer)
            CP 1
            JR NZ, endPlayer2Lost   ; If player 1 loose, player 2 win
            CALL EndPlayer1
            JR finEndPlayer
            endPlayer2Lost:         ; If player 2 loose, player 1 win
            CALL EndPlayer2
    finEndPlayer:
    LD A,0
    RET
OnePlayerLost:
    LD BC, player1          ; "Player 1"
    LD DE, 0A03h            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    LD BC, player1Lost01    ; "Tu as perdu..."
    LD DE, 0A0Dh            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    LD BC, player2Win03     ; "Bourreau, exécutez"
    LD DE, 0A17h            ; X, Y positions
    CALL PUTSTR             ; Displays text on screen
    LD BC, player1          ; "Name of Player 1"
    LD DE, 7A17h            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    ; Show end screen
    LD HL, ecranFin01     ; Load splashScreen adress in HL
    LD DE, 0xD700           ; Load Adress Screen begin 
    LD BC, 0x7AF4           ; Load image length in byte
    CALL ShowScreen    
    LD A, 1
    RET
EndPlayer1:
    LD C, 1                 ; PEN couleur rouge
    CALL CHRCOL
    LD BC, player1          ; "Player 1"
    LD DE, 0A03h            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    LD BC, player1Lost01    ; "Tu as perdu..."
    LD DE, 0A0Dh            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    LD C, 2                 ; PEN couleur verte
    CALL CHRCOL
    LD BC, player2          ; "Player 2"
    LD DE, 0A17h            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    LD BC, player2Win01     ; "Tu as gagné, je te libère..."
    LD DE, 0A21h            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    LD BC, player2Win02     ; "Ne t'avise plus à me voler"
    LD DE, 0A2Bh            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    LD C, 1                 ; PEN couleur rouge
    CALL CHRCOL
    LD BC, player2Win03     ; "Bourreau, exécutez"
    LD DE, 0A35h            ; X, Y positions
    CALL PUTSTR             ; Displays text on screen
    LD BC, player1          ; "Name of Player 1"
    LD DE, 7A35h            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screenCALL PutstrDelay        ; Displays text on screen
    LD BC, player1Win04     ; "MAINTENANT!!!!!"
    LD DE, 0A3Fh            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    CALL DELAY 
    ; Show end screen
    LD HL, ecranFin01     ; Load splashScreen adress in HL
    LD DE, 0xD700           ; Load Adress Screen begin 
    LD BC, 0x7AF4           ; Load image length in byte
    CALL ShowScreen             
    LD A, 0                 ; Player 1 lost
    RET
EndPlayer2:
    LD C, 1                 ; PEN couleur rouge
    CALL CHRCOL
    LD BC, player2          ; "Player 2"
    LD DE, 0A03h            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    LD BC, player1Lost01    ; "Tu as perdu..."
    LD DE, 0A0Dh            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    LD C, 2                 ; PEN couleur verte
    CALL CHRCOL
    LD BC, player1          ; "Player 1"
    LD DE, 0A17h            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    LD BC, player1Win01     ; "Tu as gagné, je te libère..."
    LD DE, 0A21h            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    LD BC, player1Win02     ; "Mais ne t'approche plus de ma femme"
    LD DE, 0A2Bh            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    LD A, (playersNumber)
    CP 0x31
    RET Z
    LD C, 1                 ; PEN couleur rouge
    CALL CHRCOL
    LD BC, player1Win03     ; "Bourreau, exécutez"
    LD DE, 0A35h            ; X, Y positions
    CALL PUTSTR             ; Displays text on screen
    LD BC, player2          ; "Name of Player 2"
    LD DE, 7A35h            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    LD BC, player1Win04     ; "MAINTENANT!!!!!"
    LD DE, 0A3Fh            ; X, Y positions
    CALL PutstrDelay        ; Displays text on screen
    CALL DELAY
    ; Show end screen
    LD HL, ecranFin01       ; Load splashScreen adress in HL
    LD DE, 0xD700           ; Load Adress Screen begin 
    LD BC, 0x7AF4           ; Load image length in byte
    CALL ShowScreen         ; Display image
    LD A,0                  ; Player 2 lost
    RET
ChangeNamePlayer2:  ; Change name player 2 yyyyyyyyyyyy to Player 2, 0
    LD IX, player2          ; LD adress of name Player 2
    LD (IX+0), 0x50         ; Put Ox50(P) in first octet
    LD (IX+1), 0x6C         ; Put 0x6C(l) in next octet
    LD (IX+2), 0x61         ; Put 0x61(a) in next octet         
    LD (IX+3), 0x79         ; Put 0x79(y) in next octet
    LD (IX+4), 0x65         ; Put 0x65(e) in next octet
    LD (IX+5), 0x72         ; Put 0x72(r) in next octet
    LD (IX+6), 0x20         ; Put 0x20( ) in next octet
    LD (IX+7), 0x32         ; Put 0x32(2) in next octet
    LD (IX+8), 0            ; Put 0x0(0) in last octet
    RET
ShowWordifLostOrWin:
    LD IX, (tempAdressWord)         ; Load IX adress of the word
    LD DE, INITADDRESSWORD          ; Load DE destination adress on screen
    loopShowWordifLostOrWin:
        LD A, (IX+0)
        CP 0
        JR Z, endloopShowWordifLostOrWin
        LD C, (IX+0)
        CALL PUTCHR             ; Display CHR in screen (Letter Word) 
        INC IX
        INC D, D, D, D, D, D, D, D, D, D, D, D
        JP loopShowWordifLostOrWin
    endloopShowWordifLostOrWin:
        DELAYMACRO 10
        ; Show rect text background
        LD BC, backgroundText02
        CALL 0D5Dh
        ; End show rect text background
        LD C, 2             ; Load Color pen 2=Cyan
        CALL CHRCOL         ; Apply text color=2 (Cyan)
        LD BC, pressKeyStr  ; Show str "Appuyez sur une touche"
        LD DE, 3295h        ; X, Y positions
        CALL PutstrDelay    ; Displays text on screen
        CALL KEY                        ; Test if a key is pressed
        JR C,  endloopShowWordifLostOrWin                   ; Loop if key not pressed
        RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  DATA                                   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ORG 6000h
xWord:
            db 0x0
colors_title:       ; 0=black(0)(00), 1=yellow(3)(01), 2=blue(4)(10), 3=white(7)(11), 4=half light = false
    db 0x0, 0x03, 0x04, 0x07, 0x0
colors_pre_game:    ; 0=black(0)(00), 7=white(7)(01), 6=cyan(6)(10), 2=green(2)(11), 4=half light = false
    db 0x0, 0x07, 0x06, 0x02, 0x0
colors_games:
    db 0x0, 0x04, 0x07, 0x02, 0x0
colors_end:
    db 0x0, 0x01, 0x02, 0x04, 0x0

histoire:
    h01:    db "Annee 1453, les temps sont durs.",0
    h05:    db "Le maire de la ville d'Hectorland",0
    h10:    db "vous a trouv", E_AIGU, " chez lui, dans son lit.",0
    h15:    db "Et pas tout seul, avec sa femme.",0
    h20:    db "Ni une, ni deux, ni trois d'ailleurs,", 0
    h22:    db "Vous voil",A_ACCENT, " arret", E_AIGU, " pour etre pendu.", 0
    h25:    db "H",E_AIGU," oui,",0
    h27:    db "pas touche ", A_ACCENT, " la femme du Maire!", 0 
    h30:    db "Vous voici au bout d'une corde,",0
    h32:    db "avec un compagnon d'infortune.",0
    h35:    db "Le premier qui trouvera",0
    h40:    db "la bonne r", E_AIGU, "ponse aura la vie sauve.",0
    h45:    db "Bonne chance,",0
    h50:    db "telle est la vie en 1453.",0
myRandomNumber:
            db 0x0
playersNumber:
            db 0x0
player1Score:
            db 0x36
player2Score:
            db 0x36
player1OffsetPendu:
            dw 0x0
player2OffsetPendu:     dw 0x0
player1Leg:              db 0x0  ; 0 = left leg, 1 = right
player2Leg:              db 0x0  ; 0 = left leg, 1 = right
activePlayer:           db 0x01
detectedWord:           db 0x0
tempAdressWord:         dw 0x21C3
tempPrintLetter:        dw 0x0
adressLetterChoice:     dw 0xE001
lastLetterChooseCHR:    db 0x0
firstWord:
    INCLUDE "../Data/words.asm"
lenWord:        db  0x0
pressKeyStr:    db "Appuyez sur une touche",0
exitMessage:    db "Espace:QUITTER", 0
player1:        db "xxxxxxxxxxxxxxx", 0
player2:        db "yyyyyyyyyyyyyyy", 0
player1Temp:    db "Player 1", 0
player2Temp:    db "Player 2", 0
player1Lost01:  db "Tu as perdu...", 0
player1Win01:   db "Tu as gagn", E_AIGU, ", je te lib",E_GRAVE,"re...", 0
player1Win02:   db "Mais ne t'approche plus de ma femme", 0
Player1Win03:   db "Bourreau, ex",E_AIGU,"cutez",0
Player1Win04:   db "MAINTENANT!!!!!",0
player2Win01:   db "Tu as gagn",E_AIGU,", je te lib",E_GRAVE,"re...", 0
player2Win02:   db "Ne t'avise plus a me voler", 0
Player2Win03:   db "Bourreau, ex",E_AIGU,"cutez",0
end01:          db "Voulez-vous rejouer une partie (O/N) ?",0
end02:          db "Merci d'avoir jou", E_AIGU, ".", 0
end03           db "Jeu pour GamJAm 09/2024:", 0
end04           db "Retro Programmers United For Obscurs Systemes", 0
end05           db "Graph (accueil+fin) : Henri BLUM", 0
end06           db "Code assembleur : DarkSteph", 0
end07           db "A bientot", 0
namePlayer      db "Entrez votre pseudo, fin avec 0",0
deuxpoints      db  ":",0

crossedPlayer2: ;H, W, Color, Y, X
            db 1, 60, 3, 171, 138
nbrPlayerStr:   db "Nombre de joueur(s) (1 ou 2):", 0
Background01:     ;H, W, Color, Y, X
            db 250, 10, 3, 1, 1
Background02:     ;H, W, Color, Y, X
            db 5, 80, 3, 20, 1
Background03:     ;H, W, Color, Y, X
            db 5, 200, 3, 40, 1
rope01:   ;H, W, Color, Y, X
            db 10, 3, 1, 45, 80
rope02:   ;H, W, Color, Y, X
            db 10, 3, 1, 45, 180
penduPlayer1Tete:  
            db 0, 15, 15, 2, 55, 75
penduPlayer1Tronc
            db 0, 50, 9, 2, 65, 78 
penduPlayer1BrasGauche:
            db 0, 5, 20, 2, 80, 85 
penduPlayer1BrasDroite:
            db 0, 5, 20, 2, 80, 60 
;penduPlayer1LeftLeg:
;            db  0, 30, 5, 2, 110, 74
;penduPlayer1RightLeg:
;            db  0, 30, 5, 2, 110, 87
penduPlayerLeftLeg:
            db  1, 5, 5, 2, 115, 76
penduPlayerRightLeg:
            db  1, 5, 5, 2, 115, 84
tokenMaskPlayer:
            db 10, 10, 0, 155, 47
backgroundText01: db 20, 150, 2, 194, 38
backgroundText02: db 20, 150, 1, 143, 40
WordTiret:
            db 0xFF, 0xFF
timedelay dw FFFFh
tokenSprite:
            db 0x50, 0x5, 0xf4, 0x1f, 0x7d, 0x7d, 0x5d, 0x75, 0x5d, 0x75, 0x7d, 0x7d, 0xf4, 0x1f, 0x50, 0x5
debugchr1:
            db 8, 8, 3, 1, 1 
debugchr2:
            db 8, 8, 3, 8, 8
randData db 100

splashScreen:
    INCLUDE "../Data/splashscreen.asm"
ecranFin01:
    INCLUDE "../Data/endscreen.asm"
fin: