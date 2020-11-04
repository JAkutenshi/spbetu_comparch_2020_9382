STACKSG SEGMENT  PARA STACK 'Stack'
         DW       32 DUP(?)
STACKSG	ENDS

DATASG  SEGMENT  PARA 'Data'				
    a	    DW	-1h
    b	    DW	1h
    i	    DW	1h
    k       DW  -1h
    i1      DW  1h
    i2      DW  1h
    res     DW  1h
DATASG	ENDS								

CODE      SEGMENT   						
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
    add ax, 1          ; добавим к i 1 -> (i+1)
    shl ax, 1          ; домножаем ax на 2 -> 2(i+1)
    mov bx, 4          ; положили в bx 4
    sub ax, bx         ; ax - bx =  2(i+1) - 4
    mov i1, ax         ; записываем в i1 результат 2(i+1) - 4
    jmp f2             ; переходим к f2

f1_jle:                ; a <= b
    mov ax, i          ; переменная i в ax
    add ax, 1	       ; положили в ax (i+1)
    mov bx, ax	       ; положили в bx ax
    shl ax, 1          ; домножим ax на 2 -> 2(i+1)
    add ax, bx	       ; прибавили к ax bx -> 3(i+1)
    mov bx, 5          ; положили 5 в bx
    sub bx, ax         ; bx - ax = 5 - 3(i+1)
    mov i1, bx         ; записываем в i1 результат 5 - 3(i+1)
    jmp f2

f2:
    mov ax, a          ; переменная a в ax
    cmp ax, b          ; сравниваем переменные a и b
    jle f2_jle         ; a <= b

                       ; если попали сюда, то a > b
   
    mov ax, i          ; переменная i в ax
    mov bx, ax         ; кладем в bx i
    shl ax, 1          ; 2i
    add ax, bx         ; 3i
    shl ax, 1          ; 6i
    mov bx, 8          ; кладем 8 в bx
    add ax, bx         ; 6i+8
    mov bx, 0          ; bx = 0
    sub bx, ax         ; делаем ах отрицательным
    mov i2, bx         ; записываем в i2 результат -(6 * i + 8)
    jmp f3             ; переходим к f3


f2_jle:
    mov ax, i          ; переменная i в ax
    sub ax, 1          ; отняли от i 1
    mov bx, ax         ; положили в bx ax
    shl ax, 1          ; 2(i-1)
    add ax, bx         ; 3(i-1)
    mov bx, 9          ; bx = 9
    sub bx, ax         ; 9 -3*(i-1)
    mov i2, bx         ; записываем в i2 результат 9 -3*(i-1)
    jmp f3

f3:
    mov ax, k          ; кладем в ax переменную k
    cmp ax, 0          ; сравним k с 0
    je f3_je           ; k = 0

                       ; часть, где k /= 0 
    mov ax, i1         ; кладем в ax переменную i1
    mov bx, i2         ; кладем в bx переменную i2
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
END Main				
