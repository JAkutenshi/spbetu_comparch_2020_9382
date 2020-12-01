ASTACK SEGMENT STACK
	DB 2000 DUP(?)
ASTACK ENDS

DATA SEGMENT
	KEEP_CS DW 0 ; для хранения сегмента
	KEEP_IP DW 0 ; и смещения вектора прерывания
	message DB 'hello', 10, 13,'$'
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA, SS:ASTACK

SUBR_INT PROC FAR
	PUSH AX
	PUSH DX
	MOV DX, OFFSET message
	MOV AH, 9h
	INT 21H
	POP DX
	POP AX
	MOV AL, 20H
	OUT 20H, AL
	IRET
SUBR_INT ENDP

MAIN PROC FAR
	PUSH DS
	SUB AX, AX
	PUSH AX 
	MOV AX, DATA
	MOV DS, AX
	MOV AH, 35H ; функция получения вектора
	MOV AL, 1Ch ; номер вектора
	INT 21H
	MOV KEEP_IP, BX ; запоминание смещения
	MOV KEEP_CS, ES ; и сегмента вектора прерывания
	
	PUSH DS
    MOV DX, OFFSET SUBR_INT ; смещение для процедуры в DX
    MOV AX, SEG SUBR_INT ; сегмент процедуры
    MOV DS, AX ; помещаем в DS
    MOV AH, 25H ; функция установки вектора
    MOV AL, 1Ch ; номер вектора
    INT 21H ; меняем прерывание
    POP DS
exit:
	SUB AH, AH
	INT 16H
	CMP AH, 01H
		JNE exit
	CLI
	PUSH DS
	MOV DX, KEEP_IP
	MOV AX, KEEP_CS
	MOV DS, AX
	MOV AH, 25H
	MOV AL, 1Ch
	INT 21H ; восстанавливаем старый вектор прерывания
	POP DS
	STI
 	RET
MAIN ENDP
CODE ENDS
END MAIN 