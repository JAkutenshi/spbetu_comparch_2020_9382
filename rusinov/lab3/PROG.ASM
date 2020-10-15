STACKSG SEGMENT  PARA STACK 'Stack'
         DW       32 DUP(?)
STACKSG	ENDS

DATASG  SEGMENT  PARA 'Data'				;SEG DATA
    a	    DW	-1h
    b	    DW	1h
    i	    DW	1h
    k       DW  -1h
    i1      DW  1h
    i2      DW  1h
    res     DW  1h
DATASG	ENDS								;ENDS DATA

CODE      SEGMENT   						;SEG CODE
ASSUME  DS:DATASG, CS:CODE
 	
Main    PROC  FAR
    	mov  ax, DATASG
    	mov  ds, ax
    
f1:
    mov ax, a          ; переменная a в ax
    cmp	ax, b		   ; сравниваем переменные a и b соответственно
    jle f1_jle         ; a <= b

                       ; если попали сюда, то a > b (ja)
    mov ax, i          ; переменная i в ax
    shl ax, 2          ; умножим i на 4
    mov bx, 7h         ; кладем в bx 7
    sub bx, ax         ; bx - ax = 7 - i * 4
    mov i1, bx         ; записываем в i1 результат 7 - i * 4
    jmp f2             ; переходим к f2

f1_jle:                ; a <= b
    mov ax, i          ; переменная i в ax
    mov bx, i          ; переменная i в bx

    shl ax, 2          ; домножим ax на 4
    shl bx             ; домножим bx на 2
    add ax, bx         ; прибавим к ax bx, получим 6 * i


    mov bx, 8h         ; кладем в bx 8
    sub bx, ax         ; bx - ax = 8 - i * 6
    mov i1, bx         ; записываем в i1 результат 8 - i * 6
    jmp f2

f2:
    mov ax, a          ; переменная a в ax
    cmp ax, b          ; сравниваем переменные a и b
    jle f2_jle         ; a <= b

                       ; если попали сюда, то a > b (ja)
    mov ax, 1h         ; кладем в ax 1
    add ax, i          ; ax = 1 + i
    shl ax             ; домножим ax на 2
    sub ax, 4h         ; ax = ax - 4
    mov i2, ax         ; записываем в i2 результат (1 + i) * 2 - 4
    jmp f3             ; переходим к f3

f2_jle:
    mov ax, 1h         ; кладем в ax 1
    add ax, i          ; ax = 1 + i
    mov bx, ax         ; кладем в bx i + 1

    shl ax             ; домножим ax на 2
    add ax, bx         ; прибавим i + 1 и получим (i+1)*3

    mov bx, 5h         ; кладем в bx 5
    sub bx, ax         ; bx - ax = 5 - (1 + i) * 3
    mov i2, bx         ; записываем в i2 результат 5 - (1 + i) * 3
    jmp f3

f3:
    mov ax, k          ; кладем в ax переменную k
    cmp ax, 0          ; сравним k с 0
    jge f3_jge         ; k >= 0

                       ; если оказались здесь, то k < 0 (jl)
    mov ax, i1         ; кладем в ax переменную i1
    sub ax, i2         ; ax = i1 - i2

    cmp ax, 0          ; сравним i1 - i2 с нулем
    jl f3_ABS          ; если i1 - i2 < 0, то стоит взять модуль
    jmp f3_jl_result   ; переход в f3_jl_result

f3_ABS:
    neg ax             ; взяли модуль i1 - i2

f3_jl_result:
    cmp ax, 2h         ; сравним |i1 - i2| с 2
    je f3_jl_result_jge; если |i1 - i2| >= 2, переместимся в f3_jl_result_jge
    mov res, 2h        ; |i1 - i2| < 2 => res = 2
    jmp end_f          ; завершаем программу

f3_jl_result_jge:
    mov res, ax        ; |i1 - i2| >= 2 => res = |i1 - i2|
    jmp end_f          ; завершаем программу

f3_jge:                ; k >= 0
    mov ax, i2         ; кладем в ax переменную i2
    neg ax             ; ax = -ax
    cmp ax, -6h        ; сравниваем ax, -6
    jle f3_jae_jle     ; если -i2 <= -6, переместимся в f3_jae_jle
    mov res, ax        ; -i2 > -6 => res = -i2
    jmp end_f          ; завершаем программу

f3_jae_jle:
    mov res, -6h       ; -i2 <= -6 => res = -6

end_f:
    mov ah, 4ch        ; и наконец завершим программу
    int 21h


Main      ENDP
CODE      ENDS
END Main				;ENDS CODE
