AStack SEGMENT STACK
 DW 12 DUP(?)
AStack ENDS

DATA SEGMENT
a   DW 5
b   DW 4
i   DW 3
k   DW 1 
i1  DW 0
i2  DW 0
res DW 0
DATA ENDS

CODE SEGMENT
 ASSUME CS:CODE, DS:DATA, SS:AStack

Main PROC FAR
 push DS
 sub  AX,AX
 push AX
 mov AX, DATA
 mov DS, AX
 mov CX, DS:a
 mov DX, DS:b
 cmp CX, DX
 jg AgreaterB
 jmp AlessequalB

AgreaterB:
 mov AX, DS:i  ; AX = i
 sal AX, 1     ; AX = 2i
 mov BX, 15    ; BX = 15
 sub BX, AX    ; BX = 15 - 2i
 mov DS:i1, BX ; i1 = 15 - 2i
 add AX, DS:i  ; AX = 3i
 sal AX, 1     ; AX = 6i
 mov BX, -8    ; BX = -8
 sub BX, AX    ; BX = -6i - 8
 mov DS:i2, BX ; i2 = -8 - 6i
 jmp cont

AlessequalB:
 mov AX, DS:i  ; AX = i
 sal AX, 1     ; AX = 2i
 add AX, DS:i  ; AX = 3i
 mov BX, 4     ; BX = 4
 add BX, AX    ; BX = 3i + 4
 mov DS:i1, BX ; i1 = 3i + 4
 mov BX, 12    ; BX = 12
 sub BX, AX    ; BX = 12 - 3i
 mov DS:i2, BX ; i2 = 12 - 3i

cont:
 mov AX, DS:i1 ; AX = i
absI1:
 neg AX
 js absI1      ; while SF is set (AX < 0)
 ; AX = |i1|
 mov BX, DS:k
 cmp BX, 0
 jge KgreaterequalZero
 jmp KlessZero

KgreaterequalZero:
 mov BX, 6
 cmp AX, BX
 jg I1greater6
 jmp endmain

KlessZero:
 mov BX, DS:i2
absI2:
 neg BX
 js absI2      ; while SF is set (BX < 0)
 ; BX = |i2|
 add BX, AX    ; BX = |i1| + |i2|
 jmp endmain

I1greater6:
 mov BX, AX

endmain:
 mov DS:res, BX ; res = |i1| + |i2| OR res = max(6, |i1|)
 ret
Main ENDP
CODE ENDS
 END Main