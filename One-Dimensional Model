.data
    n: .space 4
    x: .space 4
    N: .space 4
    d: .space 4 
    l: .space 4 
    start: .space 4
    dummy1: .space 4
    dummy2: .space 4
    dummy3: .space 4
    dummy4: .space 4
    dummy5: .space 4
    mem: .space 4 
    valadd: .long 8 
    m: .long 1024
    v: .space 4096
    formatscanf: .asciz "%d"
    formatprintf: .asciz "%d\n"
    formatprintfadd: .asciz "%d: (%d, %d)\n"
    formatprintfget: .asciz "(%d, %d)\n"

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

implementare_add_individual: # Aici se repeta pentru fiecare fisier adaugat - citire descriptor, dimensiune, adaugare

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

    # Am obtinut mem = ceil (mem/8)
    
    mov %eax, dummy1
    mov %ebx, dummy2
    mov %ecx, dummy3

    # %eax va fi mem
    # %ebx va fi l 
    # %edx va fi start
    # %ecx va fi contorul forului 
    # %edi va fi v[i]

    mov mem, %eax
    xor %ebx, %ebx
    mov $-1, %edx 

    mov $0, %ecx
    mov $v, %esi 

et_loop_add:
    cmp m, %ecx 
    je end_for
    movl (%esi, %ecx, 4), %edi 
    cmp $0, %edi 
    je viezero
    xor %ebx, %ebx
    inc %ecx
    jmp et_loop_add

viezero:
    inc %ebx 
    cmp %ebx, %eax 
    je initializare_start
    inc %ecx
    jmp et_loop_add


initializare_start:
    xor %edx, %edx
    add %ecx, %edx 
    sub %eax, %edx 
    inc %edx 
    jmp end_for

end_for: 
    cmp $-1, %edx 
    je initializare_cu_zero
    add %edx, %eax # k = start + mem
    dec %eax # k = start + mem - 1 
    cmp $1024, %eax 
    jge initializare_cu_zero 

adaugare_in_vector: 
    mov %edx, %ecx # i = start 

adaugare_in_vector_loop:
    cmp %eax, %ecx 
    jg afisare 
    mov %eax, dummy4 
    mov d, %eax 
    movl %eax, (%esi, %ecx, 4)
    mov dummy4, %eax 
    inc %ecx 
    jmp adaugare_in_vector_loop 

initializare_cu_zero: 
    mov $0, %edx 
    mov $0, %eax 
    jmp afisare 

afisare: 
    push %eax 
    push %edx 
    push d 
    push $formatprintfadd 
    call printf 
    add $16, %esp

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

    # %eax va fi a 
    # %ebx va fi b 
    # %ecx va fi contorul for-ului 
    # %edx va fi found

    mov $-1, %eax # a = -1
    mov $-1, %ebx  # b = -1
    mov $0, %edx # found = 0
    mov $0, %ecx 
    mov $v, %esi

et_loop_get:
    cmp m, %ecx 
    je end_for_get

    movl (%esi, %ecx, 4), %edi 
    cmp d, %edi 
    je et_found
    cmp $1, %edx 
    je end_for_get 
    inc %ecx 
    jmp et_loop_get


et_found:
    cmp $0, %edx 
    je et_found_equal
    mov %ecx, %ebx 
    inc %ecx 
    jmp et_loop_get

et_found_equal:
    mov %ecx, %eax 
    mov $1, %edx 
    mov %ecx, %ebx 
    inc %ecx 
    jmp et_loop_get

end_for_get:
    cmp $0, %edx 
    je afisare_zero
    push %ebx 
    push %eax 
    push $formatprintfget
    call printf
    add $12, %esp
    mov dummy1, %eax 
    mov dummy2, %ecx 
    inc %ecx 
    jmp et_loop

afisare_zero:
    push $0
    push $0
    push $formatprintfget
    call printf 
    add $12, %esp 
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
    mov $0, %ecx # i = 0
    mov $v, %esi 

et_loop_delete:
    cmp m, %ecx 
    je end_for_delete

    movl (%esi, %ecx, 4), %edi 
    cmp d, %edi 
    je vied 

    cmp $1, %edx 
    je end_for_delete
    inc %ecx 
    jmp et_loop_delete

vied:
    movl $0, (%esi, %ecx, 4)
    mov $1, %edx 
    inc %ecx 
    jmp et_loop_delete 

end_for_delete: 
    mov dummy1, %eax 
    mov dummy2, %ecx 
    jmp afisare_memorie_actualizata



afisare_memorie_actualizata:
    mov %eax, dummy1
    mov %ecx, dummy2 

    mov $0, %ecx 
    mov $v, %esi

et_loop_memorie_actualizata:
    cmp m, %ecx 
    je end_afisare_memorie_actualizata
     
    movl (%esi, %ecx, 4), %edi 
    cmp $0, %edi 
    jne vinuezero
    inc %ecx 
    jmp et_loop_memorie_actualizata
    

vinuezero:
    mov %ecx, %ebx # endf = i
    mov %ecx, %eax # start = i 

et_loop_interior_memorie_actualizata: 
    cmp m, %eax 
    je afisare_propriu_zisa

    movl (%esi, %eax, 4), %edx 
    cmp %edi, %edx  
    je initializare_endf 
    jmp afisare_propriu_zisa

initializare_endf: 
    mov %eax, %ebx 
    inc %eax  
    jmp et_loop_interior_memorie_actualizata

afisare_propriu_zisa:
    mov %eax, dummy3 
    mov %ebx, dummy4
    mov %ecx, dummy5


    # Strict pentru a evita afisarea acelor linii in plus 
    cmp $1024, %ecx 
    je end_afisare_memorie_actualizata


    push %ebx 
    push %ecx 
    push %edi 
    push $formatprintfadd
    call printf 
    add $12, %esp 
    mov dummy3, %eax 
    mov dummy4, %ebx 
    mov dummy5, %ecx 
    mov %ebx, %ecx 
    inc %ecx 
    jmp et_loop_memorie_actualizata


end_afisare_memorie_actualizata:
    mov dummy1, %eax 
    mov dummy2, %ecx 
    inc %ecx 
    jmp et_loop


implementare_defragmentation:
    mov %eax, dummy1
    mov %ecx, dummy2
    mov $0, %ebx 
    mov $0, %ecx 
    mov $v, %esi

et_loop_defrag:
    cmp $1024, %ecx 
    je viprimestezero

    movl (%esi, %ecx, 4), %edi 
    cmp $0, %edi 
    jne vpevi
    inc %ecx 
    jmp et_loop_defrag

vpevi:
    movl %edi, (%esi, %ebx, 4)
    inc %ebx 
    inc %ecx 
    jmp et_loop_defrag

viprimestezero:
    mov %ebx, %ecx 

viprimestezero2:
    cmp $1024, %ecx 
    je end_defrag
    movl $0, (%esi, %ecx, 4)
    inc %ecx 
    jmp viprimestezero2

end_defrag:
    mov dummy1, %eax 
    mov dummy2, %ecx 
    jmp afisare_memorie_actualizata

et_exit:    
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80
