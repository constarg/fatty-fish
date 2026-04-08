.data

.NO_ARGUMENT_ERR_MSG:
    .string "No arguments provided, argc = %d.\n"

.text

.globl main
.type  main, @function
main:
    pushq %rbp
    movq %rsp, %rbp

    cmpq $1, %rdi # Check if the argc == 1.
    je no_arguments_err

    // TODO: Call a function to select between the ARGV options to offer.

    leave
    ret

no_arguments_err:
    # Configure the error message, when the user don't provide
    # the appropriate number of command line arguments.
    movl %edi, %esi
    movl $.NO_ARGUMENT_ERR_MSG, %edi
    call printf

    movq $60, %rax 
    movq $0, %rdi
    syscall           
