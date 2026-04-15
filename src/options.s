// File: options.s
//
// **********************************************************************
//
// Compares the user provided options against the supported actions, and 
// executes the coresponding action, if supported. 
//
// Copyright (C) 2026  Constantinos Argyriou
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
// Email: constarg@pm.me
// ***********************************************************************
.section .rodata

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

.show_records_opt:
    .string "--show-records"


.section .text

/* Define the relative to %rbp offsets to access
   the various components stored in the stack 
   frame. */
.equ ST_ARGC, -8 
.equ ST_ARGV, -16
.equ ST_SIZE, 16

/* The strcmp function used in the procedure, returns
   zero (0), if the two provided strings are equal. 
   This constant indicates this case. */
.equ CMP_EQUALS, 0

/* Define the relative positions of the user provided
   options inside the ARGV array. */
.equ ARGV_OPTION_1, 8
.equ ARGV_OPTION_2, 16

/* Define the function implementations
   for each of the available options. */
.extern default_dir_action
.extern read_record_action
.extern write_record_action
.extern remove_record_action
.extern show_records_action

/**
 * PURPOSE: This function compares the provided OPTION_1, from the user
 * against the internally supported options, and executes the coresponding
 * actions, if the provided option exists, otherwise an error is returned. 
 *
 * INPUT: The ARGC and ARGV values. The ARGC should be placed on %rdi and
 * and address to the first entry of the ARGV should be placed on %rsi. 
 * 
 * REGISTERS: This function modifies the value of %rax.
 *
 * RETURNS: 0 if the user requiested action completed successfully, otherwise
 * an negative error is returned, indicating the cause of failure.  
 */
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
    movq ARGV_OPTION_1(%rax), %rsi
    call strcmp

.check_if_deafult_dir_opt:
    cmpl $CMP_EQUALS, %eax
    jne .check_if_read_record_opt
    call default_dir_action
    jmp .finished_select_option 

.check_if_read_record_opt:
    movl $.read_record_opt, %edi
    call strcmp
    cmpl $CMP_EQUALS, %eax
    jne .check_if_write_record_opt
    call read_record_action
    jmp .finished_select_option

.check_if_write_record_opt:
    movl $.write_record_opt, %edi 
    call strcmp 
    cmpl $CMP_EQUALS, %eax
    jne .check_if_remove_record_opt
    call write_record_action
    jmp .finished_select_option

.check_if_remove_record_opt:
    movl $.remove_record_opt, %edi
    call strcmp 
    cmpl $CMP_EQUALS, %eax 
    jne .check_if_show_records_opt
    call remove_record_action
    jmp .finished_select_option 

.check_if_show_records_opt: 
    movl $.show_records_opt, %edi
    call strcmp 
    cmpl $CMP_EQUALS, %eax
    jne .help_opt 
    call show_records_action
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
