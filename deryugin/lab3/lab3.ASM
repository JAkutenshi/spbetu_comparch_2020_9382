AStack SEGMENT STACK
 DW 12 DUP(?)
AStack ENDS
DATA SEGMENT
a  DW 5
b  DW 6
i  DW 7
k  DW 9 
i1  DW ?
i2 DW ?
res DW ?
DATA ENDS

CODE SEGMENT
 ASSUME CS:CODE, DS:DATA, SS:AStack
 
Main PROC FAR
 push ds
 sub ax, ax
 push ax
 mov ax, DATA
 sub ax, ax
 mov ds, ax
 sub ax, ax
 mov ax, a
 mov bx, b 
 mov cx, i 
 cmp ax, bx
 ja agb
	; a<=b
	add i1, cx; i1 = i
	add bx, cx; bx = i
	shl cx, 1; cx = i*2
	add bx, cx; i1 = i+ i*2
	add i1, bx; i1 = i+i*2
	neg bx; cx = -i*2 - i
	add i2, bx; i2 = -i-i*2
	add i2, 10; i2 = -i-i*2 + 10
	add i1, 4; i1 = i+i*2 + 4
	jmp checkk
	
  
; a > b
 agb:
  shl cx, 1; cx = i*2
  neg cx; cx = -i*2
  add i1, cx; i1 = -i*2
  shl cx, 1; cx = -i*4
  add cx, 5; cx = -i*4 + 5
  add i2, cx; i2 = -i*4+5
  add i1, 15; i1 = -i*2 + 15 
  jmp checkk
 
 checkk:
  mov ax, k; ax = k
  cmp ax, 0
  jb klz
  ;k>=0
  mov bx, i2; bx = i2
  cmp bx, 0
  jb lesszero
  ;i2>=0
  cmp bx, 7
  jb maxseven
  mov res, bx
  ret
  
 klz:
 ;k<0
  mov cx, i1; cx = i1 
  mov dx, i2; dx = i2
  neg dx;; dx = -i2 
  add cx, dx; cx = i1-i2
  cmp cx, 0
  jb lesszero
  ; cx>=0
  mov res, cx
  ret
  
 lesszero:
  neg cx
  
 maxseven:
  mov bx, 7

Main ENDP
CODE ENDS
 END Main 
 