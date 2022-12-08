[org 0x7c00]

mov bp, 0x9000
mov sp, bp

mov bx, MSG_REAL_MODE
call print_str
call pm_switch	; We never return from this call

jmp $

%include "../print/print_string.asm"
%include "gdt.asm"
%include "print_string_pm.asm"
%include "pm_switch.asm"

[bits 32]

pm_start:
	mov ebx, MSG_PROT_MODE
	call print_str_pm
	
	jmp $

MSG_REAL_MODE db "ZEON STARTED IN 16-BIT REAL MODE", 0
MSG_PROT_MODE db "Successfully switched to 32-bit Protected Mode", 0

times 510-($-$$) db 0
dw 0xaa55
