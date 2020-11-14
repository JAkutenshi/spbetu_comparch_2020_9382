AStack SEGMENT STACK
 DW 12 DUP(?)
AStack ENDS

DATA SEGMENT
a  DW -5
b  DW -4
i  DW -3
k  DW -1 
i1  DW 0
i2 DW 0
res DW 0
DATA ENDS

CODE SEGMENT
 ASSUME CS:CODE, DS:DATA, SS:AStack

Main PROC FAR
 push DS
 sub AX,AX
 push AX
 mov AX, DATA
 mov DS, AX
 mov CX, DS:a
 mov DX, DS:b
 cmp CX, DX
 jg aGTb
 jmp aLEb

 aGTb:
     mov AX, DS:i
     sal AX, 1
     mov CX, 15
     sub CX, AX
     mov DS:i1, CX

     mov AX, DS:i
     mov CX, AX
     sal CX, 1
     add CX, AX
     sal CX, 1

     mov AX, 4
     sub AX, CX

     mov DS:i2, AX
     jmp k_handle

 aLEb:
 	 mov AX, DS:i
 	 sal AX, 1
 	 add AX, DS:i
 	 add AX, 4
 	 mov DS:i1, AX

 	 mov AX, DS:i
 	 add AX, 2
 	 mov CX, AX
 	 sal AX, 1
 	 add AX, CX
 	 mov DS:i2, AX
 	 jmp k_handle

 k_handle:
 	 cmp DS:k, 0
     jz kEQzero
     jmp kNotEQzero

 kEQzero:
     mov AX, DS:i1
     add AX, DS:i2
     cmp AX, 0
     jl neg_case
     jmp end_case

 neg_case:
     neg AX
     jmp end_case

 kNotEQzero:
 	 mov AX, DS:i1
 	 mov CX, DS:i2
 	 cmp AX, CX
 	 jl end_case
 	 mov CX, AX
 	 jmp end_case

 end_case:
     mov DS:res, AX
     ret

Main ENDP
CODE ENDS
 END Main
