ASTACK SEGMENT STACK
	DB 1024 DUP(0)
ASTACK ENDS

DATA SEGMENT
	SYSTEM_CS DW 0
	SYSTEM_IP DW 0
	MESSAGE DB 'Press Esc to exit', 10, 13,'$'
    COUNT DB 0	
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA, SS:ASTACK

MAIN PROC FAR
	; Инициализация
	PUSH DS
	SUB AX, AX
	PUSH AX 
	MOV AX, DATA
	MOV DS, AX
	; Сохранение системного обработчика прерывания
	MOV AX, 3508H ; Dos fn 35h get interrupt,  interrupt 08
	INT 21H ; ES:BX = system interrupt handler adress
	MOV SYSTEM_IP, BX
	MOV SYSTEM_CS, ES
	; Установка прерывания
	PUSH DS ; Сохранение DS
	MOV DX, OFFSET MY_INT ; Установка Оффсета прерывания
	MOV AX, SEG MY_INT
	MOV DS, AX ; Установка сегмента прерывания
	MOV AX, 2508H ; Dos fn 25h set interrupt, interrupt 08, DS:DX - my inturrept
	INT 21H
	POP DS ; Восстановление DS
	; Бесконечный цикл
STOPPER: ; Считывание символа с клавиатуры
	SUB AH, AH ; AH = 0
	INT 16H ; AX = полученный символ
	CMP AH, 01H
		JNE STOPPER ; Бесконечный цикл, пока не нажали ESC
	; Восстановление старого прерывания
	CLI ; Clear interrupt flag (disable interrupts)
	PUSH DS ; Сохранение DS
	MOV DX, SYSTEM_IP ; Установка Оффсета прерывания
	MOV AX, SYSTEM_CS
	MOV DS, AX ; Установка сегмента прерывания
	MOV AX, 2508H ; Dos fn 25h set interrupt, interrupt 08, DS:DX - my inturrept
	INT 21H
	POP DS ; Восстановление DS
	STI ; Set interrupt flag (enable interrupts)
 	RET
MAIN ENDP

MY_INT PROC FAR ; обработчик прерываний
	cmp COUNT,16 ;  каждую секунду выводить 4 сообщения
		jne sec
	PUSH DX ; сохранение регистров
	PUSH AX
	MOV DX, OFFSET MESSAGE ; вывод сообщения
	MOV AH, 9H ; Dos fn 09h print string, DS:DX - my string
	INT 21H
	mov COUNT, 0 ; COUNT = 1
	POP DX ; восстановление регистров
	POP AX

sec:
	inc COUNT ; COUNT += 1
	MOV AL, 20H ; Low-level interruptions
	OUT 20H, AL ; Low-level interruptions
	IRET
MY_INT ENDP

CODE ENDS

END MAIN