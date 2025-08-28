# Uso dei registri:
# $t0 = valore in input
# $t1 = indirizzo della variabile di input
# $t2 = copia del valore in input (usata per lo count_ones_loop dei bit)
# $t3 = bit estratto con mascheratura
# $t8 = contatore totale degli 1
# $t9 = costante 1 per il confronto
#
# $s0 = copia del numero per il conteggio su posizioni pari/dispari
# $s1 = risultato delle mascherature
# $s2 = contatore degli 1 in posizioni pari
# $s3 = contatore degli 1 in posizioni dispari

.data
input_val:   .word 250     # valore di input su cui contare gli 1
tmp_val:     .word 0       # variabile temporanea (non usata qui ma riservata)

.text
.globl __start

__start:

onesCounter:	
        la $t1, input_val
        lw $t0, 0($t1)
        lw $t2, 0($t1)
        move $s0, $t0
        li $t8, 0          # inizializzo contatore totale
        li $t9, 1
		
count_ones_loop:	
        andi $t3, $t2, 1
        srl $t2, $t2, 1
        beq $t3, $t9, increment_total
        beq $t2, $zero, check_even_positions
        j count_ones_loop

increment_total:	
        addi $t8, $t8, 1
        j count_ones_loop

check_even_positions:	
        beq $s0, $zero, end
        andi $s1, $s0, 0x01
        beq $s1, $zero, check_odd_positions
        addi $s2, $s2, 1          # incremento contatore 1 in posizione pari

check_odd_positions:	
        beq $s0, $zero, end
        srl $s0, $s0, 1
        andi $s1, $s0, 0x01
        srl $s0, $s0, 1
        beq $s1, $zero, check_even_positions
        addi $s3, $s3, 1          # incremento contatore 1 in posizione dispari
        j check_even_positions

end:	
        li $v0, 10
        syscall
