#ifndef TTY_H
#define TTY_H 1

#include <stdint.h>
#include <stddef.h>

// ---- TTY Interface -----

void terminal_init(void);

void terminal_clear(void);
void terminal_scroll(size_t);

void terminal_setcolor(uint8_t);

void terminal_putentryat(char c, uint8_t color, size_t x, size_t y);
void terminal_putchar(char c);

void terminal_write(const char* c, size_t size);
void terminal_writestring(const char* str);

void terminal_newline(void);

#endif