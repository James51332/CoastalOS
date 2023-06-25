#include "tty.h"

void kernel_main(void) 
{  
	/* Initialize terminal interface */
	terminal_init();
 
	/* Newline support is left as an exercise. */
	terminal_writestring("Hello, kernel World!\n");
}
