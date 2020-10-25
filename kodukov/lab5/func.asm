STACKSG SEGMENT  PARA STACK 'Stack'
  DW 1024 DUP(?)
STACKSG	ENDS

DATASG  SEGMENT  PARA 'Data'; SEG DATA
  KEEP_CS DW 0; дл€ хранени€ сегмента
  KEEP_IP DW 0; и смещени€ вектора прерывани€
  GREETING  DB 'Kodukov Aleksandr 9382 $'
  crlf db 0ah, 0dh, '$'
DATASG	ENDS; ENDS DATA

CODE SEGMENT; SEG CODE
ASSUME DS:DataSG, CS:Code, SS:STACKSG

INTER_TIMER PROC FAR

  PUSH AX; сохранение измен€емых регистров
  PUSH DX

  ; действи€ по обработке прерывани€
  MOV AH, 9; вызов того,
  INT 21H; что хранитс€ в dx

  MOV DX, OFFSET crlf
  MOV AH, 9
  INT 21H

  POP DX; восстановление регистров
  POP AX

  MOV AL, 20H
  OUT 20H, AL

IRET

INTER_TIMER  ENDP
	
Main PROC FAR
  MOV AX, DATASG; ds setup
  MOV DS, AX   

  MOV AH, 35H; функци€ получени€ вектора
  MOV AL, 08H; номер вектора
  INT 21H
  MOV KEEP_IP, BX; запоминание смещени€
  MOV KEEP_CS, ES; и сегмента вектора прерывани€

  CLI
  PUSH DS
  MOV DX, OFFSET INTER_TIMER
  MOV AX, SEG INTER_TIMER; сегмент процедуры
  MOV DS, AX; помещаем в DS
  MOV AH, 25H; функци€ установки вектора
  MOV AL, 08H; номер вектора
  INT 21H; мен€ем прерывание
  POP DS
  STI	

  MOV DX, OFFSET GREETING; помещаем строку в DS
  INT 08h
	
  CLI
  PUSH DS
  MOV DX, KEEP_IP
  MOV AX, KEEP_CS
  MOV DS, AX
  MOV AH, 25H
  MOV AL, 08H
  INT 21H; восстанавливаем старый вектор прерывани€
  POP DS
  STI
	
  MOV AH, 4CH
  INT 21H
 
Main ENDP
CODE ENDS
END Main