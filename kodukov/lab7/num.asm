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


DEC_TO_BIN PROC NEAR; DX - знак и первая часть числа, AX - вторая часть числа
	jmp start
	CUR_REGISTER DW 1; текущий регистр
start:	
	mov CUR_REGISTER, 1; DX - текущий регистр
	mov DI, 0h; DI - индекс текущего символа строки
	mov BX, 8000h; записываем бит-маску 8000h(первый бит 1, отсальные 0) в bx
        cmp DX, 0
	jge positive; если dx >=0 то число положительное
	;если dx < 0 
	mov STRING[DI], '-'
	add DI, 1
	;инвертируем число и прибавляем единицу
	not DX
	not AX
	add AX,1
	jnc no_carry; проверка бита переноса
	add DX,1
no_carry:	
	jmp scan_dx
reg_skip:; прошли регистр
	cmp CUR_REGISTER, 1; проверка пройденных регистров
	jne zero_or_overflow; если CUR_REGISTER не равен 1, т.е. мы прошлись по двум регистрам 
	;и в обоих случаях битмаска равняется нулю - тогда либо число 0, либо введенное 
	;число слишком большое и произошло переполнение
	mov SI, AX ; записываем в si, ax
	sub CUR_REGISTER, 1 ; вычитаем из REGISTER_COUNTER 1
	mov BX, 8000h ; записываем в bx битмаску 8000h
	jmp find_leftmost;

positive:
	mov STRING[DI], '+'
	add DI, 1
scan_dx:
	mov SI,DX ; записываем в si, dx
shift_mask: ;сдвиг маски вправо
	shr BX,1 ; побитовый сдвиг вправо
find_leftmost: ;ищем
	cmp BX,0 ; сравниваем битмаску с 0
	je reg_skip ; если битмаска равна 0, то это значит, что мы прошлись по одному регистру полностью
	mov CX,BX; записываем бит-маску в cx
	and CX,SI; получение текущего бита
	cmp CX,0 ; сравниваем cx с нулем
	je shift_mask; если cx == 0
	;если cx!=0 то в cx самый левый значащий бит

digit_loop:
	mov CX,BX; в cx записываем бит-маску
	and CX,SI; в единственном бите cx теперь бит из SI
	cmp CX,0; сравниваем cx и 0
	je zero_digit ; если cx == 0
	;ненулевое число
	mov STRING[DI], '1' ; записываем в строку единицу
	inc DI; инкрементируем индекс
	jmp next_digit 
zero_digit: ; если соответствующий бит равен нулю
	mov STRING[DI],'0' ; записываем в строку нуль
	inc DI; инкрементируем индекс
 
next_digit: ;endif
	shr BX,1 ; делаем побитовый сдвиг битмаски вправо
	cmp BX,0 ; сравниваем битмаску с нулем
	jne digit_loop ; если битмаска не равна нулю продолжаем проходиться
	;иначе, если битмаска равна нулю, то мы прошлись по одному из регистров
	cmp CUR_REGISTER,1 ;сравниваем CUR_REGISTER с единицей
	jne loop_end; если CUR_REGISTER не равна единице, то это значит, что мы прошлись по ax, а ax - второй регистр
	;если CUR_REGISTER равен единице, то мы прошлись по первому регистру dx, и надо еще пройти по ax
	mov SI,AX; записываем в si, ax
	sub CUR_REGISTER,1; декреминтируем CUR_REGISTER
	mov bx,8000h; записываем в bx битмаску
	jmp digit_loop ; начинаем проход
loop_end: ; когда прошли все регистры
	mov STRING[DI],'$' ; добавляем в конец строки символ конца строки
	jmp in_end
zero_or_overflow: ;если введенное число было нулем, либо слишком большим
	mov SI,0 ; записываем в si, 0
	cmp STRING[SI],'-' ;сравниваем первый элемент строки с -
	jne in_zero ; если не -
        ; если все же -, это значит что число задано 80000000h
	inc SI ; инкрементируем индекс
	mov STRING[SI],'1' ; записываем единицу в строку в индекс si
	mov CX,31 ; записываем в cx, 31
