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
    cmp	ax, b	       ; сравниваем переменные a и b соответственно
    jle f1_jle         ; a <= b

                       ; если попали сюда, то a > b
    mov ax, i          ; переменная i в ax
    shl ax, 1          ; умножим i на 2
    mov bx, 15         ; кладем в bx 15
    sub bx, ax         ; bx - ax = 15 - i * 2
    mov i1, bx         ; записываем в i1 результат 15 - i * 2
    jmp f2             ; переходим к f2

f1_jle:                ; a <= b
    mov ax, i          ; переменная i в ax
    mov bx, i          ; переменная i в bx
    shl ax, 1          ; домножим ax на 2
    shl ax, 1          ; домножим ax на 2
    shl bx, 1          ; домножим bx на 2
    add ax, bx         ; прибавим к ax bx, получим 6 * i
    shr ax, 1          ; поделим ax на 2
    mov bx, 4h         ; кладем в bx 4
    add ax, bx         ; ax + bx = 3 * i + 4
    mov i1, ax         ; записываем в i1 результат 3 * i + 4
    jmp f2

f2:
    mov ax, a          ; переменная a в ax
    cmp ax, b          ; сравниваем переменные a и b
    jle f2_jle         ; a <= b

                       ; если попали сюда, то a > b (ja)
   
    mov ax, i          ; переменная i в ax
    mov bx, i          ; переменная i в bx
    shl ax, 1          ; домножим ax на 2
    shl ax, 1          ; домножим ax на 2
    mov bx, 3h         ; кладем в bx 3
    add ax, bx         ; ax = 4 * i + 3
    mov bx, 0h         ; кладем в bx 0
    sub bx, ax         ; bx = -(4 * i + 3)
    mov i2, bx         ; записываем в i2 результат (1 + i) * 2 - 4
    jmp f3             ; переходим к f3

f2_jle:
    mov ax, i          ; переменная i в ax
    mov bx, i          ; переменная i в bx
    shl ax, 1          ; домножим ax на 2
    shl ax, 1          ; домножим ax на 2
    shl bx, 1          ; домножим bx на 2
    add ax, bx         ; прибавим к ax bx, получим 6 * i
    mov bx, 10         ; кладем в bx 10
    sub ax, bx         ; ax - bx = 6 * i - 10
    mov i2, ax         ; записываем в i2 результат 6 * i - 10
    jmp f3

f3:
    mov ax, k          ; кладем в ax переменную k
    cmp ax, 0          ; сравним k с 0
    je f3_je          ; k = 0

                       ; если оказались здесь, то k < 0 
    mov ax, i1         ; кладем в ax переменную i1
    mov bx, i2         ; кладем в ax переменную i1

    cmp ax, bx         ; сравним i1 c i2 

    jle f3_jle         ; если i1 <= i2
    jmp f3_jl_result_jge


f3_jle:
    mov ax, i2         ; кладем в ax переменную i2
    jmp f3_jl_result_jge


f3_je:
    mov ax, i1         ; кладем в ax переменную i1
    mov bx, i2         ; кладем в ax переменную i1
    cmp ax, bx         ; сравним i1 c i2 
    jge f3_jge         ; если i1 >= i2 
    jmp f3_jl_result_jge


f3_jge:
    mov ax, i2         ; кладем в ax переменную i2
    jmp f3_jl_result_jge

f3_jl_result_jge:
    mov res, ax        ; максимум или минимум в зависимости от условия
    jmp end_f          ; завершаем программу


end_f:
    mov ah, 4ch        ; и наконец завершим программу
    int 21h


Main      ENDP
CODE      ENDS
END Main				;ENDS CODE
