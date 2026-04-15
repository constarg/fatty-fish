.data

.NO_ARGUMENT_ERR_MSG:
    .string "Not anough arguments provided, argc = %d, required (3).\n"

.text

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
