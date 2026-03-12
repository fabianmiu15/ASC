.data
    n: .space 4
    x: .space 4
    N: .space 4
    d: .space 4
    matrix: .space 4194304
    i: .space 4
    j: .space 4
    op: .long 1024
    mem: .space 4
    dummy1: .space 4
    dummy2: .space 4
    dummy3: .space 4
    dummy4: .space 4
    dummy5: .space 4
    dummy6: .space 4
    dummy7: .space 4
    found: .space 4
    valadd: .long 8
    aux: .space 4
    formatscanf: .asciz "%d"
    formatprintfadd: .asciz "%d: ((%d, %d), (%d, %d))\n"
    formatprintfget: .asciz "((%d, %d), (%d, %d))\n"

.text 
.global main
main:
    # Citim valoarea lui n = numarul de operatii care se vor efectua
    push $n 
    push $formatscanf 
    call scanf 
    add $8, %esp 

    # Parcurgem, pe rand, fiecare operatie 
    mov $0, %ecx 

et_loop: 
    cmp n, %ecx 
    je et_exit 
    # Citim in x ID-ul operatiei care se va efectua 
    push %ecx 
    push $x 
    push $formatscanf 
    call scanf 
    add $8, %esp 
    pop %ecx 

    # Ne ducem catre operatia indicata de x 
    movl x, %eax # %eax = ID-ul operatiei 

    cmp $1, %eax 
    je implementare_add

    cmp $2, %eax 
    je implementare_get 

    cmp $3, %eax 
    je implementare_delete 

    cmp $4, %eax 
    je implementare_defragmentation 

    inc %ecx 
    jmp et_loop 

implementare_add:
    # Citim N = numarul de fisiere care se vor adauga cu ADD
    push %eax 
    push %ecx 
    push $N 
    push $formatscanf 
    call scanf 
    add $8, %esp 
    pop %ecx 
    pop %eax 

    # Parcurgem perechile (descriptor, dimensiune) pentru fiecare fisier 
    mov $0, %ebx 
    cmp N, %ebx 
    je exit_add 

implementare_add_individual:
    # Citim d = descriptorul
    push %eax 
    push %ecx 
    push $d 
    push $formatscanf 
    call scanf 
    add $8, %esp 
    pop %ecx 
    pop %eax 

    # Citim mem = dimensiunea in kB
    push %eax 
    push %ecx 
    push $mem 
    push $formatscanf 
    call scanf 
    add $8, %esp 
    pop %ecx 
    pop %eax 

    # In acest punct incepe efectiv implementarea operatiei ADD 

    mov %eax, dummy1 
    mov mem, %eax 
    # Adaugam 7 si impartim la 8 pentru a obtine numarul de blocuri pe care va fi stocat fisierul
    add $7, %eax 
    xor %edx, %edx 
    divl valadd 
    mov %eax, mem
    mov dummy1, %eax 

    # Am obtinut mem = ceil(mem/8)

    mov %eax, dummy1 
    mov %ebx, dummy2 
    mov %ecx, dummy3 

    # %eax va fi startX 
    # %ebx va fi startY
    # %ecx va fi contor 
    # %edx va fi l 
    # found, mem -> dummy-uri 
    # %esi, %edi -> matrice 
    # %edx va fi endY la final

    mov $-1, %eax 
    mov $-1, %ebx 
    movl $0, found 
    

    lea matrix, %esi  
    movl $0, i 

for_lines_add_1:
    movl i, %ecx 
    cmp $1024, %ecx  
    je exit_for_lines_add_1
    xor %edx, %edx # l = 0 
    movl $0, j 

for_columns_add_1:
    movl j, %ecx 
    cmp $1024, %ecx 
    je cont_for_lines_add_1
    mov %eax, dummy4 
    mov %edx, dummy5
    movl i, %eax 
    mull op
    addl j, %eax 
    movl (%esi, %eax, 4), %edi 
    mov dummy4, %eax 
    mov dummy5, %edx 
    cmp $0, %edi 
    je initializare_startX_startY
    movl $0, %edx 
    addl $1, j 
    jmp for_columns_add_1

