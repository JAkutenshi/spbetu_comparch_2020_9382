STACKSG SEGMENT  PARA STACK 'Stack'
        DW       1024 DUP(?)
STACKSG	ENDS

DATA      SEGMENT			                        ;SEG DATA
	KEEP_CS DW 0 ; для хранения сегмента
	KEEP_IP DW 0 ; и смещения вектора прерывания
	message DB 'Jerusalimov Nikita 9382  $';,10,13,'$' ;строка для сообщения

DATA	ENDS						        ;ENDS DATA

CODE      SEGMENT   						;SEG CODE
ASSUME CS:CODE, DS:DATA, SS:STACKSG

WRITE_MSG  PROC FAR

	PUSH AX ; сейвим регистры, которые будем менять
	PUSH DX ; и этот тоже
	
	MOV AH, 9H ; прерывание для печати
	MOV DX, OFFSET message ; поместим в DX смещение до сообщения
	INT 21H ; вызываем прерывание в AH

	POP DX ; восстановим регистры, которые засейвили
	POP AX ; 
	MOV AL, 20H
	OUT 20H, AL

	IRET ; конец прерывания
WRITE_MSG ENDP ; конец процедуры

Main    PROC  FAR
   	PUSH DS
	SUB AX, AX
	PUSH AX
	MOV AX, DATA
	MOV DS, AX 

	MOV  AH, 35H   ; функция получения текущего значения вектора прерывания
	MOV  AL, 60H   ; номер вектора
	INT  21H
	MOV  KEEP_IP, BX  ; запоминание смещения
	MOV  KEEP_CS, ES  ; и сегмента вектора прерывания

	;CLI
	PUSH DS
	MOV  DX, OFFSET WRITE_MSG ; смещение до процедуры
	MOV  AX, SEG WRITE_MSG    ; сегмент процедуры
	MOV  DS, AX               ; помещаем в DS
	MOV  AH, 25H              ; функция установки вектора
	MOV  AL, 60H              ; номер вектора
	INT  21H                  ; меняем прерывание
	POP  DS
	;STI		          ; установили флаг прерывания
	
	int 60h;
	
	mov ah, 4Ch
	int 21h
	
 	RET
Main      ENDP
CODE      ENDS
END Main	