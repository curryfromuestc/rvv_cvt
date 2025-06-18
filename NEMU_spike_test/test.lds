OUTPUT_ARCH( "riscv" )
ENTRY( _start )

SECTIONS
{
  /* NEMU 默认的内存起始地址 */
  . = 0x80000000;
  .text : { *(.text) }
  .rodata : { *(.rodata) }
  .data : { *(.data) }
  .bss : { *(.bss) }
  /* 确保所有段都对齐到4字节边界 */
  . = ALIGN(4);
} 