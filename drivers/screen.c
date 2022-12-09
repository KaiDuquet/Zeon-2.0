#include "screen.h"
#include "ports.h"

void set_cursor_offset(int offset);
int get_cursor_offset(void);

int print_char(char c, int col, int row, char attr);
int get_offset(int col, int row);
int get_offset_row(int offset);
int get_offset_col(int offset);

/**
 * Print text started at the specified location.
 * If col or row is negative, cursor offset is used instead
 */
void kprint_at(char* text, int col, int row) {
	int offset;
	if (col >= 0 && row >= 0) {
		offset = get_offset(col, row);
	}
	else {
		offset = get_cursor_offset();
		row = get_offset_row(offset);
		col = get_offset_col(offset);
	}

	for (int i = 0; text[i] != 0; ++i) {
		offset = print_char(text[i], col, row, WHITE_ON_BLACK);
		row = get_offset_row(offset);
		col = get_offset_col(offset);
	}
}

/**
 * Wrapper call to print at cursor offset
 */
void kprint(char* text) {
	kprint_at(text, -1, -1);
}

/**
 * Directly accesses video memory
 * If row or col is negative, print at cursor location
 * If attr is 0, use WHITE_ON_BLACK as default
 * Sets cursor to the offset and returns it.
 */

int print_char(char c, int col, int row, char attr) {
	unsigned char* vidmem = (unsigned char*) VGA_ADDRESS;
	if (!attr) attr = WHITE_ON_BLACK;

	if (col >= MAX_COLS || row >= MAX_ROWS) {
		vidmem[2 * (MAX_COLS) * (MAX_ROWS) - 2] = 'E';
		vidmem[2 * (MAX_COLS) * (MAX_ROWS) - 1] = RED_ON_WHITE;
		return get_offset(col, row);
	}

	int offset;
	if (col >= 0 && row >= 0) {
		offset = get_offset(col, row);
	}
	else {
		offset = get_cursor_offset();
	}

	if (c == '\n') {
		row = get_offset_row(offset);
		offset = get_offset(0, row + 1);
	}
	else {
		vidmem[offset] = c;
		vidmem[offset + 1] = attr;
		offset += 2;
	}
	set_cursor_offset(offset);
	return offset;
}

/**
 * Use the VGA ports to get current cursor position
 */
int get_cursor_offset() {
	
	port_byte_out(VGA_CTRL_REG, 14); // Request high byte of cursor offset
	int offset = port_byte_in(VGA_DATA_REG) << 8;
	port_byte_out(VGA_CTRL_REG, 15); // Request low byte
	offset += port_byte_in(VGA_DATA_REG);
	return offset * 2;
}

/**
 * Opposite of get_cursor_offset: write data instead
 */
void set_cursor_offset(int offset) {
	offset /= 2;
	port_byte_out(VGA_CTRL_REG, 14);
	port_byte_out(VGA_DATA_REG, (unsigned char)(offset >> 8));
	port_byte_out(VGA_CTRL_REG, 15);
	port_byte_out(VGA_DATA_REG, (unsigned char)(offset & 0xff));
}

/**
 * Sets all bytes in video memory to ' ' and puts the cursor top left
 */
void clear_screen(void) {
	int screen_size = MAX_COLS * MAX_ROWS;

	char *screen = VGA_ADDRESS;

	for (int i = 0; i < screen_size; ++i) {
		screen[2 * i] = ' ';
		screen[2 * i + 1] = WHITE_ON_BLACK;
	}
	set_cursor_offset(get_offset(0, 0));
}

int get_offset(int col, int row) {
	return 2 * (row * MAX_COLS + col);
}

int get_offset_row(int offset) {
	return offset / (2 * MAX_COLS);
}

int get_offset_col(int offset) {
	return (offset - (get_offset_row(offset) * 2 * MAX_COLS)) / 2;
}
