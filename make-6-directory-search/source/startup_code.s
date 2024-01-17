.cpu cortex-m3
.fpu softvfp
.syntax unified
.thumb

.extern _main_stack_pointer_value

# vrednost simbola systick_handler predstavlja adresu na kojoj se nalazi
# masinski kod rukovaoca izuzetkom Systick (Exception number: 15, IRQ number: -1)
#
# simbol systick_handler bi trebalo da definise programer prilikom pisanja
# programskog koda (bilo na asembleru bilo na visem programskom jeziku) rukovaoca izuzetkom
#
# kako bismo izbegli gresku prilikom povezivanja ukoliko programer ne definise simbol systick_handler
# simbolu systick_handler dodelicemo vrednost simbola default_handler pomocu asemblerske direktive
#    .thumb_set systick_handler, default_handler
# GNU AS (7.83 .set symbol, expression)
# https://sourceware.org/binutils/docs/as/Set.html
# GNU AS (9.4.4 ARM Machine Directives)
# https://sourceware.org/binutils/docs/as/ARM-Directives.html
#
# posto smo na ovaj nacin zapravo definisali simbol systick_handler
# kako bismo izbegli visestruku definiciju simbola kada programer napise rukovalac izuzetkom
# simbol systick_handler moramo proglasiti slabim simbolom pomocu asemblerske direktive
#    .weak systick_handler
# GNU AS (7.105 .weak names)
# https://sourceware.org/binutils/docs/as/Weak.html
.weak systick_handler
.thumb_set systick_handler, default_handler
# umesto prethodne dve asemblerske direktive moguce je i samo jednostavno uvesti simbol systick_handler 
# pomocu asemblerske direktive za uvoz eksternih simbola
#    .extern systick_handler
#
# u ovom slucaju linker bi mogao da prijavi gresku prilikom povezivanja
# ukoliko programer nije napisao odgovarajuci rukovalac izuzetkom 

.section .vector_table, "a"
.word _main_stack_pointer_value
.word reset_handler
.rept 13
	.word default_handler
.endr
# vektor za izuzetak Systick je 15. ulaz u okviru vektor tabele
# pri cemu su ulazi u okviru vektor tabele numerisani pocev od jedinice i
# prvi ulaz jeste vektor za izuzetak Reset koji se nalazi na adresi 0x00000004
#
# izvor informacija:
# 01_STM32F103_Cortex_M3_Programming_Manual -> 2.3.4 Vector table -> Figure 12. Vector table (pg. 35)
# 03_STM32F103_Reference_Manual -> 10.1.2 Interrupt and exception vectors -> Table 63. Vector table for other STM32F10xxx devices (pg. 204)
.word systick_handler
.rept 68
	.word default_handler
.endr

.extern main
# uvoz simbola definisanih u okviru linkerske skripte
.extern _lma_data_start
.extern _vma_data_start
.extern _vma_data_end

.section .text.reset_handler
.type reset_handler, %function
reset_handler:
	ldr r0, =_lma_data_start
	ldr r1, =_vma_data_start
	ldr r2, =_vma_data_end
	# provera da li postoje podaci sa inicijalnim vrednostima
	cmp r1, r2
	beq branch_to_main
	# kopiranje, rec po rec, inicijalnog sadrzaja .data sekcije
	# sa njene LMA adrese (adresa na koju je sadrzaj sekcije fizicki smesten)
	# na njenu VMA adresu (adresa na koju je sadrzaj sekcije logicki mapiran)
copy_loop:
	ldr r3, [r0], #4
	str r3, [r1], #4
	cmp r1, r2
	blo copy_loop
	# odmah je moguce preneti kontrolu toka na glavni program u okviru main funkcije zato sto:
	#
	# 1) sekcija .rodata je sekcija za nepromenljive podatka cije se vrednosti ne menjaju usled cega
	# ne postoji potreba da se vrsi kopiranje (mogu ostati u FLASH memoriji)
	#
	# 2) sekcija .bss je sekcija za podatke bez incijalnih vrednost usled cega
	# ne postoji potreba da se vrsi kopiranje (ne postoji inicijalni sadrzaj)
branch_to_main:
	b main
infinite_loop_1:
	b infinite_loop_1

.section .text.default_handler
.type default_handler, %function
default_handler:
infinite_loop_2:
	b infinite_loop_2
	
	.end
