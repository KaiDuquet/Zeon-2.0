print_str:
	pusha
	mov ah, 0x0e
	
loop_str:
	mov al, [bx]
	cmp al, 0
	je loop_str_end

	int 0x10
	add bx, 1
	jmp loop_str

loop_str_end:
	popa
	ret
