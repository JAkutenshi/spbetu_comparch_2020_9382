STACKSG SEGMENT  PARA STACK 'Stack'
        DW       512 DUP(?)
STACKSG	ENDS

DATASG  SEGMENT  PARA 'Data'; SEG DATA
	KEEP_CS DW 0 ;
		MESSAGE0 DB 'Enter data $'
        MESSAGE1 DB 'What action do you like to use (1/2)$'
		MESSAGE2 DB 'Transformation to string: $'
        MESSAGE3 DB 'Transformation from string to digit and back: $'
	STRING DB 35 DUP('0')
	buffer DB 20 DUP('0')
DATASG	ENDS; ENDS DATA


CODE SEGMENT; SEG CODE
ASSUME  DS:DataSG, CS:Code, SS:STACKSG
;–32 768…+32 767

DEC_TO_HEX PROC NEAR
	jmp start_1
	delete_nul DW 0
start_1:
	mov DI, 0h; DI - индекс текущего символа строки
    cmp AX, 0
	jge positive
			
negative:
	mov STRING[DI], '-'
	add DI, 1 ;инвертируем число и прибавляем единицу
	not AX
	add AX,1
	jmp scan_ax

check_nul:
	cmp delete_nul, 0
	je skip_char
	jne no_skip_char

positive:
	mov STRING[DI], '+'
	add DI, 1
	cmp AX, 0
	je case_nul

scan_ax:
	mov SI,AX ; записываем в si, ax
	mov	cx, 4		; в слове 4 ниббла (полубайта)

next_char:
	rol	ax, 1		; выдвигаем младшие 4 бита
	rol	ax, 1
	rol	ax, 1
	rol	ax, 1
	push	ax		; сохраним AX
	and	al, 0Fh		; оставляем 4 младших бита AL
	cmp	al, 0Ah		; сравниваем AL со значением 10
	sbb	al, 69h		; целочисленное вычитание с заёмом
	das			; BCD-коррекция после вычитания
	cmp al, '0'
	je check_nul
	mov delete_nul, 1

no_skip_char:
	mov STRING[DI], al
	add DI, 1

skip_char:
	pop	ax		; восстановим AX
	loop next_char
	jmp end_1

case_nul:
	mov STRING[DI], '0'
	add DI, 1

end_1: ; когда прошли все регистры
	mov STRING[DI],'$' ; добавляем в конец строки символ конца строки
	mov DX,offset STRING ; записываем в dx сдвиг строки
	ret
DEC_TO_HEX ENDP	

HEX_TO_DEC PROC FAR
	jmp start_2
	IS_NEG DB 0; отвечает за знак числа

start_2:
	mov AX,0; обнуляем ax
	mov CX, 0
	mov SI,0; за индекс строки будет отвечать si
	cmp STRING[SI],'-' ; сравниваем первый элемент строки с минусом
	jne positive_parse; если не равен минусу, то число положительное
	;если равен то отрицательное
	mov IS_NEG,1; в is_neg записываем 1

positive_parse: ; если число положительно
	mov SI,0 ; кладем в SI 0

len_loop: ; считаем длину строки
	add SI,1
	cmp STRING[SI],'$' ; сравниваем элемент строки с $
	jne len_loop ; если не равен $ то возвращаемся в цикл

	mov DI, SI
	lea SI, STRING
	inc SI
	xor cx, cx
	cld

number_construct:
	xor AX, AX
	dec DI ; декреминтим DI
	cmp DI,0 ; сравниваем DI с 0
	jle done ; DI <= 0
	lodsb
	cmp al, 'A'
	jge bukva

continue:
	sub al, '0'
	xchg ax, cx
	mov dx, 10h
    mul dx
	add cx, ax
	jmp number_construct
done:
	mov ax, cx
	cmp IS_NEG, 1
	je check_negative
	jmp end_2

bukva:
	sub al, 7
	jmp continue

check_negative:
	not ax
	add ax, 1

end_2:
	ret
HEX_TO_DEC ENDP


Main PROC FAR
   	mov  ax, DATASG                     
   	mov  ds, ax  
	
	mov DX, offset MESSAGE0
    mov ah,09h;
	int 21h;

	xor di, di
vvod:
	mov ah, 01h
	int 21h
	cmp al, 13
	je stop
	mov STRING[di], al
	inc di
	loop vvod
	stop:
	mov STRING[di], '$'
	mov dl, 10
	mov ah, 02h
	int 21h

    mov DX, offset MESSAGE1
    mov ah,09h;
	int 21h;

	mov ah, 01h
	int 21h
	cmp al, '1'
	jne case_snd

case_fst:
	mov dl, 10
	mov ah, 02h
	int 21h
	mov dl, 13
	mov ah, 02h
	int 21h
	mov DX, offset MESSAGE2
    mov ah,09h;
	int 21h;
	mov AX, 0
	call HEX_TO_DEC
	call DEC_TO_HEX
	mov ah,09h;
	int 21h;
	jmp my_end

case_snd:
	mov dl, 10
	mov ah, 02h
	int 21h
	mov dl, 13
	mov ah, 02h
	int 21h

    mov DX, offset MESSAGE3
    mov ah,09h;
	int 21h;
	mov ax, 0
	call HEX_TO_DEC
	call DEC_TO_HEX
	mov ah,09h
	int 21h

my_end:
	mov ah,4Ch;
	int 21h;
	
Main      ENDP
CODE      ENDS
END Main 