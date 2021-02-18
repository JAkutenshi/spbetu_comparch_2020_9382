.686
.MODEL FLAT, C
.STACK
.DATA
.CODE
_form_array PROC C NumRanDat:dword, numRanges:dword, arr:dword, LGrInt:dword, res_arr:dword ; �������� ������ �� ��������� �������� ������

mov ecx, 0 ; ������� ��� ������� �� �������
mov ebx, [arr] ; ������ ��������� �����
mov esi, [LGrInt] ; ������ � ������ ���������
mov edi, [res_arr] ; ������-���������

@begin:
	mov eax, [ebx] ; ����� ������� �������� �������
	push ebx  ; ��������� ��������� �� ������� �������
	mov ebx, 0 ; �������� ���������

@move:
	mov edx, ebx ; edx �������� ������� ������ ������� ������
	shl edx, 2 ; ������ �������� �� 4, �.�. ������ ������� ������� �� 4 ����
	cmp eax, [esi+edx] ; ���������� ������� ������� � ������� ����� ��������
	jge @is_in
	jmp @continue

@is_in:
	add edx, edi; � �������-������ ��������������� �������
	push eax
	mov eax, [edx]
	inc eax
	mov [edx], eax
	pop eax
	jmp @continue

@continue: ; ���������� ����� ������� ������
	inc ebx
	cmp ebx, numRanges
	jle @move
	jmp @end

@end:
	pop ebx  ; �������� ������� ������� � ��������� �� �����
	add ebx, 4
	inc ecx ; �������������� �������
	cmp ecx, NumRanDat
    jl @begin

ret

_form_array ENDP
END