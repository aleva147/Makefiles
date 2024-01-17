#added a github comment

all : program.hex program.elf 

program.hex : program.elf
	arm-none-eabi-objcopy.exe --output-target ihex program.elf program.hex

program.elf : startup_code.o main.o systick.o
	arm-none-eabi-ld.exe -T linker_script.ld -o program.elf startup_code.o main.o systick.o

startup_code.o : startup_code.s
	arm-none-eabi-gcc.exe -c -x assembler -mcpu=cortex-m3 -mthumb -o startup_code.o startup_code.s

main.o : main.c systick.h
	arm-none-eabi-gcc.exe -c -mcpu=cortex-m3 -mthumb -o main.o main.c
	
systick.o : systick.c systick.h
	arm-none-eabi-gcc.exe -c -mcpu=cortex-m3 -mthumb -o systick.o systick.c