overflow_loop: ; ставим 31 нуль
	mov SI,CX;
	add SI,1;
	mov STRING[SI],'0'
	loop overflow_loop
	mov SI,32

in_zero:
	mov STRING[SI],'0' ; записываем в индекс SI 0
	inc SI ; инкрементируем индекс
	mov STRING[SI],'$' ; записываем во второй индекс символ конец строки
	
in_end:
	mov DX,offset STRING ; записываем в dx сдвиг строки
	
	ret
DEC_TO_BIN ENDP	

BIN_TO_DEC PROC FAR; STRING - строка, которую будем читать; DX:AX - здесь будет число
	jmp start_bin_to_dec
	IS_NEG DB 0; отвечает за знак числа
	REG_NUM DB 1; отвечает за номер регистра
	
start_bin_to_dec:
	mov AX,0; обнуляем ax
	mov DX,0; обнуляем dx
	mov SI,0; за индекс строки будет отвечать si
	cmp STRING[SI],'-' ; сравниваем первый элемент строки с минусом
	jne positive_parse; если не равен минусу, то число положительное
	;если равен то отрицательное
	mov IS_NEG,1; в NEG_NUMB записываем 1

positive_parse: ; если число положительно
	sub ax,ax; обнуляем ax
	mov SI,0 ; кладем в SI 0
	sub SI,1 ; вычитаем из si, 1

len_loop: ; считаем длину строки
	add SI,1
	cmp STRING[SI],'$' ; сравниваем элемент строки с $
	jne len_loop ; если не равен $ то возвращаемся в цикл

	mov REG_NUM, 1
	cmp SI, 21h; сравниваем равен ли индекс конечного символа 33(знак+32+$-1) 
	je max_neg_numb; если равна

	cmp SI, 1; сравниваем конечный индекс с 1
	je zero_numb; если равна

	mov DI, AX; начинаем рассматривать регистр ax, 
	mov BX, 1; bx - битмаска
	
traverse_loop:
	dec SI ; декреминтим SI
	cmp SI,0 ; сравниваем SI с 0
	jle post_parse ; SI <= 0
	
	cmp STRING[SI],'1' ; сравниваем элемент в строке в индексе SI с единицей
	jne parse_zero ; если не равно единице

	or DI,BX; в di на месте в том, котором стоит единица в маске BX, ставится 1
	jmp post_parse

parse_zero: ; если элемент не равен единице
	not BX; в bx единица стоит на текущем элементе
	;инвертация ставит 0 на этом элементе, а во всех остальных по единице
	and DI,BX; при логическом и, в DI получаем на рассматриваемом элементе 0
	not BX; возвращаем маску в исходное положение

post_parse:
	shl BX,1 ; сдвигаем битмаску влево
	cmp BX,0 ; сравниваем bx с нулем
	je parse_overflow ; если bx == 0
	cmp BX,8000h 
	jb traverse_loop ; если bx < маски для последнего элемента

;если маска >=8000h
parse_overflow:
	cmp REG_NUM,0;
	je end_of_second_reg; если REG_NUMB == 0
;если REG_NUMB == 1
	cmp BX,8000h
	je traverse_loop

	mov AX,DI; результат вставляем в первый регистр
	mov DI,0; очищаем регистр DI
	mov REG_NUM,0; теперь получаем результат для регистра DX
	mov BX,1; обновляем маску
	jmp traverse_loop

end_of_second_reg:
	mov DX,DI;записываем результат во второй регистр
	jmp check_neg
	
max_neg_numb: ;максимально отрицательное число
	mov AX,0
	mov DX,8000h;
	jmp binary_end

zero_numb: ;случай для нуля 
	mov AX,0;
	mov DX,0;
	jmp binary_end
	
check_neg:
	cmp IS_NEG,0 
	je binary_end; если IS_NEG == 0, т.е. число положительное
;если число отрицательное
;инвертируем и добавляем единицу
	not DX;
	not AX;
	add AX,1;
	jnc binary_end; если нет переноса
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