AStack    SEGMENT  STACK
          DW 1500 DUP(?)
AStack    ENDS

DATA      SEGMENT
keepcs DW 0; для хранения сегмента
keepip DW 0; и смещения прерывания
firstString LABEL BYTE
DB 'Первая строка выводится без задержки',13,10,'$'
secondString LABEL BYTE
  DB 'А вторая через 2 секунды',13,10,'$'

DATA      ENDS


CODE      SEGMENT

        ASSUME CS:CODE, DS:DATA, SS:AStack

Main      PROC  FAR

	mov ah,35h;вектор
	mov al,60h;продолжение вектора
	int 21h; прерывание 
	mov keepip,bx
	mov keepcs,es

	push ds
	mov dx, OFFSET delayInt; смещение для процедуры в DX
	mov ax, SEG delayInt; в ах помещаем ссылку на начало delayInt 
	mov ds,ax
	mov ah,25h; функция установки вектора
	mov al,60h; номер вектора
	int 21h
	pop ds

	mov ax,data
	mov ds,ax
	mov dx,OFFSET firstString; вывод первой строки
	mov ah,09
	int 21h

	int 60h
	mov dx,OFFSET secondString; вывод второй строки
	mov ah,09
	int 21h
	cli; чистка флагов
	push ds
	mov dx,keepip; возвращение старых адресов IP 
	mov ax,keepcs
	mov ds,ax
	mov ah,25h; установка вектора прерываний
	mov al,60h
	int 21h
	pop ds
	sti
	mov ah,4ch
	int 21h
	ret

Main      ENDP

delayInt PROC FAR
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
	push ds
	mov di,32
	mov ah,0
	int 1Ah
	mov bx,dx; счетчик с момента сброса
Delay:
	mov ah,0
	int 1Ah
	sub dx,bx
	cmp di,dx
	ja Delay;переход,если больше
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
delayInt ENDP
CODE      ENDS
END Main

