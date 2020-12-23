page 120, 200; Logic module
ACHAR EQU 41h
EXTRN OUT_STR:BYTE; Defined in mod1.asm
PUBLIC INT_TO_STR
PUBLIC STR_TO_INT

CODE SEGMENT PUBLIC
	ASSUME CS:CODE

INT_TO_STR PROC NEAR
	MOV BX, AX; Save input
	LEA DI, OUT_STR; Load String adress
	MOV CX, 4; Counter
TO_STR:
	MOV AL, BH
	SHR AL, 1; Shift 4 bits right
	SHR AL, 1
	SHR AL, 1
	SHR AL, 1
	AND AL, 15
	ADD AL, 30h; '0' char
	CMP AL, 3Ah; '9' char
		JB TEN_CHAR_LOWER
	ADD AL, 7h; '0' to 'A' char
TEN_CHAR_LOWER:
	STOSB; Write AL to ES:DI then DI++
	SHL BX, 1; Shift 4 bits left
	SHL BX, 1
	SHL BX, 1
	SHL BX, 1
	LOOP TO_STR
	RET
INT_TO_STR ENDP
CODE ENDS

CODE_2 SEGMENT PUBLIC
	ASSUME CS:CODE_2

STR_TO_INT PROC FAR; Returns result to DX:AX
	PUSH BP; Save BP
	MOV BP, SP
	MOV SI, [BP+6]; Get string adress (0 - old BP; 2,4 - CALL return)
	MOV CX, 4; Counter
	MOV BX, 0; Result
TO_INT:
	LODSB; AL char from ES:SI
	SUB AL, 30h; '0' char
	CMP AL, 10h; ':' (above '9')
		JB TEN_LOWER
	SUB AL, 7h; '0' to 'A' char
TEN_LOWER:
	SHL BX, 1; Shift 4 bits left
	SHL BX, 1
	SHL BX, 1
	SHL BX, 1
	ADD BL, AL
	LOOP TO_INT
	MOV AX, BX; Result
	MOV SP, BP; Resore stack
	POP BP; Restore BP
	RET
STR_TO_INT ENDP 

CODE_2 ENDS

	END 