AStack    SEGMENT  STACK
          DW 1024 DUP(?) ; 1Kb of memory
AStack    ENDS
DATA SEGMENT
KEEP_CS DW 0
KEEP_IP DW 0
STACK_SS DW 0000
STACK_AX DW 0000
STACK_SP DW 0000
IStack DW 30 DUP(?)
mes db 'Sample Text',10,13,'$' ;строка дл€ сообщени€

DATA ENDS
CODE      SEGMENT
          ASSUME CS:CODE, DS:DATA, SS:AStack

Print PROC FAR
jmp start

   start:

   mov STACK_SP, sp
   mov STACK_AX, ax
   mov ax, ss
   mov STACK_SS, ax
   mov ax, IStack
   mov ss, ax
   mov ax, STACK_AX

   push ax
   push dx
   mov  ah, 09h
   mov  dx, offset mes
   int  21h
   pop  dx
   pop  ax

   mov STACK_AX, ax
   mov ax, STACK_SS
   mov ss, ax
   mov sp, STACK_SP
   mov ax, STACK_AX

   mov al, 20h
   out 20h, al
   iret
Print ENDP

Main PROC FAR
 push ds
 sub  ax,ax
 push ax
 mov  ax, data
 mov  ds, ax

 mov ah, 35h
 mov al, 23h
 int 21h
 mov KEEP_IP, bx ; запоминание смещени€
 mov KEEP_CS, es ; и сегмента вектора прерывани€

 push ds
 mov dx, offset Print ; смещение дл€ процедуры в DX
 mov ax, seg Print    ; сегмент процедуры
 mov ds, ax           ; помещаем в DS
 mov ah, 25h
 mov al, 08h  
 int 21h ; мен€ем прерывание
 pop ds
 
@wait:
 mov ah, 1h
 int    21h   ; считывание символа с клавиатуры
 cmp  al,27 
 jne @wait

 cli
 push ds
 mov dx, KEEP_IP
 mov ax, KEEP_CS
 mov ds, ax
 mov ax, 2508h 
 int 21h ; восстанавливаем старый вектор прерывани€
 pop ds
 sti
 ret 

Main ENDP
CODE ENDS
 END Main 