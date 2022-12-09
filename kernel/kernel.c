#include "../drivers/screen.h"

void main(void) {
	clear_screen();
	kprint("HELLO BABEEEEEEEEEES This is my cool operating system!!\n");
	kprint("Look its super cool I can now print text anywhere.\n");
	kprint("Check where the secret message is.");
	kprint_at("sex hehe", 70, 24);
}
