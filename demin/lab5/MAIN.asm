AStack SEGMENT STACK
 DB 2048 DUP(?)
AStack ENDS
; Данные программы
DATA SEGMENT
; Директивы описания данных
KEEP_CS DW 0 ; для хранения сегмента
KEEP_IP DW 0 ; и смещения вектора прерывания


DATA ENDS

CODE SEGMENT
 ASSUME CS:CODE, DS:DATA, SS:AStack
 
MY_INT PROC FAR
 PUSH AX ; сохранение изменяемых регистров
 
 out 42H,AL;включаем таймер, который будет выдавать импульсы на динамик с заданной частотой
 MOV AL,10110110b;режим таймер
 OUT 43H,AL;отправка инструкций управляющему регистру

 MOV  AL,AH
 OUT 42H,AL;посылаем старший байт
 
 IN AL,61H;получение состояния динамика 
 MOV AH,AL;сохранение состояния динамика
 or al,3;иницилизируем дианамик
 OUT 61H,AL; подаем ток в порт 61h
 SUB cx,cx
 
 KILL_TIME:
 loop KILL_TIME
 
 MOV AL,AH
 out 61H,AL;возвращаем состояние динамика

 done:
 
 
 POP AX ; восстановление регистров
 MOV AL, 20H
 OUT 20H,AL
 IRET
MY_INT ENDP

Main PROC FAR
 MOV AH, 35H ; функция получения вектора
 MOV AL, 60H ; номер вектора
 INT 21H
 MOV KEEP_IP, BX ; запоминание смещения
 MOV KEEP_CS, ES ; и сегмента вектора прерывания
  
 PUSH DS
 MOV DX, OFFSET MY_INT ; смещение для процедуры в DX
 MOV AX, SEG MY_INT ; сегмент процедуры
 MOV DS, AX ; помещаем в DS
 MOV AH, 25H ; функция установки вектора
 MOV AL, 60H ; номер вектора
 INT 21H ; меняем прерывание
 POP DS
 
 MOV AX,10000
 int 60h; 

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
 mov  ah, 4ch                        
 int  21h 
Main ENDP
CODE ENDS
 END Main