#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

static void print_string(char* string){
  volatile unsigned char* vid_mem = (unsigned char*) 0xb8000;
  int j=0;
  while(string[j]!='\0'){

    *vid_mem++ = (unsigned char) string[j++];
    *vid_mem++ = 0x09;
  }
}


void boot_main(void){

  char string[] = "Now Entered The Second Stage Program!";
  print_string(string);


for(;;);

}
