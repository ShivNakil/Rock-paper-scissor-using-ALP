.model SMALL
.stack 100h

.data
LINE        db '--------------------------------------------------------------------- $',0
MSG         db ' GAME Instruction : Rock = 1 , Paper = 2 , Scissors = 3 $', 0
PL1         db ' Choose Your Move = $', 0
PL2         db '       Computer Chooses = $', 0
PL1_Win     db '       You Won The Round! $', 0
PL2_Win     db '       You Lost The Round! $', 0
TIE_MSG     db '       Its a Tie! $', 0
PL_WIN      db ' Congratulations You Won $', 0
PL_LOOSE    db ' Better Luck Next Time $', 0
PLAY_AGAIN  db ' Want To Play Again ? (1.Continue , 0.Exit) = $',0
COUNT_P     db 0
COUNT_C     db 0
COUNT_G     db 0
AGAIN       db 0
COMPARE     db 0

.code
START:
    MOV AX, @data
    MOV DS, AX
    MOV ES, AX  
   
GAME_LOOP:
    CALL NEW_LINE           ; Calling function to print new line
   
    MOV DX, OFFSET LINE      ; Line
    MOV AH, 09h
    INT 21h
   
    CALL NEW_LINE
   
    MOV DX, OFFSET MSG      ; Game Instruction
    MOV AH, 09h
    INT 21h
    CALL NEW_LINE
   
ROUND_LOOP:
    CALL NEW_LINE           ; Calling function to print new line
    MOV DX, OFFSET PL1      ; Prompt of player1
    MOV AH, 09h
    INT 21h
   
    MOV AH,08               ; Function to read a char from keyboard (Input by Player1)
    INT 21h                 ; the char saved in AL
    MOV AH,02               ; Function to display a char  
    MOV BL,AL               ; Copy a saved char in AL to BL
    MOV DL,AL               ; Copy AL to DL to output it
    INT 21h
       
    ;CALL NEW_LINE
   
    MOV DX, OFFSET PL2      ; Prompt of player2
    MOV AH, 09h
    INT 21h
   
    ; code to generate a random number from 1 to 3 using the system time
    MOV  AH, 00h            ; interrupts to get system time        
    INT  1AH                ; CX:DX now hold number of clock ticks since midnight      
   
    MOV  AX, DX
    XOR  DX, DX
    MOV  CX, 3              ; change the range to 1, 2, 3    
    DIV  CX      
    ADD  DL, 1              ; add 1 to get a random number from 1 to 3
    ADD  DL, '0'            ; to ascii from '0' to '2'
    MOV  BH, DL
    MOV  AH, 2h             ; call interrupt to display a value in DLINT  21h
    INT  21h
   
    ;CALL NEW_LINE
    CMP BL, BH
    JE  ROUND_EQUAL    
       
    CMP BL, '1'
    JE  ROUND_P1_ROCK  
    CMP BL, '2'
    JE  ROUND_P1_PAPER
    CMP BL, '3'
    JE  ROUND_P1_SCISSORS
   
ROUND_P1_ROCK:
    CMP BH, '2'
    JE  ROUND_P2_WIN  
    CMP BH, '3'
    JE  ROUND_P1_WIN  
    JMP ROUND_FINAL

ROUND_P1_PAPER:  
    CMP BH, '1'
    JE  ROUND_P1_WIN  
    CMP BH, '3'
    JE  ROUND_P2_WIN
    JMP ROUND_FINAL

ROUND_P1_SCISSORS:
    CMP BH, '1'
    JE ROUND_P2_WIN
    CMP BH, '2'
    JE ROUND_P1_WIN
    JMP ROUND_FINAL

ROUND_EQUAL:
    MOV DX, OFFSET TIE_MSG
    MOV AH, 09h
    INT 21h
    JMP ROUND_FINAL

ROUND_P1_WIN:
    INC COUNT_P
    MOV DX, OFFSET PL1_WIN
    MOV AH, 09h
    INT 21h
    JMP ROUND_FINAL

ROUND_P2_WIN:
    INC COUNT_C
    MOV DX, OFFSET PL2_WIN
    MOV AH, 09h
    INT 21h

ROUND_FINAL:
    CALL NEW_LINE
    INC COUNT_G
    CMP COUNT_G,3
    JL LOOOP
    JMP FORWARD

LOOOP:
    JMP ROUND_LOOP

FORWARD:
    MOV AL, COUNT_P
    MOV BL, COUNT_C
    CMP AL,BL
    JL EXIT
    CMP AL,BL
    JE TIEE
    CMP AL,BL
    JG FINALL

FINALL:
    CALL NEW_LINE
    MOV DX, OFFSET PL_WIN
    MOV AH, 09h
    INT 21h
    CALL NEW_LINE
    JMP END_MSG

TIEE:
    CALL NEW_LINE
    MOV DX, OFFSET TIE_MSG
    MOV AH, 09h
    INT 21h
    CALL NEW_LINE
    JMP END_MSG

EXIT:
    CALL NEW_LINE
    MOV DX, OFFSET PL_LOOSE
    MOV AH, 09h
    INT 21h
    CALL NEW_LINE

END_MSG:
    MOV DX, OFFSET LINE      ; Line
    MOV AH, 09h
    INT 21h
   
    CALL NEW_LINE
    MOV DX,OFFSET PLAY_AGAIN
    MOV AH ,09h
    INT 21h

    MOV COUNT_G, 0
    MOV AGAIN, 0
    MOV COMPARE, 0
   
    MOV AH, 1               ;take input prom user
    INT 21H
    SUB AL, '0'
    MOV AGAIN,AL

    MOV AL,AGAIN
    MOV BL,COMPARE    
    CMP AL,BL
    JE SHEVAT
    CALL NEW_LINE
    JMP GAME_LOOP

NEW_LINE:
    MOV AH, 02h
    MOV DL, 13
    INT 21h
    MOV DL, 10
    INT 21h
    RET
   
SHEVAT:
    MOV AH, 4Ch             ; Function to exit the program
    INT 21h

END START
