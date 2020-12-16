AStack    SEGMENT  STACK
          DW 1024 DUP(?)
AStack    ENDS
DATA SEGMENT
SYSTEM_CS DW 0
SYSTEM_IP DW 0
message db 'Press esc to exit!',10,13,'$'

DATA ENDS
CODE      SEGMENT
          ASSUME CS:CODE, DS:DATA, SS:AStack

          MY_INT PROC FAR jmp ss ax ss<-code offset
          jmp start

ST_SS DW 0000
ST_AX DW 0000
ST_SP DW 0000
IStack DW 30 DUP(?)

   start:

   mov ST_SP, SP
   mov ST_AX, AX
   mov AX, SS
   mov ST_SS, AX
   mov AX, IStack
   mov SS, AX
   mov AX, ST_AX

   push ax
    push dx
    mov  ah, 09h
    mov dx, offset message
    int  21h
    pop dx
    pop ax

    mov ST_AX,AX
	mov AX,ST_SS
	mov SS,AX
	mov SP,ST_SP
	mov AX,ST_AX

    mov al,20h
    out 20h,al
     iret
MY_INT ENDP

Main PROC FAR
push ds
sub ax,ax
push ax
mov ax,data
mov ds, ax

mov ax,3523h
 INT 21H
 MOV SYSTEM_IP, BX 
 MOV SYSTEM_CS, ES 

 PUSH DS
 MOV DX, OFFSET MY_INT
 MOV AX, SEG MY_INT 
 MOV DS, AX
 mov ax,2508h  
 INT 21H 
 POP DS

 STOPPER:
 mov   ah,1h
       int   21h 
       cmp   al,27 
       jne nextstep

       	CLI
 PUSH DS
 MOV DX, SYSTEM_IP
 MOV AX, SYSTEM_CS
 MOV DS, AX
 mov AX,2508h 
 INT 21H
 POP DS
 STI
 ret

       nextstep:
       jmp STOPPER

 

Main ENDP
CODE ENDS
 END Main 