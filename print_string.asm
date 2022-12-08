print:
	pusha
	mov ah, 0x0e
	
loop_str:
	cmp byte [bx], 0
	jle loop_str_end
	mov al, [bx]
	int 0x10
	add bx, 0x0001
	jmp loop_str
loop_str_end:
	popa
	ret
