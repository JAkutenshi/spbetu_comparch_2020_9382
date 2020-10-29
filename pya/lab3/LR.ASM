AStack SEGMENT STACK
 DW 12 DUP(?)
AStack ENDS
; Данные программы
DATA SEGMENT
a  DW -5
b  DW -4
i  DW -3
k  DW -1 
i1  DW 0
i2 DW 0
res DW 0
DATA ENDS
; Код программы
CODE SEGMENT
 ASSUME CS:CODE, DS:DATA, SS:AStack
; Головная процедура
Main PROC FAR
 push DS
 sub AX,AX
 push AX
 mov AX, DATA
 mov DS, AX
 mov CX, DS:a
 mov DX, DS:b
 cmp CX, DX
 jg fst_case
 mov AX, DS:i
 sal AX, 1
 sal AX, 1
 add AX, DS:i
 add AX, DS:i
 mov CX, 8
 sub CX, AX
 mov DS:i1, CX
 sub AX, 6
 neg AX
 mov DS:i2, AX
 cmp DS:k, 0
 jz thrd_case
 mov CX, DS:i1
 cmp CX, AX
 jl min_case
 jmp end_case

 min_case:
     mov AX, CX
     jmp end_case

 thrd_case:
     mov AX, DS:i1
     add AX, DS:i2
     cmp AX, 0
     jl n_case
     jmp end_case

 n_case:
     neg AX
     jmp end_case

 fst_case:
     mov AX, DS:i
     sal AX, 1
     sal AX, 1
     mov CX, 7
     sub CX, AX
     mov DS:i1, CX
     mov CX, 20
     sub CX, AX
     mov DS:i2, CX
     cmp DS:k, 0
     jz thrd_case

 end_case:
     mov DS:res, AX
     ret
Main ENDP
CODE ENDS
 END Main