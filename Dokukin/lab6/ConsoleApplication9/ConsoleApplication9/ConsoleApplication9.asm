Microsoft (R) Macro Assembler Version 14.15.26726.0	    02/18/21 16:13:48
module.asm						     Page 1 - 1


				.686
				.MODEL FLAT, C
				.STACK
 00000000			.DATA
 00000000			.CODE
 00000000			_form_array PROC C NumRanDat:dword, numRanges:dword, arr:dword, LGrInt:dword, res_arr:dword ; Получаем данные из программы высокого уровня

 00000003  B9 00000000		mov ecx, 0 ; счетчик для прохода по массиву
 00000008  8B 5D 10		mov ebx, [arr] ; массив случайных чисел
 0000000B  8B 75 14		mov esi, [LGrInt] ; массив с левыми границами
 0000000E  8B 7D 18		mov edi, [res_arr] ; массив-результат

 00000011			@begin:
 00000011  8B 03			mov eax, [ebx] ; берем элемент входного массива
 00000013  53				push ebx  ; сохраняем указатель на текущий элемент
 00000014  BB 00000000			mov ebx, 0 ; обнуляем указатель

 00000019			@move:
 00000019  8B D3			mov edx, ebx ; edx содержит текущий индекс массива границ
 0000001B  C1 E2 02			shl edx, 2 ; индекс умножаем на 4, т.к. каждый элемент состоит из 4 байт
 0000001E  3B 04 16			cmp eax, [esi+edx] ; сравниваем текущий элемент с текущей левой границей
 00000021  7D 02			jge @is_in
 00000023  EB 0B			jmp @continue

 00000025			@is_in:
 00000025  03 D7			add edx, edi; в массиве-ответе инкерементируем счетчик
 00000027  50				push eax
 00000028  8B 02			mov eax, [edx]
 0000002A  40				inc eax
 0000002B  89 02			mov [edx], eax
 0000002D  58				pop eax
 0000002E  EB 00			jmp @continue

 00000030			@continue: ; продолжаем обход массива границ
 00000030  43				inc ebx
 00000031  3B 5D 0C			cmp ebx, numRanges
 00000034  7E E3			jle @move
 00000036  EB 00			jmp @end

 00000038			@end:
 00000038  5B				pop ebx  ; забираем текущий элемент и ссылаемся на новый
 00000039  83 C3 04			add ebx, 4
 0000003C  41				inc ecx ; инкрементируем счетчик
 0000003D  3B 4D 08			cmp ecx, NumRanDat
 00000040  7C CF		    jl @begin

				ret

 00000044			_form_array ENDP
				END
Microsoft (R) Macro Assembler Version 14.15.26726.0	    02/18/21 16:13:48
module.asm						     Symbols 2 - 1




Segments and Groups:

                N a m e                 Size     Length   Align   Combine Class

FLAT . . . . . . . . . . . . . .	GROUP
STACK  . . . . . . . . . . . . .	32 Bit	 00000400 Para	  Stack	  'STACK'	 
_DATA  . . . . . . . . . . . . .	32 Bit	 00000000 Para	  Public  'DATA'	
_TEXT  . . . . . . . . . . . . .	32 Bit	 00000044 Para	  Public  'CODE'	


Procedures, parameters, and locals:

                N a m e                 Type     Value    Attr

_form_array  . . . . . . . . . .	P Near	 00000000 _TEXT	Length= 00000044 Public C
  NumRanDat  . . . . . . . . . .	DWord	 bp + 00000008
  numRanges  . . . . . . . . . .	DWord	 bp + 0000000C
  arr  . . . . . . . . . . . . .	DWord	 bp + 00000010
  LGrInt . . . . . . . . . . . .	DWord	 bp + 00000014
  res_arr  . . . . . . . . . . .	DWord	 bp + 00000018
  @begin . . . . . . . . . . . .	L Near	 00000011 _TEXT	
  @move  . . . . . . . . . . . .	L Near	 00000019 _TEXT	
  @is_in . . . . . . . . . . . .	L Near	 00000025 _TEXT	
  @continue  . . . . . . . . . .	L Near	 00000030 _TEXT	
  @end . . . . . . . . . . . . .	L Near	 00000038 _TEXT	


Symbols:

                N a m e                 Type     Value    Attr

@CodeSize  . . . . . . . . . . .	Number	 00000000h   
@DataSize  . . . . . . . . . . .	Number	 00000000h   
@Interface . . . . . . . . . . .	Number	 00000001h   
@Model . . . . . . . . . . . . .	Number	 00000007h   
@code  . . . . . . . . . . . . .	Text   	 _TEXT
@data  . . . . . . . . . . . . .	Text   	 FLAT
@fardata?  . . . . . . . . . . .	Text   	 FLAT
@fardata . . . . . . . . . . . .	Text   	 FLAT
@stack . . . . . . . . . . . . .	Text   	 FLAT

	   0 Warnings
	   0 Errors
