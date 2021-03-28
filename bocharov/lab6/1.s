.intel_syntax noprefix
.global count_int
.text

# The first six integer or pointer arguments are passed in registers RDI, RSI, RDX, RCX, R8, R9

# rdi -> array
# rsi -> array_size
# rdx -> borders
# rcx -> borders_size
# r8 -> res
count_int:
        sub rax, rax            # счетчик для пробега по array
        sub rbx, rbx            # счетчик для borders
        sub r9, r9
    get_num:
        mov r9,[rdi]            # получаем число из array

    check_right:
        cmp r9,[rdx+rbx+8]      # проверяем левее ли число от текущей границы

        jl end                  # если число меньше текущей границы переходим в конец

        add rbx, 8             # если нет, берем следующую границу
        jmp check_right

    end:
        mov r9, [r8+rbx]
        inc r9
        mov [r8+rbx], r9     # увеличиваем кол-во чисел попавших в промежуток

        add rdi, 8          # берем адрес следующего элемента из array
        inc rax

        sub rbx, rbx
        cmp rax , rsi      #  проверка на конец array
        jl get_num
ret
