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
    ;от 0 до NInt-1
    mov edx,array
    for_second:
        ;от 0 до NumRanDat
        
        ;проверка условия if array[j] > LGrIn[i]

        mov ebx,LGrIn
        mov ebx,[ebx+eax*4]
        cmp ebx,[edx+ecx*4]
        jle first_if
        jmp break_if

        first_if:     ;проверка условия array[j] < LGrIn[i + 1]
            mov ebx,LGrIn
            mov ebx,[ebx+eax*4+4]
            cmp ebx,[edx+ecx*4]
            jae second_if
            jmp break_if

        second_if:   ;  res[i]++;
            mov edx,res
            mov ebx,[edx+eax*4]
            inc ebx
            mov [edx+eax*4],ebx
            mov edx,array
        break_if:

    inc ecx
    cmp ecx,NumRanDat    ;j < NumRanDat
    jl for_second

mov ecx,NInt
sub ecx,1
inc eax
cmp eax,ecx    ; i < NInt - 1
jl for_first

pop edx
pop ebx
pop ecx
pop eax

ret
ASM_FUN endp
end