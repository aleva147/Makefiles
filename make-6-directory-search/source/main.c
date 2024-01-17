#include <stdint.h>

#include "systick.h"

uint8_t const rodata[] = "VMA:FLASH, LMA:FLASH";
uint8_t data[] = "VMA:RAM, LMA:FLASH";

uint32_t bss; // "VMA:RAM, LMA:(not loaded)"

void systick_callback()
{
	bss++;
}

uint32_t main()
{
	bss = 0;
	
	systick_init();
	
	while (1)
	{
		/*
		 * Beskonacna petlja kojom se sprecava povratak u reset_handler
		 * pri cemu se reaguje na zahteve za obradu izuzetka.
		 *
		 */
	}
	
	return 0;
}
