AStack SEGMENT STACK
DW 512 DUP(?)
AStack ENDS


DATA SEGMENT 

KEEP_CS DW 0 ; для хранения сегмента
KEEP_IP DW 0 ; и смещения вектора прерывания
msg DB 'hello$'
timer DW 0

DATA ENDS

CODE SEGMENT

ASSUME SS:AStack, DS:DATA, CS:Code

;обработчик 08h
new_08h  PROC FAR
	
	keep_sp dw 0
	keep_ss dw 0
	keep_ax dw 0
	new_st dw 10 dup (?)
	mov keep_sp, sp
	mov keep_ss, ss
	mov keep_ax, ax
	mov ax, new_st
	mov ss, ax

	delay:
	nop
	loop delay 
	
    mov al,20h
    out 20h,al
	
	mov ss, keep_ss
	mov sp, keep_sp
	mov ax, keep_ax
    iret
	
new_08h  ENDP


MAIN PROC FAR
 
 push ds
 sub ax,ax
 push ax
 mov ax,DATA
 mov ds,ax
 
 mov ah, 35h ; функция получения вектора
 mov al, 08h ; номер вектора
 int 21H
 mov KEEP_IP, bx ; запоминание смещения
 mov KEEP_CS, es ; и сегмента вектора прерывания
 push ds
 mov dx, offset new_08h ; смещение для процедуры в DX
 mov ax, seg new_08h ; сегмент процедуры
 mov ds, ax ; помещаем в DS
 mov ah, 25h ; функция установки вектора
 mov al, 08h ; номер вектора
 int 21h
 pop ds
 
 ;вывод сообщения с задержкой
 mov cx, 10
 mov dx, offset msg
 mov ah, 9
 int 21h
 
 ;восстанавление старого вектора прерывания
 cli
 push DS
 mov dx, KEEP_IP
 mov ax, KEEP_CS
 mov ds, ax
 mov ah, 25h
 mov al, 08h
 int 21h
 pop ds
 sti
 ret
	
MAIN ENDP 

CODE ENDS 

END MAIN