DATA	SEGMENT
	KEEP_CS DW 0; для хранения сегмента
	KEEP_IP DW 0; и смещения вектора прерывания
DATA      ENDS
 
AStack	SEGMENT	STACK
	DB 256 DUP(?)
AStack  ENDS
 
CODE    SEGMENT
    ASSUME SS:AStack, DS:DATA, CS:CODE
 
SUBR_INT PROC FAR 
	PUSH AX ; сохранение изменяемых регистров
	PUSH DX
 
	MOV AL, 10110110b
	OUT 43H, AL
	MOV AX, 880 ; sound pitch
	OUT 42H, AL
	MOV AL, AH
	OUT 42H, AL
	IN AL, 61H
	MOV AH, AL
	OR AL, 3
	OUT 61H, AL
	SUB CX, CX
SOUND:
	LOOP SOUND
	MOV AL, AH
	OUT 61H, AL 
 
	POP AX ; восстановление регистров
	POP DX  
 
	MOV AL, 20H ; разрешают обработку прерываний с более низким уровнем
	OUT 20H,AL 
	IRET 
SUBR_INT ENDP 
 
MAIN PROC FAR
 
	PUSH DS
	SUB AX, AX
	PUSH AX
	MOV AX, DATA
	MOV DS, AX
 
	MOV AH, 35H ; функция получения вектора
	MOV AL, 60H ; номер вектора
	INT 21H 
	MOV KEEP_IP, BX ; запоминание смещения
	MOV KEEP_CS, ES ; и сегмента вектора прерывания
 
	PUSH DS 
	MOV DX, OFFSET SUBR_INT ; смещение для процедуры в DX
	MOV AX, SEG SUBR_INT ; сегмент процедуры
	MOV DS, AX ; помещаем в DS
	MOV AH, 25H ; функция установки вектора
	MOV AL, 60H ; номер вектора
	INT 21H ; меняем прерывание
	POP DS 
 
	int 60h
 
	CLI
	PUSH DS 
	MOV DX, KEEP_IP 
	MOV AX, KEEP_CS 
	MOV DS, AX 
	MOV AH, 25H 
	MOV AL, 60H 
	INT 21H ; восстанавливаем старый вектор прерывания
	POP DS 
	STI
 
	ret
 
MAIN ENDP
CODE ENDS
END MAIN