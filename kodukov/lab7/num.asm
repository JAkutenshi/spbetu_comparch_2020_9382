STACKSG SEGMENT  PARA STACK 'Stack'
        DW       512 DUP(?)
STACKSG	ENDS

DATASG  SEGMENT  PARA 'Data'; SEG DATA
	KEEP_CS DW 0 ;
        MESSAGE1 DB 'Transformation from registers: $'
        MESSAGE2 DB 'Transformation from string to registers and back: $'
	STRING DB 35 DUP('0')
DATASG	ENDS; ENDS DATA


CODE SEGMENT; SEG CODE
ASSUME  DS:DataSG, CS:Code, SS:STACKSG


DEC_TO_BIN PROC NEAR; DX - ���� � ������ ����� �����, AX - ������ ����� �����
	jmp start
	CUR_REGISTER DW 1; ������� �������
start:	
	mov CUR_REGISTER, 1; DX - ������� �������
	mov DI, 0h; DI - ������ �������� ������� ������
	mov BX, 8000h; ���������� ���-����� 8000h(������ ��� 1, ��������� 0) � bx
        cmp DX, 0
	jge positive; ���� dx >=0 �� ����� �������������
	;���� dx < 0 
	mov STRING[DI], '-'
	add DI, 1
	;����������� ����� � ���������� �������
	not DX
	not AX
	add AX,1
	jnc no_carry; �������� ���� ��������
	add DX,1
no_carry:	
	jmp scan_dx
reg_skip:; ������ �������
	cmp CUR_REGISTER, 1; �������� ���������� ���������
	jne zero_or_overflow; ���� CUR_REGISTER �� ����� 1, �.�. �� �������� �� ���� ��������� 
	;� � ����� ������� �������� ��������� ���� - ����� ���� ����� 0, ���� ��������� 
	;����� ������� ������� � ��������� ������������
	mov SI, AX ; ���������� � si, ax
	sub CUR_REGISTER, 1 ; �������� �� REGISTER_COUNTER 1
	mov BX, 8000h ; ���������� � bx �������� 8000h
	jmp find_leftmost;

positive:
	mov STRING[DI], '+'
	add DI, 1
scan_dx:
	mov SI,DX ; ���������� � si, dx
shift_mask: ;����� ����� ������
	shr BX,1 ; ��������� ����� ������
find_leftmost: ;����
	cmp BX,0 ; ���������� �������� � 0
	je reg_skip ; ���� �������� ����� 0, �� ��� ������, ��� �� �������� �� ������ �������� ���������
	mov CX,BX; ���������� ���-����� � cx
	and CX,SI; ��������� �������� ����
	cmp CX,0 ; ���������� cx � �����
	je shift_mask; ���� cx == 0
	;���� cx!=0 �� � cx ����� ����� �������� ���

digit_loop:
	mov CX,BX; � cx ���������� ���-�����
	and CX,SI; � ������������ ���� cx ������ ��� �� SI
	cmp CX,0; ���������� cx � 0
	je zero_digit ; ���� cx == 0
	;��������� �����
	mov STRING[DI], '1' ; ���������� � ������ �������
	inc DI; �������������� ������
	jmp next_digit 
zero_digit: ; ���� ��������������� ��� ����� ����
	mov STRING[DI],'0' ; ���������� � ������ ����
	inc DI; �������������� ������
 
next_digit: ;endif
	shr BX,1 ; ������ ��������� ����� �������� ������
	cmp BX,0 ; ���������� �������� � �����
	jne digit_loop ; ���� �������� �� ����� ���� ���������� �����������
	;�����, ���� �������� ����� ����, �� �� �������� �� ������ �� ���������
	cmp CUR_REGISTER,1 ;���������� CUR_REGISTER � ��������
	jne loop_end; ���� CUR_REGISTER �� ����� �������, �� ��� ������, ��� �� �������� �� ax, � ax - ������ �������
	;���� CUR_REGISTER ����� �������, �� �� �������� �� ������� �������� dx, � ���� ��� ������ �� ax
	mov SI,AX; ���������� � si, ax
	sub CUR_REGISTER,1; �������������� CUR_REGISTER
	mov bx,8000h; ���������� � bx ��������
	jmp digit_loop ; �������� ������
loop_end: ; ����� ������ ��� ��������
	mov STRING[DI],'$' ; ��������� � ����� ������ ������ ����� ������
	jmp in_end
zero_or_overflow: ;���� ��������� ����� ���� �����, ���� ������� �������
	mov SI,0 ; ���������� � si, 0
	cmp STRING[SI],'-' ;���������� ������ ������� ������ � -
	jne in_zero ; ���� �� -
        ; ���� ��� �� -, ��� ������ ��� ����� ������ 80000000h
	inc SI ; �������������� ������
	mov STRING[SI],'1' ; ���������� ������� � ������ � ������ si
	mov CX,31 ; ���������� � cx, 31
