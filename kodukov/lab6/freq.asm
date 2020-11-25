.686
.MODEL FLAT, C
.DATA
offsetcountn dd 0

.CODE
PUBLIC C UNIT
;распределение по интервалам единичной длины
UNIT PROC C Number:dword, NumRanDat:byte, CountNumUnit1:dword, Xmin:byte
  PUSH EDI ;сохранение регистров
  PUSH ESI
  MOV EAX, DWORD PTR Xmin ;получение значение xmin
  MOV EDI, Number ;получение адреса массива случайных чисел
  MOV ESI, CountNumUnit1 ;получение адреса массива счетчика чисел
  MOV ECX, DWORD PTR NumRanDat ;получение длины массива случайных чисел

  cycle:
    MOV EBX,[EDI] ; получение числа
    SUB EBX,EAX ; вычесть xmin
    MOV EDX,[ESI+4*EBX] ; получить счетчик этого числа
    INC EDX ; прибавить 1
    MOV [ESI+4*EBX],EDX ; занести в обратно массив
    ADD EDI,4 ; переход к след числу
    LOOP cycle ; повторять пока не прошли весь массив
    POP ESI ;восстановление значений регистров
    POP EDI
  RET
UNIT ENDP

PUBLIC C ARBITARY ;распределение по интервалам произвольной длины
ARBITARY PROC C CountNumUnit1:dword, lenUnit1:byte, LGrInt:dword, CountNumN:dword ,NInt:byte, Xmin:byte
  PUSH EDI ;сохранение регистров
  PUSH ESI
  MOV EDI,DWORD PTR lenUnit1 ;получение указателя на последний элемент массива счечика единичной длины
  DEC EDI
  SHL EDI,2
  ADD EDI,CountNumUnit1
  MOV ECX,DWORD PTR lenUnit1 ;получение счетчика
  MOV EAX, DWORD PTR NInt ;получение указателей на последние элементы массивов
  DEC EAX
  SHL EAX,2
  push edi
  MOV ESI, LGrInt
  MOV Edi, CountNumN
  ADD Edi,EAX
  ADD ESI,EAX
  MOV offsetcountn,edi
  pop edi
  ; опрерации перед выполнением цикла
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
  LOOP cycle ;повторять до тех ПОР ПОКА НЕ ПРОЙДЕМ ВЕСЬ МАССИВ
  POP ESI ;восстановление значений регистров
  POP EDI
  RET
ARBITARY ENDP
END