__asm__("cli\n");
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <rak_print_string.h>

void boot_main(void){

  char string[] = "Entered the first stage of bootloader!";
  print_string(string);


for(;;);

}
