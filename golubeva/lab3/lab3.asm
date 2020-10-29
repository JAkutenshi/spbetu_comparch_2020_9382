STACKSG SEGMENT  PARA STACK 'Stack'
          DW       32 DUP(?)
STACKSG	ENDS

DATASG  SEGMENT  PARA 'Data'				;SEG DATA
     a	    DW	1h
     b	    DW	1h
     i	    DW	1h
     k      DW  1h
     i1     DW  1h
     i2     DW  1h
     res    DW  1h
DATASG	ENDS								;ENDS DATA

CODE      SEGMENT   						;SEG CODE
ASSUME  DS:DATASG, CS:CODE

Main    PROC  FAR
     	mov  ax, DATASG
     	mov  ds, ax

f1:
     mov ax, a		 ; переменная a в ax
     cmp ax, b		 ; сравниваем переменные a и b соответственно
     jle f1_1           ; a <= b

                        ; если попали сюда, то a > b
     mov ax, i          ; переменная i в ax
     shl ax, 1          ; умножим i на 2
     mov bx, 15h         ; кладем в bx 15
     sub bx, ax         ; bx - ax = 15 - i * 2
     mov i1, bx         ; записываем в i1 результат 15 - i * 2
     jmp f2             ; переходим к f2

f1_1:                   ; a <= b

     mov ax, i		 ; переменная i в ax
     mov bx, i		 ; переменная i в bx
     
     shl ax, 1		; умножим i на 2
     
     add ax, bx	;получаем 3*i

     mov bx, 4h	; кладем в bx 4
     add ax, bx	;ax+4
     
     mov i1, ax	; записываем в i1 результат 3*i+4
       
     jmp f2

f2:
     mov ax, a          ; переменная a в ax
     cmp ax, b          ; сравниваем переменные a и b
     jle f2_1           ; a <= b



     mov ax, i		 ; переменная i в ax
     mov bx, 20h	 ; кладем в bx 20
     shl ax, 1		 ; умножим i на 2
     shl ax, 1		 ; умножим i на 2
     
     mov i2, bx	; кладем в i2 20
     sub i2, ax 	;i2=20-4i

     jmp f3             ; переходим к f3

f2_1:
     mov ax, i 	; переменная i в ax
     mov bx, 1h	; кладем в bx 1
     sub ax, bx	;ax=i-1
     
     shl ax, 1		;ax=(i-1)2
     mov bx, ax	;bx=(i-1)2
     shl ax, 1		;ax=(i-1)4
     add ax, bx	;ax=(i-1)6
     neg ax		;ax=-(i-1)6

     mov i2, ax	;i2=bx
     
     jmp f3

f3:
     mov ax, k          ; кладем в ax переменную k
     cmp ax, 0          ; сравним k с 0
     jge f3_1           ; k >= 0

                        ; если оказались здесь, то k < 0 
     mov ax, i1         ; кладем в ax переменную i1
     sub ax, i2         ; ax = i1 - i2

     cmp ax, 0          ; сравним i1 - i2 с нулем
     jl f3_ABS          ; если i1 - i2 < 0, то стоит взять модуль
     jmp f3_result   ; переход в f3_result

f3_ABS:
     neg ax             ; взяли модуль i1 - i2

f3_result:
     cmp ax, 2h         ; сравним |i1 - i2| с 2
     jge f3_jl_result; если |i1 - i2| >= 2, переместимся в f3_jl_result
     mov res, ax        ; |i1 - i2| < 2 => res = |i1 - i2|
     jmp end_f          ; завершаем программу

f3_jl_result:
     mov res, 2h        ; |i1 - i2| >= 2 => res = 2
     jmp end_f          ; завершаем программу

f3_1:                   ; k >= 0
     mov ax, i2         ; кладем в ax переменную i2
     neg ax             ; ax = -ax
     cmp ax, -6h        ; сравниваем ax, -6
     jle f3_jge    ; если -i2 <= -6, переместимся в f3_jge
     mov res, ax        ; -i2 > -6 => res = -i2
     jmp end_f          ; завершаем программу

f3_jge:
     mov res, -6h       ; -i2 <= -6 => res = -6

end_f:
     mov ah, 4ch        ; завершим программу
     int 21h


Main      ENDP
CODE      ENDS
END Main				;ENDS CODE

