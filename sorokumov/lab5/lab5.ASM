Stk    SEGMENT  STACK
          DB 256 DUP(?)
Stk    ENDS 
DATA      SEGMENT
		KEEP_CS DW 0 ; ��� �࠭���� ᥣ����
		KEEP_IP DW 0 ; � ᬥ饭�� ���뢠���
		Message2 db 'prerivanie',10,13,'$' ;��ப� ��� ᮮ�饭��
DATA      ENDS
CODE      SEGMENT
          ASSUME CS:CODE, DS:DATA, SS:Stk
subr_int proc far ;��砫� ��楤���
	push ax ;��࠭塞 �� �����塞� ॣ�����
	push dx ;��࠭塞 �� �����塞� ॣ�����

	mov ah,9h ;�㭪�� ��⠭���� �����
	mov dx,offset message2 ;� dx ����㦠�� ���� ᮮ�饭�� Message2
	int 21h ;�뢮� ��ப� �� ��࠭

	pop dx ;����⠭�������� ॣ�����
	pop ax ;����⠭�������� ॣ�����
	mov al,20h
	out 20h,al

	iret ;����� ���뢠���
subr_int endp ;����� ��楤���

main proc far
	push ds
	sub ax,ax
	push ax
	mov ax,data
	mov ds,ax

	MOV  AH, 35H   ; �㭪�� ����祭�� �����
	MOV  AL, 60H   ; ����� �����
	INT  21H
	MOV  KEEP_IP, BX  ; ����������� ᬥ饭��
	MOV  KEEP_CS, ES  ; � ᥣ����

	push ds
	mov dx,offset subr_int

	mov ax,seg subr_int ;ᥣ���� ��楤���
	mov ds,ax ;����頥� � ds
	mov ah,25h ;�㭪�� ��⠭���� �����
	mov al,60h ;����� �����
	int 21h ;���塞 ���뢠���

	pop ds ;����⠭�������� ds 

	int 60h ;��� ���뢠���

	CLI
	PUSH DS
	MOV  DX, KEEP_IP
	MOV  AX, KEEP_CS
	MOV  DS, AX
	MOV  AH, 25H
	MOV  AL, 60H
	INT  21H          ; ����⠭�������� �����
	POP  DS
	STI
	ret
Main endp
code ends
	end Main
