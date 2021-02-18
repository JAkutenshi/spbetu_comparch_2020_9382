Microsoft (R) Macro Assembler Version 14.15.26726.0	    02/18/21 18:31:49
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
 00000014  51				push ecx
 00000015  BB 00000000			mov ebx, 0 ; обнуляем указатель
 0000001A  B9 00000001			mov ecx, 1 ; счетчик для прохода по границам

 0000001F			@move:
 0000001F  8B D3			mov edx, ebx ; edx содержит текущий индекс массива границ

 00000021  C1 E2 02			shl edx, 2 ; индекс умножаем на 4, т.к. каждый элемент состоит из 4 байт
 00000024  3B 04 16			cmp eax, [esi+edx] ; сравниваем текущий элемент с текущей левой границей
 00000027  7C 21			jl @end
 00000029  83 C2 04			add edx, 4
 0000002C  3B 4D 0C			cmp ecx, numRanges
 0000002F  74 07			je @is_in ; если дошли до последней границы - элемент точно содержится в ней
 00000031  3B 04 16			cmp eax, [esi+edx] ; сравниваем со следующей левой границей
 00000034  7C 02			jl @is_in ; если меньше - попал в отрезок
 00000036  EB 0E			jmp @continue ; иначе - идем дальше по массиву

 00000038			@is_in:
 00000038  83 EA 04			sub edx, 4
 0000003B  03 D7			add edx, edi; в массиве-ответе инкрементируем счетчик
 0000003D  50				push eax
 0000003E  8B 02			mov eax, [edx]
 00000040  40				inc eax
 00000041  89 02			mov [edx], eax
 00000043  58				pop eax
 00000044  EB 04			jmp @end

 00000046			@continue: ; продолжаем обход массива границ
 00000046  43				inc ebx
 00000047  41				inc ecx
 00000048  EB D5			jmp @move

 0000004A			@end:
 0000004A  59				pop ecx
 0000004B  5B				pop ebx  ; забираем текущий элемент и ссылаемся на новый
 0000004C  83 C3 04			add ebx, 4
 0000004F  41				inc ecx ; инкрементируем счетчик
 00000050  3B 4D 08			cmp ecx, NumRanDat
 00000053  7C BC		    jl @begin

				ret

 00000057			_form_array ENDP
				END
Microsoft (R) Macro Assembler Version 14.15.26726.0	    02/18/21 18:31:49
module.asm						     Symbols 2 - 1




Segments and Groups:

                N a m e                 Size     Length   Align   Combine Class

FLAT . . . . . . . . . . . . . .	GROUP
STACK  . . . . . . . . . . . . .	32 Bit	 00000400 Para	  Stack	  'STACK'	 
_DATA  . . . . . . . . . . . . .	32 Bit	 00000000 Para	  Public  'DATA'	
_TEXT  . . . . . . . . . . . . .	32 Bit	 00000057 Para	  Public  'CODE'	


Procedures, parameters, and locals:

                N a m e                 Type     Value    Attr

_form_array  . . . . . . . . . .	P Near	 00000000 _TEXT	Length= 00000057 Public C
  NumRanDat  . . . . . . . . . .	DWord	 bp + 00000008
  numRanges  . . . . . . . . . .	DWord	 bp + 0000000C
  arr  . . . . . . . . . . . . .	DWord	 bp + 00000010
  LGrInt . . . . . . . . . . . .	DWord	 bp + 00000014
  res_arr  . . . . . . . . . . .	DWord	 bp + 00000018
  @begin . . . . . . . . . . . .	L Near	 00000011 _TEXT	
  @move  . . . . . . . . . . . .	L Near	 0000001F _TEXT	
  @is_in . . . . . . . . . . . .	L Near	 00000038 _TEXT	
  @continue  . . . . . . . . . .	L Near	 00000046 _TEXT	
  @end . . . . . . . . . . . . .	L Near	 0000004A _TEXT	


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
