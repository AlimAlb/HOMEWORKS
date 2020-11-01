format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
;Вариант 1.
;Албогачиев Алим Ахмедович, БПИ196


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
;вызов функции, вычисляющей необходимую последовательность.
	call Tribonacci
;вызов функции, выводящей полученное число.
	call Output
finish:
;вызов фукнции принимающей char для продления работы программы
	call [getch]

	push 0
	call [ExitProcess]


;--------------------------------------------------------------------------
Output:
	;пушим в стек строку для вывода
	push strOutput
	call [printf]
	;сохраняем текущее значение стека, чтобы в последствии вернуться к нему
	mov [tmpStack], esp
	;выводим найденное число
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
	;перенос значения первого числа в eax
	mov eax, [num1]
	;прибаление к нему двух других
	add eax, [num2]
	add eax, [num3]
	;перенос в первую ячейку второй
	mov edx, [num2]
	mov [num1], edx
	;перенос во вторую ячейку третьей
	mov edx,[num3]
	mov [num2], edx
	;перенос в третью ячейку нового значения
	mov [num3], eax
	;проверка переполнения
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