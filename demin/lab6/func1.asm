.586
.model flat, C
.code
ASM_FUN proc C LGrIn:dword, array:dword, res:dword, NInt:dword,NumRanDat:dword
        push eax
        push ecx
        push ebx
        push edx
        sub eax,eax
        sub ecx,ecx
        
for_first:
    ;�� 0 �� NInt-1
    mov edx,array
    for_second:
        ;�� 0 �� NumRanDat
        
        ;�������� ������� if

        mov ebx,LGrIn
        mov ebx,[ebx+eax*4]
        cmp ebx,[edx+ecx*4]
        jl first_if
        jmp break_if

        first_if:
            mov ebx,LGrIn
            mov ebx,[ebx+eax*4+4]
            cmp ebx,[edx+ecx*4]
            ja second_if
            jmp break_if

        second_if:
            mov edx,res
            mov ebx,[edx+eax*4]
            inc ebx
            mov [edx+eax*4],ebx
            mov edx,array
        break_if:

    inc ecx
    cmp ecx,NumRanDat
    jl for_second
mov ecx,NInt
sub ecx,1
inc eax
cmp eax,ecx
jl for_first

		;for (int i = 0; i < NInt - 1; ++i) {+
        ;  for (int j = 0; j < NumRanDat; ++j) {    +
        ;       if (array[j] > LGrIn[i] && array[j] < LGrIn[i + 1]) {
        ;           res[i]++;
        ;      }
        ;   }
        ;}
        pop edx
        pop ebx
        pop ecx
        pop eax

ret
ASM_FUN endp
end