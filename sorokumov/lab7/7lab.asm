STACKSG SEGMENT  PARA STACK 'Stack'
        DW       512 DUP(?)
STACKSG	ENDS

DATASG  SEGMENT  PARA 'Data'; SEG DATA
	KEEP_CS DW 0 ;
        MESSAGE1 DB 'Transformation to string: $'
        MESSAGE2 DB 'Transformation from string to digit and back: $'
	STRING DB 35 DUP('0')
DATASG	ENDS; ENDS DATA


CODE SEGMENT; SEG CODE
ASSUME  DS:DataSG, CS:Code, SS:STACKSG
;0…+65 535

DEC_TO_HEX PROC NEAR
	jmp start
	delete_nul DW 0; нужна для того, чтобы не писать впереди стоящие нули
start:
	mov delete_nul, 0
	mov DI, 0h; DI - индекс текущего символа строки
	cmp AX, 0; если число равно нулю, то сразу пишем нуль
	je case_nul
	jmp scan_ax;обрабатываем число

check_nul: ;служит для определения необходимости записи нуля
	cmp delete_nul, 0 ;если нуль значащий, то записиваем
	je skip_char
	jne no_skip_char	

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
	cmp al, '0' ;если нуль
	je check_nul
	mov delete_nul, 1; если попалась цифра, отличная от нуля, то остальные нули будут значащими

no_skip_char:
	mov STRING[DI], al ;записываем число в строку
	add DI, 1; инкрементируем счетчик

skip_char:
	pop	ax		; восстановим AX для следующих цифр
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

	mov AX,0; обнуляем ax и cx
	mov CX, 0
	mov SI,0; за индекс строки будет отвечать si

len_loop: ; считаем длину строки
	add SI, 1
	cmp STRING[SI],'$' ; сравниваем элемент строки с $
	jne len_loop ; если не равен $ то возвращаемся в цикл

	mov DI, SI; в di будет храниться количество цифр в числе
	lea SI, STRING; будем работать со строкой
	xor cx, cx
	add DI, 1
	cld

number_construct:
	xor AX, AX
	dec DI ; декреминтим DI
	cmp DI,0 ; сравниваем DI с 0
	jle done ; DI <= 0 заканчиваем обработку строки
	lodsb; в al кладется очередной символ
	cmp al, 'A'
	jge bukva ; если больше или ровно

continue:
	sub al, '0' ;работаем с цифрой вместо кода цифры
	xchg ax, cx; меняем значения, так как в cx лежит результат
	mov dx, 10h
    mul dx; ax * 10
	add cx, ax; прибавляем в прошлому результату следующую цифру
	jmp number_construct

done:
	mov ax, cx; в ax кладем результат
	jmp end_2

bukva:
	sub al, 7; убираем разрыв между цифрами и буквами
	jmp continue

end_2:
	ret
HEX_TO_DEC ENDP


Main PROC FAR
   	mov  ax, DATASG                     
   	mov  ds, ax   
	
        mov DX, offset MESSAGE1 ;вывод первого сообщения
        mov ah,09h;
	int 21h;
	mov AX, 9999h ;наше число
	call DEC_TO_HEX
	mov ah,09h ;вывод строки
	int 21h;
	
	mov dl, 10;возврат каретки 
	mov ah, 02h
	int 21h
	mov dl, 13; новая строка
	mov ah, 02h
	int 21h

        mov DX, offset MESSAGE2 ;вывод второго сообщения
        mov ah,09h;
	int 21h;
	mov ax, 0
	call HEX_TO_DEC
	call DEC_TO_HEX

	mov ah,09h ;вывод строки
	int 21h

	mov ah,4Ch;завершение
	int 21h;
	
Main      ENDP
CODE      ENDS
END Main
