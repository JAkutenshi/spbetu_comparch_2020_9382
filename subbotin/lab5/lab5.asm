STACKSG SEGMENT  PARA STACK 'Stack'
        DW       1024 DUP(?)
STACKSG	ENDS

DATASG  SEGMENT  PARA 'Data'				;SEG DATA
	KEEP_CS DW 0 ; для хранения сегмента
	KEEP_IP DW 0 ; и смещения вектора прерывания
	GREETING  DB 'Subbotin Maksim 9382 $'
	HELLOWORLD DB 'Hello World!!! $'
DATASG	ENDS								;ENDS DATA

CODE      SEGMENT   						;SEG CODE
ASSUME  DS:DataSG, CS:Code, SS:STACKSG

WRITE_SOME  PROC FAR
	PUSH AX   ; сохранение изменяемых регистров
	;<действия по обработке прерывания>
	mov   AH,9 ;вызов того,
	int   21h  ;что хранится в dx
	
	POP  AX    ;восстановление регистров
	MOV  AL, 20H
	OUT  20H,AL
	IRET
WRITE_SOME  ENDP

	
	
Main      PROC  FAR
   	mov  ax, DATASG                        ;ds setup
   	mov  ds, ax   

	MOV  AH, 35H   ; функция получения вектора
	MOV  AL, 1CH   ; номер вектора
	INT  21H
	MOV  KEEP_IP, BX  ; запоминание смещения
	MOV  KEEP_CS, ES  ; и сегмента вектора прерывания

	PUSH DS
	MOV  DX, OFFSET WRITE_SOME ; смещение для процедуры в DX
	MOV  AX, SEG WRITE_SOME    ; сегмент процедуры
	MOV  DS, AX          ; помещаем в DS
	MOV  AH, 25H         ; функция установки вектора
	MOV  AL, 1CH         ; номер вектора
	INT  21H             ; меняем прерывание
	POP  DS
	
	
	mov   DX, OFFSET GREETING ;так как наше переопределенное прерывние выводит строку, запишем в dx то, что надо вывести
	int 1Ch ;вызываем наше переопределенное прерывание

	mov   DX, OFFSET HELLOWORLD
	int 1Ch


	
	CLI
	PUSH DS
	MOV  DX, KEEP_IP
	MOV  AX, KEEP_CS
	MOV  DS, AX
	MOV  AH, 25H
	MOV  AL, 1CH
	INT  21H          ; восстанавливаем старый вектор прерывания
	POP  DS
	STI
	
	mov ah,4Ch;
	int 21h;
	
	
 
Main      ENDP
CODE      ENDS
END Main									;ENDS CODE	
