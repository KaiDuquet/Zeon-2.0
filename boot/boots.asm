[bits 16]
[org 0x7c00]
KERNEL_OFFSET equ 0x1000

	mov [BOOT_DRIVE], dl	
	
	mov bp, 0x9000
	mov sp, bp
	
	mov bx, MSG_REAL_MODE
	call print_str
	call load_kernel
	call pm_switch	; We never return from this call

	jmp $

%include "rem/print_string.asm"
%include "rem/disk_load.asm"
%include "prm/gdt.asm"
%include "prm/print_string_pm.asm"
%include "prm/pm_switch.asm"

[bits 16]

load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print_str
	
	mov bx, KERNEL_OFFSET
	mov dh, 15
	mov dl, [BOOT_DRIVE]
	call disk_load

	ret

[bits 32]

pm_start:
	mov ebx, MSG_PROT_MODE
	call print_str_pm
	
	call KERNEL_OFFSET

	jmp $

BOOT_DRIVE 	db 0
MSG_REAL_MODE 	db "Started in 16-bit Real Mode.", 0
MSG_PROT_MODE 	db "Successfully switched to 32-bit Protected Mode.", 0
MSG_LOAD_KERNEL	db "Loading kernel in memory.", 0

times 510-($-$$) db 0
dw 0xaa55
