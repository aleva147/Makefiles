PROGRAM = program

SOURCE_S_LIST = \
startup_code.s

SOURCE_C_LIST = \
main.c \
systick.c

OBJECTS_LIST = 
# GNU MAKE (6.3.1 Substitution References)
# https://www.gnu.org/software/make/manual/html_node/Substitution-Refs.html
OBJECTS_LIST += $(SOURCE_S_LIST:.s=.o)
OBJECTS_LIST += $(SOURCE_C_LIST:.c=.o)

CC = arm-none-eabi-gcc.exe -c
AS = arm-none-eabi-gcc.exe -c -x assembler
LD = arm-none-eabi-ld.exe
HX = arm-none-eabi-objcopy.exe --output-target ihex

MCU = -mcpu=cortex-m3 -mthumb

FLAGS_AS =
FLAGS_AS += $(MCU)

FLAGS_CC =
FLAGS_CC += $(MCU)
FLAGS_CC += -mlong-calls
FLAGS_CC += -MMD -MP

LINKER_SCRIPT = linker_script.ld

all : $(PROGRAM).elf $(PROGRAM).hex

$(PROGRAM).hex : $(PROGRAM).elf
	$(HX) $(<) $(@)

######
$(PROGRAM).elf : $(OBJECTS_LIST) makefile
	$(LD) -T $(LINKER_SCRIPT) -o $(@) $(OBJECTS_LIST)

######
%.o : %.s makefile
	$(AS) $(FLAGS_AS) -o $(@) $(<)

######
%.o : %.c makefile
	$(CC) $(FLAGS_CC) -o $(@) $(<)

-include $(wildcard ./*.d)
