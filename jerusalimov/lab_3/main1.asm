STACKSG SEGMENT  PARA STACK 'Stack'
          DW       32 DUP(?)
STACKSG	ENDS

DATASG  SEGMENT  PARA 'Data'				;SEG DATA
     a	    DW	2h
     b	    DW	4h
     i	    DW	1h
     k      DW  3h
     i1     DW  ?
     i2     DW  ?
     res    DW  ?
DATASG	ENDS								;ENDS DATA

CODE      SEGMENT   						;SEG CODE
ASSUME  DS:DATASG, CS:CODE

Main    PROC  FAR
     	mov  ax, DATASG
     	mov  ds, ax

f1:
    mov ax, a ;записали в ах а
    cmp ax, b   ;сравнили а с b
    jle f1_jle      ;a<=b

    ;a>b(jg)
    mov ax, i   ;в ах засунули i
    shl ax, 1   ;умножили ах на 2
    mov i2, ax  ;записали в i2 ах
    mov bx, -2  ; расскрыли скобки из второй функции получили -2 записали ее в bx
    sub i2, bx  ; отняли от i2 bx и записали ответ в i2
    ;end f2 

    shl ax, 1   ; умножили ax на 2
    mov bx, 7   ; раскрыли скобки получили 7 записали ее
    sub bx, ax  ;отнял от 7 ax
    mov i1, bx  ;записали ответ в i1
    jmp f3

f1_jle: ;a <= b
    mov ax, i
    mov bx, 2
    mov i2, ax
    shl ax, 1
    add i2, ax
    neg i2
    add i2, bx
    ;end f2

    mov bx, i
    shl ax, 1
    shl bx, 1
    add ax, bx
    mov bx, 8
    sub bx, ax
    mov i1, bx
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
     jge f3_jl_result_jge; если |i1 - i2| >= 2, переместимся в f3_jl_result_jge
     mov res, ax        ; |i1 - i2| < 2 => res = |i1 - i2|
     jmp end_f          ; завершаем программу

f3_jl_result_jge:
     mov res, 2h        ; |i1 - i2| >= 2 => res = 2
     jmp end_f          ; завершаем программу

f3_jge:                 ; k >= 0
     mov ax, i2         ; кладем в ax переменную i2
     neg ax             ; ax = -ax
     cmp ax, -6h        ; сравниваем ax, -6
     jle f3_jge_jle     ; если -i2 <= -6, переместимся в f3_jge_jle
     mov res, ax        ; -i2 > -6 => res = -i2
     jmp end_f          ; завершаем программу

f3_jge_jle:
     mov res, -6h       ; -i2 <= -6 => res = -6

end_f:
     mov ah, 4ch        ; и наконец завершим программу
     int 21h


Main      ENDP
CODE      ENDS
END Main				;ENDS CODE
