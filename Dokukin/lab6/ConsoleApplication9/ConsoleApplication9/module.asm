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
	push ecx
	mov ebx, 0 ; �������� ���������
	mov ecx, 1 ; ������� ��� ������� �� ��������

@move:
	mov edx, ebx ; edx �������� ������� ������ ������� ������

	shl edx, 2 ; ������ �������� �� 4, �.�. ������ ������� ������� �� 4 ����
	cmp eax, [esi+edx] ; ���������� ������� ������� � ������� ����� ��������
	jl @end
	add edx, 4
	cmp ecx, numRanges
	je @is_in ; ���� ����� �� ��������� ������� - ������� ����� ���������� � ���
	cmp eax, [esi+edx] ; ���������� �� ��������� ����� ��������
	jl @is_in ; ���� ������ - ����� � �������
	jmp @continue ; ����� - ���� ������ �� �������

@is_in:
	sub edx, 4
	add edx, edi; � �������-������ �������������� �������
	push eax
	mov eax, [edx]
	inc eax
	mov [edx], eax
	pop eax
	jmp @end

@continue: ; ���������� ����� ������� ������
	inc ebx
	inc ecx
	jmp @move

@end:
	pop ecx
	pop ebx  ; �������� ������� ������� � ��������� �� �����
	add ebx, 4
	inc ecx ; �������������� �������
	cmp ecx, NumRanDat
    jl @begin

ret

_form_array ENDP
END