initializare_startX_startY:
    inc %edx 
    cmp mem, %edx 
    je initializare_finala_startX_startY
    addl $1, j 
    jmp for_columns_add_1

initializare_finala_startX_startY:
    mov i, %eax 
    mov j, %ebx 
    sub mem, %ebx 
    inc %ebx 
    movl $1, found 
    jmp cont_for_lines_add_1

cont_for_lines_add_1:
    mov %eax, dummy4 
    mov found, %eax 
    cmp $1, %eax 
    je exit_for_lines_add_1
    mov dummy4, %eax 
    addl $1, i 
    jmp for_lines_add_1

exit_for_lines_add_1:
    mov dummy4, %eax 
    
    mov %eax, dummy4 
    mov found, %eax 
    cmp $0, %eax 
    je initializare_startX_startY_cu_zero
    mov dummy4, %eax 
    mov %ebx, %edx 
    add mem, %edx 
    dec %edx 
    cmp $1024, %edx 
    jge initializare_startX_startY_cu_zero 
    mov %ebx, j 

adaugare_in_matrice_loop:
    cmp j, %edx 
    jl afisare_add
    mov %edx, dummy5 
    mov %eax, dummy6
    mull op
    addl j, %eax 
    mov d, %edi
    movl %edi, (%esi, %eax, 4)
    mov dummy5, %edx
    mov dummy6, %eax 
    addl $1, j 
    jmp adaugare_in_matrice_loop

initializare_startX_startY_cu_zero:
    mov $0, %eax 
    mov $0, %ebx 
    mov $0, %edx 
    jmp afisare_add

afisare_add:
    push %edx 
    push %eax 
    push %ebx 
    push %eax 
    push d 
    push $formatprintfadd 
    call printf 
    add $24, %esp 

exit_add_individual:
    mov dummy1, %eax 
    mov dummy2, %ebx 
    mov dummy3, %ecx 
    inc %ebx 
    cmp N, %ebx 
    je exit_add 
    jmp implementare_add_individual

exit_add:
    inc %ecx 
    jmp et_loop


implementare_get:
    mov %eax, dummy1
    mov %ecx, dummy2 

    # Citim d = descriptorul 
    push $d 
    push $formatscanf 
    call scanf 
    add $8, %esp 

    # startX = %eax 
    # startY = %ebx 
    # i, j = %ecx 
    # endY = %edx 
    # found -> dummy-uri 

    mov $-1, %eax 
    mov $-1, %ebx 
    mov $-1, %edx 
    movl $0, found

    lea matrix, %esi 
    movl $0, i 

for_lines_get:
    movl i, %ecx 
    cmp $1024, %ecx 
    je exit_for_lines_get
    movl $0, j 

for_columns_get:
    movl j, %ecx 
    cmp $1024, %ecx 
    je exit_for_columns_get
    mov %eax, dummy5 
    mov %edx, dummy6 
    movl i, %eax 
    mull op 
    addl j, %eax 
    movl (%esi, %eax, 4), %edi 
    mov dummy5, %eax 
    mov dummy6, %edx 
    cmp d, %edi 
    je initializare_startX_startY_get
    addl $1, j 
    jmp for_columns_get 

initializare_startX_startY_get:
    mov found, %ecx 
    cmp $0, %ecx 
    je initializare_finala_startX_startY_get
    mov j, %edx 
    addl $1, j 
    jmp for_columns_get

initializare_finala_startX_startY_get: 
    mov i, %eax 
    mov j, %ebx 
    movl $1, found 
    mov j, %edx 
    addl $1, j 
    jmp for_columns_get

exit_for_columns_get:
    mov found, %ecx 
    cmp $1, %ecx 
    je exit_for_lines_get 
    addl $1, i 
    jmp for_lines_get 

