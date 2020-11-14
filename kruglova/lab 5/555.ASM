STACKSG SEGMENT  PARA STACK 'Stack'
        DW       1024 DUP(?)
STACKSG	ENDS

DATASG  SEGMENT  PARA 'Data'					;SEG DATA
	KEEP_CS DW 0 ; для хранения сегмента
	KEEP_IP DW 0 ; и смещения вектора прерывания
	GREETING  DB 'Kruglova Viktoria 9382 $'
	crlf db 0ah, 0dh, '$'
DATASG	ENDS							;ENDS DATA

CODE      SEGMENT   						;SEG CODE
ASSUME  DS:DataSG, CS:Code, SS:STACKSG

WRITE_SOME  PROC FAR

	jmp s
	ST_SS DW 0000
	ST_SP DW 0000
	ST_AX DW 0000
	INT_STACK DW 20 DUP(0)

	s:
	mov ST_SP,SP ; cохраняю SP

	mov ST_AX,AX

	mov AX,SS
	mov ST_SS,AX ; сохраняю SS

	mov AX,INT_STACK
	mov SS,AX ;новый стек

	mov AX,ST_AX

	PUSH AX   ; сохранение изменяемых регистров
	PUSH DX

	;<действия по обработке прерывания>
	mov   AH,9 ;вызов того,
	int   21h  ;что хранится в dx 
	add dx,48

    mov dx, OFFSET crlf
    mov ah,9
    int 21h

	POP  DX    ;восстановление регистров
	POP AX

	mov ST_AX,AX

	mov AX,ST_SS ; восстанавливаю SS
	mov SS,AX

	mov SP,ST_SP ; восстанавливаю SP

	mov AX,ST_AX


	MOV  AL, 20H
	OUT  20H,AL

	IRET


WRITE_SOME  ENDP


	
	
Main      PROC  FAR
   	mov  ax, DATASG                        ;ds setup
   	mov  ds, ax   

	MOV  AH, 35H   ; функция получения вектора
	MOV  AL, 23h   ; номер вектора
	INT  21H
	MOV  KEEP_IP, BX  ; запоминание смещения
	MOV  KEEP_CS, ES  ; и сегмента вектора прерывания

	CLI
	PUSH DS
	MOV DX, OFFSET WRITE_SOME
	MOV  AX, SEG WRITE_SOME    ; сегмент процедуры
	MOV  DS, AX          ; помещаем в DS
	MOV  AH, 25H         ; функция установки вектора
	MOV  AL, 23h         ; номер вектора
	INT  21H             ; меняем прерывание
	POP  DS
	STI
	

	mov   DX, OFFSET GREETING ;так как наше переопределенное прерывние выводит строку, запишем в dx то, что надо вывести
	int 23h
	
	CLI
	PUSH DS
	MOV  DX, KEEP_IP
	MOV  AX, KEEP_CS
	MOV  DS, AX
	MOV  AH, 25H
	MOV  AL, 23H
	INT  21H          ; восстанавливаем старый вектор прерывания
	POP  DS
	STI
	
	mov ah,4Ch;
	int 21h;
	
	
 
Main      ENDP
CODE      ENDS
END Main									;ENDS CODE	
