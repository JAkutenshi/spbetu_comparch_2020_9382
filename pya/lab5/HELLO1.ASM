AStack    SEGMENT  STACK
          DW 1024 DUP(?)
AStack    ENDS
DATA SEGMENT
KEEP_CS DW 0
KEEP_IP DW 0
message db 'I love you!',10,13,'$' ;строка для сообщения

DATA ENDS
CODE      SEGMENT
          ASSUME CS:CODE, DS:DATA, SS:AStack

          Output PROC FAR jmp ss ax ss<-code offset
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
Output ENDP

Main PROC FAR
push ds
sub ax,ax
push ax
mov ax,data
mov ds, ax

mov ax,3523h
 INT 21H
 MOV KEEP_IP, BX ; запоминание смещения
 MOV KEEP_CS, ES ; и сегмента вектора прерывания

 PUSH DS
 MOV DX, OFFSET Output ; смещение для процедуры в DX
 MOV AX, SEG Output ; сегмент процедуры
 MOV DS, AX ; помещаем в DS
 mov ax,2508h  
 INT 21H ; меняем прерывание
 POP DS

 waiting:
 mov   ah,1h
       int   21h 
       cmp   al,27 
       jne nextstep

       	CLI
 PUSH DS
 MOV DX, KEEP_IP
 MOV AX, KEEP_CS
 MOV DS, AX
 mov AX,2508h 
 INT 21H ; восстанавливаем старый вектор прерывания
 POP DS
 STI
 ret

       nextstep:
       jmp waiting

 

Main ENDP
CODE ENDS
 END Main