exit_for_lines_get:
    mov found, %ecx 
    cmp $1, %ecx 
    je afisare_get
    mov $0, %eax 
    mov $0, %ebx 
    mov $0, %edx 
    jmp afisare_get 

afisare_get:
    push %edx 
    push %eax 
    push %ebx 
    push %eax 
    push $formatprintfget 
    call printf 
    add $20, %esp 
    mov dummy1, %eax 
    mov dummy2, %ecx 
    inc %ecx 
    jmp et_loop



implementare_delete:
    mov %eax, dummy1 
    mov %ecx, dummy2 

    # Citim d = descriptorul 
    push $d 
    push $formatscanf 
    call scanf 
    add $8, %esp 

    mov $0, %edx # found = 0
    lea matrix, %esi 
    movl $0, i 

for_lines_delete_1:
    movl i, %ecx 
    cmp $1024, %ecx 
    je afisare_memorie_actualizata
    movl $0, j 

for_columns_delete_1:
    movl j, %ecx 
    cmp $1024, %ecx 
    je cont_for_lines_delete_1
    mov %edx, dummy5 
    movl i, %eax 
    mull op 
    addl j, %eax 
    movl (%esi, %eax, 4), %edi 
    mov dummy5, %edx 
    cmp d, %edi 
    je aijed 
    cmp $1, %edx 
    je afisare_memorie_actualizata
    addl $1, j 
    jmp for_columns_delete_1


aijed:
    movl $0, (%esi, %eax, 4)
    movl $1, %edx 
    addl $1, j 
    jmp for_columns_delete_1

cont_for_lines_delete_1:
    addl $1, i 
    jmp for_lines_delete_1


afisare_memorie_actualizata:
    movl $0, i 

for_lines_afisare:
    movl i, %ecx 
    cmp $1024, %ecx 
    je exit_afisare
    movl $0, j 

for_columns_afisare:
    movl j, %ecx 
    cmp $1024, %ecx 
    je cont_for_lines_afisare
    movl i, %eax 
    mull op 
    addl j, %eax 
    movl (%esi, %eax, 4), %edi 
    cmp $0, %edi 
    jne inceperea_afisarii 
    addl $1, j 
    jmp for_columns_afisare

inceperea_afisarii: 
    movl i, %eax 
    movl j, %ebx 
    movl j, %edx 
    mov %eax, dummy5 
    mov %edx, dummy6 

while_loop: 
    mov dummy5, %eax 
    # Accesam a[startX][endY+1] in %edi
    # Construim aux = endY+1
    mov %edx, aux 
    addl $1, aux 
    mull op 
    mov dummy6, %edx 
    addl aux, %eax 
    movl (%esi, %eax, 4), %edi 
    
    # Accesam a[startX][startY] in %ecx 
    mov dummy5, %eax
    mull op 
    mov dummy6, %edx 
    add %ebx, %eax 
    movl (%esi, %eax, 4), %ecx 
    mov dummy5, %eax 

    cmp %edi, %ecx 
    jne afisare_propriu_zisa 
    inc %edx 
    addl $1, dummy6
    jmp while_loop 

afisare_propriu_zisa: 
    mov %eax, dummy5 
    mov %edx, dummy6 

    mull op 
    addl %ebx, %eax 
    movl (%esi, %eax, 4), %ecx 

    mov dummy5, %eax 
    mov dummy6, %edx 

    push %edx
    push %edx 
    push %eax 
    push %ebx 
    push %eax 
    push %ecx 
    push $formatprintfadd 
    call printf 
    add $24, %esp 
    pop %edx

    mov %edx, j 
    addl $1, j 
    jmp for_columns_afisare 


cont_for_lines_afisare:
    addl $1, i 
    jmp for_lines_afisare 


exit_afisare:
    mov dummy1, %eax 
    mov dummy2, %ecx 
    inc %ecx 
    jmp et_loop


implementare_defragmentation:

et_exit:
    mov $1, %eax 
    mov $0, %ebx 
    int $0x80
