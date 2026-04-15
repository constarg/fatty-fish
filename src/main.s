// File: main.s
//
// **********************************************************************
//
// The entry of the program.  
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

.NO_ARGUMENT_ERR_MSG:
    .string "Not anough arguments provided, argc = %d, required (3).\n"

.section .text

.extern select_option

.globl main
.type  main, @function
main:
    pushq %rbp
    movq %rsp, %rbp

    cmpl $3, %edi # Check if the argc == 1.
    jne .no_arguments_err

    call select_option

    leave
    ret

.no_arguments_err:
    # Configure the error message, when the user don't provide
    # the appropriate number of command line arguments.
    movl %edi, %esi
    movl $.NO_ARGUMENT_ERR_MSG, %edi
    call printf

    movl $0, %edi
    call exit
