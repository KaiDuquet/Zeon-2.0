[bits 32]

VID_MEM equ 0xb8000
WHITE_ON_BLACK equ 0x0f

print_str_pm:
	pusha
	mov edx, VID_MEM

loop_str_pm:
	mov al, [ebx]
	mov ah, WHITE_ON_BLACK

	cmp al, 0
	je loop_str_pm_end
	
	mov [edx], ax
	add ebx, 1
	add edx, 2

	jmp loop_str_pm

loop_str_pm_end:
	popa
	ret
