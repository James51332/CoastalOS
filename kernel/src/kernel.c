#include "tty.h"

void kernel_main(void) 
{  
	/* Initialize terminal interface */
	terminal_init();
 
	for (size_t i = 0; i < 30; i++)
	{
		terminal_writestring("Hello, kernel World!\n");
	}
	terminal_writestring("test");
}
