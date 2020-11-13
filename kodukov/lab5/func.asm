STACKSG SEGMENT  PARA STACK 'Stack'
  DW 1024 DUP(?)
STACKSG	ENDS

DATASG  SEGMENT  PARA 'Data'; SEG DATA
  KEEP_CS DW 0; ��� �������� ��������
  KEEP_IP DW 0; � �������� ������� ����������
  GREETING  DB 'Kodukov Aleksandr 9382 $'
  crlf db 0ah, 0dh, '$'
DATASG	ENDS; ENDS DATA

CODE SEGMENT; SEG CODE
ASSUME DS:DataSG, CS:Code, SS:STACKSG

INTER_TIMER PROC FAR

  PUSH AX; ���������� ���������� ���������
  PUSH DX

  ; �������� �� ��������� ����������
  MOV AH, 9; ����� ����,
  INT 21H; ��� �������� � dx

  MOV DX, OFFSET crlf
  MOV AH, 9
  INT 21H

  POP DX; �������������� ���������
  POP AX

  MOV AL, 20H
  OUT 20H, AL

IRET

INTER_TIMER  ENDP
	
Main PROC FAR
  MOV AX, DATASG; ds setup
  MOV DS, AX   

  MOV AH, 35H; ������� ��������� �������
  MOV AL, 08H; ����� �������
  INT 21H
  MOV KEEP_IP, BX; ����������� ��������
  MOV KEEP_CS, ES; � �������� ������� ����������

  CLI
  PUSH DS
  MOV DX, OFFSET INTER_TIMER
  MOV AX, SEG INTER_TIMER; ������� ���������
  MOV DS, AX; �������� � DS
  MOV AH, 25H; ������� ��������� �������
  MOV AL, 08H; ����� �������
  INT 21H; ������ ����������
  POP DS
  STI	

  MOV DX, OFFSET GREETING; �������� ������ � DS
  INT 08h
	
  CLI
  PUSH DS
  MOV DX, KEEP_IP
  MOV AX, KEEP_CS
  MOV DS, AX
  MOV AH, 25H
  MOV AL, 08H
  INT 21H; ��������������� ������ ������ ����������
  POP DS
  STI
	
  MOV AH, 4CH
  INT 21H
 
Main ENDP
CODE ENDS
END Main