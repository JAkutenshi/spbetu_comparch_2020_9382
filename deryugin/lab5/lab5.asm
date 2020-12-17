ASTACK SEGMENT STACK
	DB 2000 DUP(?)
ASTACK ENDS

DATA SEGMENT
	KEEP_CS DW 0 ; ��� �������� ��������
	KEEP_IP DW 0 ; � �������� ������� ����������
	message DB 'hello', 10, 13,'$'
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA, SS:ASTACK

SUBR_INT PROC FAR
	jmp CONTINUE
			SAVE_SS dw 1 (0)
		SAVE_SP dw 1 (0)
		SAVE_AX dw 1 (0)
		interruptStack dw 10 dup(0)
	CONTINUE:
	mov SAVE_SS, ss
	mov SAVE_SP, sp
	mov SAVE_AX, ax
	mov ax, interruptStack
	mov ss, ax
	mov ax, SAVE_AX
	PUSH AX
	PUSH DX
	MOV DX, OFFSET message
	MOV AH, 9h
	INT 21H
	POP DX
	POP AX
	
	mov SAVE_AX,AX
	mov AX,SAVE_SS
	mov SS,AX
	mov SP,SAVE_SP
	mov AX,SAVE_AX
	
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
	MOV AH, 35H ; ������� ��������� �������
	MOV AL, 1Ch ; ����� �������
	INT 21H
	MOV KEEP_IP, BX ; ����������� ��������
	MOV KEEP_CS, ES ; � �������� ������� ����������
	
	PUSH DS
    MOV DX, OFFSET SUBR_INT ; �������� ��� ��������� � DX
    MOV AX, SEG SUBR_INT ; ������� ���������
    MOV DS, AX ; �������� � DS
    MOV AH, 25H ; ������� ��������� �������
    MOV AL, 1Ch ; ����� �������
    INT 21H ; ������ ����������
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
	INT 21H ; ��������������� ������ ������ ����������
	POP DS
	STI
 	RET
MAIN ENDP
CODE ENDS
END MAIN 