OUTPUT_FORMAT("coff-go32")
ENTRY(start)
SEARCH_DIR("d:/djgpp/lib/gcc/djgpp/9"); SEARCH_DIR("d:/djgpp/lib")
SECTIONS
{
  .text 0x0 : {
    *(.text)
    *(.gnu.linkonce.t*)
    *(.gnu.linkonce.r*)
    etext  =  . ; PROVIDE( _etext = .) ;
    . = ALIGN(0x200);
   } 
  .data 0x0 : {
    djgpp_first_ctor = . ;
    *(.ctor)
    djgpp_last_ctor = . ;
    djgpp_first_dtor = . ;
    *(.dtor)
    djgpp_last_dtor = . ;
    __environ = . ;
    PROVIDE(_environ = .) ;
    LONG(0) ;
    *(.data)
    *(.data.*)
    *(.gnu.linkonce.d*)
    *(.gcc_exc*)
    ___EH_FRAME_BEGIN__ = . ;
    *(.eh_fram*)
    ___EH_FRAME_END__ = . ;
    LONG(0)
     edata  =  . ; PROVIDE(_edata = .) ;
    . = ALIGN(0x200);
    } 
  .bss SIZEOF(.data) + ADDR(.data) : {
    _object.2 = . ;
    . += 24 ;
    *(.bss)
    *(.bss.*)
    *(.gnu.linkonce.b*)
    *(COMMON)
    end = . ; PROVIDE(_end = .) ;
    . = ALIGN(0x200);
  }
  .comment 0x0:
  {
  }
}
