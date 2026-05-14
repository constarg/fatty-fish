#include <fcntl.h>

.section .rodata

/* CONFIG_FILE_PATH Indicate the path to the
   config file used by the FATTY-FISH process. */
.CONFIG_FILE_PATH:
    .string "./fatty_fish.conf"

/* O_RDONLY Indicates the FLAG value passed on the open
   system call in order to open the file in read only 
   mode. */
.O_RDONLY: .long 0x0

.section .bss

.section .text

.type read_config, @function 
read_config:
    pushq %rbp
    movq %rsp, %rbp
    
    # Open the config file. 
    movl $.CONFIG_FILE_PATH, %edi    
    movl $.O_RDONLY, %esi 
    call open
  
    /* The file descriptor must be 
       in the %eax register. */ 

    /* Start reading chunks out of the
       config file */

    leave
    ret

.type write_config, @function 
write_config:


.type set_conf_default_dir, @function
set_conf_default_dir:


.type get_conf_default_dir, @function 
get_conf_default_dir: 

