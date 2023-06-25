#include "tty.h"

void kernel_main(void) 
{  
	/* Initialize terminal interface */
	terminal_init();
 
	terminal_writestring("Hello, kernel World!\n");
}
