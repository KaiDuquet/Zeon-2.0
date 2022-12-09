; Global Descriptor Table
gdt_start:

gdt_null:		; Mandatory NULL descriptor
	dd 0x0		; define first 8 bytes as zero
	dd 0x0

gdt_code:		; Code segment descriptor
	dw 0xffff
	dw 0x0
	db 0x0
	db 10011010b
	db 11001111b
	db 0x0

gdt_data:		; Data segment descriptor
	dw 0xffff
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0

gdt_end:	; Label just for size calculation


; GDT Descriptor
gdt_descriptor:
	dw gdt_end - gdt_start - 1	; Size of GDT
	dd gdt_start			; Start address of GDT

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
