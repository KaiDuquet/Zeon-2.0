; dx will contain our hex number to print
print_hex:
	pusha
	mov cx, 0
loop_hex:
	cmp cx, 4
	je loop_hex_end

	mov ax, dx
	and ax, 0x000f
	add al, 0x30
	cmp al, 0x39
	jle loop_hex2
	add al, 7

loop_hex2:
	mov bx, HEX_OUT + 5 ; size - 1
	sub bx, cx
	mov [bx], al
	shr dx, 4
	add cx, 1
	jmp loop_hex

loop_hex_end:
	mov bx, HEX_OUT
	call print

	popa
	ret

HEX_OUT: db "0x0000", 0
