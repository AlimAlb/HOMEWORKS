format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
;Создать новый массив на основе введенного, который состоит из его положительных элементов. Вариант 1.
;Албогачиев Алим Ахмедович, БПИ196


section '.data' data readable writable

	strVecSize   db 'size of vector? ', 0
	strIncorSize db 'Incorrect size of vector = %d', 10, 0
	strVecElemI  db '[%d]? ', 0
	strScanInt   db '%d', 0
	strVecElemOut  db '[%d] = %d', 10, 0
	strOutputVector db 'Array of positive elements of base array:', 10, 0

	vec_size1     dd 0
	vec_size2    dd 0
	sum	     dd 0
	i	     dd ?
	j	     dd 0
	tmp1	      dd ?
	tmp2	      dd ?
	tmpStack     dd ?
	vec1	      rd 100
	vec2	      rd 100

;--------------------------------------------------------------------------
section '.code' code readable executable
start:
; 1) vector input
	call VectorInput
; 2) make new array from base-array: all positive elements of base-array
	call newArray
; 4) print second array
	call VectorOut
finish:
	call [getch]

	push 0
	call [ExitProcess]

;--------------------------------------------------------------------------
VectorInput:
	push strVecSize
	call [printf]
	add esp, 4

	push vec_size1
	push strScanInt
	call [scanf]
	add esp, 8

	mov eax, [vec_size1]
	cmp eax, 0
	jg  getVector
; fail size
       fail:
	push [vec_size1]
	push strIncorSize
	call [printf]
	call [getch]
	push 0
	call [ExitProcess]
; else continue...
getVector:
	cmp eax, 100
	jg fail
	xor ecx, ecx		; ecx = 0
	mov ebx, vec1		 ; ebx = &vec
getVecLoop:
	mov [tmp1], ebx
	cmp ecx, [vec_size1]
	jge endInputVector	 ; to end of loop

	; input element
	mov [i], ecx
	push ecx
	push strVecElemI
	call [printf]
	add esp, 8

	push ebx
	push strScanInt
	call [scanf]
	add esp, 8

	mov ecx, [i]
	inc ecx
	mov ebx, [tmp1]
	add ebx, 4
	jmp getVecLoop
endInputVector:
	ret

;--------------------------------------------------------------------------
VectorOut:
	push strOutputVector
	call [printf]

	mov [tmpStack], esp
	xor ecx, ecx		; ecx = 0
	mov ebx, vec2		; ebx = &vec




putVecLoop:
	mov [tmp2], ebx
	cmp ecx, [vec_size2]
	je endOutputVector	; to end of loop
	mov [i], ecx
	; output element
	push dword [ebx]
	push ecx
	push strVecElemOut
	call [printf]

	mov ecx, [i]
	inc ecx
	mov ebx, [tmp2]
	add ebx, 4
	jmp putVecLoop
endOutputVector:
	mov esp, [tmpStack]
	ret
;--------------------------------------------------------------------------
newArray:
	xor ecx, ecx
	xor eax, eax
	mov ebx, vec1
	mov edx, vec2
getArrayLoop:
;-----------if current elements index is bigger than vec_size1 than goto endNewArray------
	cmp ecx, [vec_size1]
	jge endNewArray


	mov eax, [ebx]
	cmp eax, 0
	jnge endOfIteration
	mov eax, [ebx]
	mov [edx], eax

;-----------increment counter of second array---------
	mov [i], ecx
	mov ecx, [j]
	inc ecx
	mov [j], ecx
	mov ecx, [i]
	add edx, 4
;-----------------------------------------------------

	endOfIteration:
;-----------incrementing counter of first array and going to next element------------------
	inc ecx
	add ebx, 4
	jmp getArrayLoop
endNewArray:
;-----------saving vector_size2--------------------------
mov ecx, [j]
mov [vec_size2], ecx
ret
;-------------------------------third act - including HeapApi--------------------------
						 
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