overflow_loop: ; ������ 31 ����
	mov SI,CX;
	add SI,1;
	mov STRING[SI],'0'
	loop overflow_loop
	mov SI,32

in_zero:
	mov STRING[SI],'0' ; ���������� � ������ SI 0
	inc SI ; �������������� ������
	mov STRING[SI],'$' ; ���������� �� ������ ������ ������ ����� ������
	
in_end:
	mov DX,offset STRING ; ���������� � dx ����� ������
	
	ret
DEC_TO_BIN ENDP	

BIN_TO_DEC PROC FAR; STRING - ������, ������� ����� ������; DX:AX - ����� ����� �����
	jmp start_bin_to_dec
	IS_NEG DB 0; �������� �� ���� �����
	REG_NUM DB 1; �������� �� ����� ��������
	
start_bin_to_dec:
	mov AX,0; �������� ax
	mov DX,0; �������� dx
	mov SI,0; �� ������ ������ ����� �������� si
	cmp STRING[SI],'-' ; ���������� ������ ������� ������ � �������
	jne positive_parse; ���� �� ����� ������, �� ����� �������������
	;���� ����� �� �������������
	mov IS_NEG,1; � NEG_NUMB ���������� 1

positive_parse: ; ���� ����� ������������
	sub ax,ax; �������� ax
	mov SI,0 ; ������ � SI 0
	sub SI,1 ; �������� �� si, 1

len_loop: ; ������� ����� ������
	add SI,1
	cmp STRING[SI],'$' ; ���������� ������� ������ � $
	jne len_loop ; ���� �� ����� $ �� ������������ � ����

	mov REG_NUM, 1
	cmp SI, 21h; ���������� ����� �� ������ ��������� ������� 33(����+32+$-1) 
	je max_neg_numb; ���� �����

	cmp SI, 1; ���������� �������� ������ � 1
	je zero_numb; ���� �����

	mov DI, AX; �������� ������������� ������� ax, 
	mov BX, 1; bx - ��������
	
traverse_loop:
	dec SI ; ����������� SI
	cmp SI,0 ; ���������� SI � 0
	jle post_parse ; SI <= 0
	
	cmp STRING[SI],'1' ; ���������� ������� � ������ � ������� SI � ��������
	jne parse_zero ; ���� �� ����� �������

	or DI,BX; � di �� ����� � ���, ������� ����� ������� � ����� BX, �������� 1
	jmp post_parse

parse_zero: ; ���� ������� �� ����� �������
	not BX; � bx ������� ����� �� ������� ��������
	;���������� ������ 0 �� ���� ��������, � �� ���� ��������� �� �������
	and DI,BX; ��� ���������� �, � DI �������� �� ��������������� �������� 0
	not BX; ���������� ����� � �������� ���������

post_parse:
	shl BX,1 ; �������� �������� �����
	cmp BX,0 ; ���������� bx � �����
	je parse_overflow ; ���� bx == 0
	cmp BX,8000h 
	jb traverse_loop ; ���� bx < ����� ��� ���������� ��������

;���� ����� >=8000h
parse_overflow:
	cmp REG_NUM,0;
	je end_of_second_reg; ���� REG_NUMB == 0
;���� REG_NUMB == 1
	cmp BX,8000h
	je traverse_loop

	mov AX,DI; ��������� ��������� � ������ �������
	mov DI,0; ������� ������� DI
	mov REG_NUM,0; ������ �������� ��������� ��� �������� DX
	mov BX,1; ��������� �����
	jmp traverse_loop

end_of_second_reg:
	mov DX,DI;���������� ��������� �� ������ �������
	jmp check_neg
	
max_neg_numb: ;����������� ������������� �����
	mov AX,0
	mov DX,8000h;
	jmp binary_end

zero_numb: ;������ ��� ���� 
	mov AX,0;
	mov DX,0;
	jmp binary_end
	
check_neg:
	cmp IS_NEG,0 
	je binary_end; ���� IS_NEG == 0, �.�. ����� �������������
;���� ����� �������������
;����������� � ��������� �������
	not DX;
	not AX;
	add AX,1;
	jnc binary_end; ���� ��� ��������
	add DX,1;	

binary_end:

	ret
BIN_TO_DEC ENDP

	
Main PROC FAR
   	mov  ax, DATASG                     
   	mov  ds, ax   
	
        mov DX, offset MESSAGE1
        mov ah,09h;
	int 21h;

	mov DX,0FFFFh
	mov AX,0FFFFh
	call DEC_TO_BIN
	mov ah,09h;
	int 21h;
	
	mov dl, 10
	mov ah, 02h
	int 21h
	mov dl, 13
	mov ah, 02h
	int 21h

        mov DX, offset MESSAGE2
        mov ah,09h;
	int 21h;

        mov ax,0
	mov dx,0
	call BIN_TO_DEC;
	call DEC_TO_BIN

	mov ah,09h
	int 21h

	mov ah,4Ch;
	int 21h;
	
Main      ENDP
CODE      ENDS
END Main