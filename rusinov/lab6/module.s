.intel_syntax noprefix
.global _MODULE_INTERVAL
.text

# 64-bit System V calling convention
# rdi
# rsi
# rdx
# rcx
# r8
# r9


# rdi -> leftBorders
# rsi -> resultArray
# rdx -> numberArray
# rcx -> size

_MODULE_INTERVAL:
    SUB rax, rax            # кол-во обработанных элементов из numberArray
    SUB rbx, rbx            # счетчик обработанных границ

GET_NUMBER:
    MOV r8, [rdx]

CHECK_BORDERS:
    CMP r8, [rdi+rbx]
    JLE MATCHED_BORDER

    ADD rbx, 8
    JMP CHECK_BORDERS

MATCHED_BORDER:
    MOV r8, [rsi+rbx]
    INC r8
    MOV [rsi+rbx], r8

    ADD rdx, 8
    INC rax

    SUB rbx, rbx
    CMP rax, rcx
    JL GET_NUMBER

RET
