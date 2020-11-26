STACKSG SEGMENT  PARA STACK 'Stack'
        DW       1024 DUP(?)
STACKSG	ENDS

DATA      SEGMENT			    ;SEG DATA
	KEEP_CS DW 0 ; для хранения сегмента
	KEEP_IP DW 0 ; и смещения вектора прерывания
    KEEP_CX DW 0 ; для хранения сегмента
	KEEP_DX DW 0
    KEEP_AX DW 0

DATA	ENDS					;ENDS DATA

CODE      SEGMENT   			;SEG CODE
ASSUME CS:CODE, DS:DATA, SS:STACKSG

MAKE_DELAY  PROC FAR

    MOV  KEEP_CX, CX
    MOV  KEEP_DX, DX
    MOV  KEEP_AX, AX

    MOV     CX, 0FH            ; время ожидания в секундах старш
    MOV     DX, 5240H          ; время ожидания в секундах младш
    MOV     AH, 86H
    INT     15H

	MOV AL, 20H                ; для обработки прерыв с более низкими уровнями
	OUT 20H, AL

    mov CX, KEEP_CX
    MOV DX, KEEP_DX
    MOV AX, KEEP_AX


	IRET                        ;конец прерывания

MAKE_DELAY ENDP                 ;конец процедуры

Main  PROC  FAR

	MOV  AH, 35H               ; функция получения текущего значения вектора прерывания
	MOV  AL, 60H               ; номер вектора
	INT  21H
	MOV  KEEP_IP, BX           ; запоминание смещения
	MOV  KEEP_CS, ES           ; и сегмента вектора прерывания


	PUSH DS
	MOV DX, OFFSET MAKE_DELAY  ;
	MOV  AX, SEG MAKE_DELAY    ; сегмент процедуры
	MOV  DS, AX                ; помещаем в DS
	MOV  AH, 25H               ; функция установки вектора
	MOV  AL, 60H               ; номер вектора
	INT  21H                   ; меняем прерывание
	POP  DS


	int 60h;

	CLI			               ;сбросили флаг прерывания
	PUSH DS
	MOV  DX, KEEP_IP
	MOV  AX, KEEP_CS
	MOV  DS, AX
	MOV  AH, 25H		       ;установки адреса нового обработчика прерывания в поле векторов прерываний
	MOV  AL, 60H
	INT  21H                   ; восстанавливаем старый вектор прерывания
	POP  DS
	STI

    mov ah, 4Ch;
	int 21h;

 	RET
Main      ENDP
CODE      ENDS
END Main
