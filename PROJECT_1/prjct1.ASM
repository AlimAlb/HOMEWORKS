format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
;������� 1.
;���������� ���� ���������, ���196


section '.data' data readable writable


	strScanInt   db '%d', 0
	strOutput db 'Max integer number of Tribonacci sequence before double world oveflow:', 10, 0


	num1	      dd 0
	num2	      dd 0
	num3	      dd 1
	curr	      dd 1
	tmpStack     dd ?


;--------------------------------------------------------------------------
section '.code' code readable executable
start:
;����� �������, ����������� ����������� ������������������.
	call Tribonacci
;����� �������, ��������� ���������� �����.
	call Output
finish:
;����� ������� ����������� char ��� ��������� ������ ���������
	call [getch]

	push 0
	call [ExitProcess]


;--------------------------------------------------------------------------
Output:
	;����� � ���� ������ ��� ������
	push strOutput
	call [printf]
	;��������� ������� �������� �����, ����� � ����������� ��������� � ����
	mov [tmpStack], esp
	;������� ��������� �����
	mov eax, [num2]
	push eax
	push strScanInt
	call[printf]
	mov esp, [tmpStack]
	ret
;--------------------------------------------------------------------------
Tribonacci:
	xor edx, edx
TribonacciLoop:
	;������� �������� ������� ����� � eax
	mov eax, [num1]
	;���������� � ���� ���� ������
	add eax, [num2]
	add eax, [num3]
	;������� � ������ ������ ������
	mov edx, [num2]
	mov [num1], edx
	;������� �� ������ ������ �������
	mov edx,[num3]
	mov [num2], edx
	;������� � ������ ������ ������ ��������
	mov [num3], eax
	;�������� ������������
	jo endTribonacciLoop
	jmp TribonacciLoop
endTribonacciLoop:
ret


;---------------------------------------------------------
						 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
	    msvcrt, 'msvcrt.dll',\
	    user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
	   ExitProcess, 'ExitProcess',\
	   HeapCreate,'HeapCreate',\
	   HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
	   printf, 'printf',\
	   scanf, 'scanf',\
	   getch, '_getch'