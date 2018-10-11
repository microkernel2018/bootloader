#include<stdint.h>

/**********************************************************

A simple paging with one Page Directory, first page table
and with Identitiy mapping

***********************************************************/

extern void enable_paging(void* PD_address);

uint32_t* PDT = (uint32_t*) 0x0009d000; //PDT
uint32_t* PT = (uint32_t*) 0x0009e000; //PT

void boot_main(void){
  for(int i = 0; i < 1024; i++)
  {
      PDT[i] = 0x00000002; //Not present
      PT[i] = (i * 4096) | 3; //Identitiy mapping
  }
  PT[6] = 0x9000 | 3;  //0x6000 virt addr is mapped to 0x9000 physical addr
  PDT[0] = (((uint32_t)PT) | 3); //PDE points to PT
  enable_paging((void*)PDT); //set PD to CR3 and enable paging

  for(;;);
}
