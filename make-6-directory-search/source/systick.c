#include <stdint.h>

#include "systick.h"

void systick_init()
{
	/*
	 * Izvor informacija:
	 * 01_STM32F103_Cortex_M3_Programming_Manual -> 4.5 SysTick timer (STK) (pg. 150)
	 *
	 */
	STK_LOAD = 8000000 - 1;
	STK_VAL = 0;
	STK_CTRL |= STK_CTRL_TICKINT | STK_CTRL_ENABLE;
}

/*
 * GNU GCC (6.33 Declaring Attributes of Functions)
 * https://gcc.gnu.org/onlinedocs/gcc/Function-Attributes.html
 *
 */
void __attribute__((weak)) systick_callback()
{
	// Empty
}

/*
 * Funkcija systick_handler predstavlja rukovalac izuzetkom i adresa ove funkcije bice smestena
 * u vektor tabelu. Iako se radi o rukovaocu izuzetkom izvorni kod ove funkcije se ne razlikuje
 * od standardnih funkcija i ne treba je dodatno opisivati navodjenjem bilo kakvih kljucnih reci.
 * Izostanak kljucnih reci moguc je zbog arhitekture mikroprocesora. Cortex-M3 mikroprocesor 
 * hardverski vrsi stacking (R0, R1, R2, R3, R12, ret_addr, PSR i LR) kao i unstacking.
 * Takodje, ne postoji posebna masinska instrukcija mikroprocesora za povratak iz rukovaoca izuzetkom.
 * Povratak iz rukovaoca izuzetkom vrsi se upisom vrednosti EXC_RETURN, koju mikroprocesor upisuje
 * u LR registar prilikom poziva rukovaoca izuzetkom, u PC registar. Drugim recima, povratak se vrsi
 * upisom vrednost LR u PC registar sto odgovara koracima za povratak iz standardne funkcije.
 *
 *      080001f8 <systick_handler>:
 *      80001f8:	b580      	push	{r7, lr}
 *      80001fa:	af00      	add	r7, sp, #0
 *      80001fc:	f7ff ffa8 	bl	8000150 <systick_callback>
 *      8000200:	bf00      	nop
 *      8000202:	bd80      	pop	{r7, pc}
 *
 */
void systick_handler()
{
	systick_callback();
}
