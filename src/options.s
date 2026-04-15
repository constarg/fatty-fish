
.data

.help_msg:
    .ascii "Usage: fatty-fish [OPTION_1]... [OPTION_2]\n"
    .ascii "\t --default-dir path \t\t Sets the directory in which the notes should be stored.\n"
    .ascii "\t --read-record index \t\t Reads the note record [index] from the notes.\n"
    .ascii "\t --write-record note \t\t Stores a new record [note] into the notes.\n"
    .ascii "\t --remove-record index \t\t Removes the [index] record.\n"
    .ascii "\t --show-records \t\t Shows the saved records with their coresponding indexes.\n"
    .byte 0x00

.default_dir_opt:
    .string "--default-dir"

.read_record_opt:
    .string "--read-record"

.write_record_opt:
    .string "--write-record"

.remove_record_opt:
    .string "--remove-record"

.show_record_opt:
    .string "--show-records"

.text

.equ ST_ARGC, -8
.equ ST_ARGV, -16
.equ ST_SIZE, 16

.equ CMP_EQUALS, 0

.globl select_option
.type select_option, @function
select_option:
    pushq %rbp
    movq %rsp, %rbp
    subq $ST_SIZE, %rsp

    # Save the ARGC and ARGV into the current stack frame. 
    movq %rdi, ST_ARGC(%rbp) 
    movq %rsi, ST_ARGV(%rbp)

    # Check which of the available options is requested.
    movq $.default_dir_opt, %rdi 
    movq ST_ARGV(%rbp), %rax
    movq 8(%rax), %rsi
    call strcmp

.check_if_deafult_dir_opt:
    cmpl $CMP_EQUALS, %eax
    jne .check_if_read_record_opt
    # TODO: Call the corespoding function here.  
    jmp .finished_select_option 

.check_if_read_record_opt:
    movl $.read_record_opt, %edi
    call strcmp
    cmpl $CMP_EQUALS, %eax
    jne .check_if_write_record_opt
    # TODO: Call the coresponding function here.
    jmp .finished_select_option

.check_if_write_record_opt:
    movl $.write_record_opt, %edi 
    call strcmp 
    cmpl $CMP_EQUALS, %eax
    jne .check_if_remove_record_opt
    # TODO: Call the corespoding function here. 
    jmp .finished_select_option

.check_if_remove_record_opt:
    movl $.remove_record_opt, %edi
    call strcmp 
    cmpl $CMP_EQUALS, %eax 
    jne .check_if_show_records_opt 
    # TODO: Call the coresponding function here. 
    jmp .finished_select_option 

.check_if_show_records_opt: 
    movl $.show_record_opt, %edi
    call strcmp 
    cmpl $CMP_EQUALS, %eax
    jne .help_opt 
    # TODO: Call the coresponding function here.
    jmp .finished_select_option

.help_opt:
    movl $.help_msg, %edi
    movl $0x00, %esi
    call printf

.finished_select_option: 
    movq ST_ARGC(%rbp), %rdi
    movq ST_ARGV(%rbp), %rsi
    addq $ST_SIZE, %rsp

    leave
    ret
