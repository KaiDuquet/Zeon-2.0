/**
 * Read a byte from the specified port
 */
unsigned char port_byte_in(unsigned short port) {
	unsigned char data;
	__asm__("in %%dx, %%al" : "=a" (data) : "d" (port));
	return data;
}

/**
 * Read a word from the specified port
 */
unsigned short port_word_in(unsigned short port) {
	unsigned short data;
	__asm__("in %%dx, %%ax" : "=a" (data) : "d" (port));
	return data;
}

/**
 * Write a byte at the specified port
 */
void port_byte_out(unsigned short port, unsigned char data) {
	__asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}

/**
 * Write a word at the specified port
 */
void port_word_out(unsigned short port, unsigned short data) {
	__asm__("out %%ax, %%dx" : : "a" (data), "d" (port));
}
