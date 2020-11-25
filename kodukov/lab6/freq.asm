.686
.MODEL FLAT, C
.DATA
offsetcountn dd 0

.CODE
PUBLIC C UNIT
;������������� �� ���������� ��������� �����
UNIT PROC C Number:dword, NumRanDat:byte, CountNumUnit1:dword, Xmin:byte
  PUSH EDI ;���������� ���������
  PUSH ESI
  MOV EAX, DWORD PTR Xmin ;��������� �������� xmin
  MOV EDI, Number ;��������� ������ ������� ��������� �����
  MOV ESI, CountNumUnit1 ;��������� ������ ������� �������� �����
  MOV ECX, DWORD PTR NumRanDat ;��������� ����� ������� ��������� �����

  cycle:
    MOV EBX,[EDI] ; ��������� �����
    SUB EBX,EAX ; ������� xmin
    MOV EDX,[ESI+4*EBX] ; �������� ������� ����� �����
    INC EDX ; ��������� 1
    MOV [ESI+4*EBX],EDX ; ������� � ������� ������
    ADD EDI,4 ; ������� � ���� �����
    LOOP cycle ; ��������� ���� �� ������ ���� ������
    POP ESI ;�������������� �������� ���������
    POP EDI
  RET
UNIT ENDP

PUBLIC C ARBITARY ;������������� �� ���������� ������������ �����
ARBITARY PROC C CountNumUnit1:dword, lenUnit1:byte, LGrInt:dword, CountNumN:dword ,NInt:byte, Xmin:byte
  PUSH EDI ;���������� ���������
  PUSH ESI
  MOV EDI,DWORD PTR lenUnit1 ;��������� ��������� �� ��������� ������� ������� ������� ��������� �����
  DEC EDI
  SHL EDI,2
  ADD EDI,CountNumUnit1
  MOV ECX,DWORD PTR lenUnit1 ;��������� ��������
  MOV EAX, DWORD PTR NInt ;��������� ���������� �� ��������� �������� ��������
  DEC EAX
  SHL EAX,2
  push edi
  MOV ESI, LGrInt
  MOV Edi, CountNumN
  ADD Edi,EAX
  ADD ESI,EAX
  MOV offsetcountn,edi
  pop edi
  ; ��������� ����� ����������� �����
  SUB EAX,EAX
  MOV EAX, dword PTR Xmin
  ADD EAX, ECX
  DEC EAX
  MOV EBX,[ESI]

  cycle:
    CMP EAX,EBX
    JL falseif
    PUSH EAX
    push esi
    mov esi,offsetcountn
    MOV EDX,[Esi]
    MOV EAX,[EDI]
    ADD EDX,EAX
    MOV [Esi],EDX
    pop esi
    POP EAX
    JMP endif1
  falseif:
    SUB ESI,4
    SUB offsetcountn,4
    MOV EBX,[ESI]
    JMP cycle
    endif1:
    DEC EAX
    SUB EDI,4
  LOOP cycle ;��������� �� ��� ��� ���� �� ������� ���� ������
  POP ESI ;�������������� �������� ���������
  POP EDI
  RET
ARBITARY ENDP
END