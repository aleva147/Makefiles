_main_stack_pointer_value = 0x20002800;

MEMORY
{
	FLASH(rx) : ORIGIN = 0x08000000, LENGTH = 32K
	SRAM(rwx) : ORIGIN = 0x20000000, LENGTH = 10K
}

SECTIONS
{
	.vector_table :
	{
		*(.vector_table)
	} > FLASH
	
	.text :
	{
		*(.text)
		*(.text*)
	} > FLASH
	
	.rodata :
	{
		*(.rodata)
		*(.rodata*)
	} > FLASH
	
	.data :
	{
		/*
		 * Definicija simbola _vma_data_start cija vrednost predstavlja
		 * adresu pocev od koje je logicki mapiran sadrzaj sekcije .data
		 * GNU LD (3.1 Basic Linker Script Concepts)
		 * https://sourceware.org/binutils/docs/ld/Basic-Script-Concepts.html
		 *
		 * Vrednost simbola _vma_data_start jeste trenutni Location Counter tj. vrednost promenljive dot
		 * koja predstavlja tekucu lokaciju na koju linker smesta prvi naredni sadrzaj
		 * GNU LD (3.10.5 The Location Counter)
		 * https://sourceware.org/binutils/docs/ld/Location-Counter.html
		 *
		 */
		_vma_data_start = .;
		*(.data)
		*(.data*)
		/*
		 * Definicija simbola _vma_data_end cija vrednost predstavlja
		 * prvu adresu nakon prostora na koji je logicki mapiran sadrzaj sekcije .data
		 *
		 * Vrednost simbola _vma_data_end jeste trenutni Location Counter tj. vrednost promenljive dot
		 * koja predstavlja tekucu lokaciju na koju linker smesta prvi sledeci sadrzaj
		 */
		_vma_data_end = .;
	} > SRAM AT> FLASH
	
	/*
	 * .data sekcija je logicki mapirana (VMA adresa) u SRAM navodjenjem "> SRAM"
	 * .data sekcija je fizicki smestena (LMA adresa) u FLASH navodjenjem "AT > FLASH"
	 */
	
	/*
	 * Definicija simbola _lma_data_start cija vrednost predstavlja
	 * adresu pocev od koje je fizicki smesten sadrzaj sekcije .data
	 *
	 * Vrednost simbola _lma_data_start jeste povratna vrednost ugradjene funkcije linkera LOADADDR()
	 * koja vraca apsolutnu LMA adresu one sekcije cije ime se prosledi kao argument
	 * GNU LD (3.10.9 Builtin Functions)
	 * https://sourceware.org/binutils/docs/ld/Builtin-Functions.html
	 */
	_lma_data_start = LOADADDR(.data);
	
	.bss :
	{
		*(.bss)
		*(.bss*)
		*(COMMON)
	} > SRAM
	
}
