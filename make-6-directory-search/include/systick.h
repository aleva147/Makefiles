#ifndef _SYSTICK_H_
#define _SYSTICK_H_

/*
 * Izvor informacija:
 * 01_STM32F103_Cortex_M3_Programming_Manual -> 4.5 SysTick timer (STK) (pg. 150)
 *
 */

#define STK_CTRL                    (*((uint32_t *) (0xE000E010 + 0x00)))
#define STK_LOAD                    (*((uint32_t *) (0xE000E010 + 0x04)))
#define STK_VAL                     (*((uint32_t *) (0xE000E010 + 0x08)))
#define STK_CALIB                   (*((uint32_t *) (0xE000E010 + 0x0C)))

#define STK_CTRL_ENABLE             0x00000001
#define STK_CTRL_TICKINT            0x00000002
#define STK_CTRL_CLKSOURCE          0x00000004
#define STK_CTRL_COUNTFLAG          0x00010000

extern void systick_init();
extern void systick_handler();

#endif
