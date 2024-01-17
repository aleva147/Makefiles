PROGRAM = program
BUILD_DIR = build
DEBUG_ENABLED = 1

SOURCE_S_LIST = \
source/startup_code.s

SOURCE_C_LIST = \
source/main.c \
source/systick.c

# GNU GCC (3.16 Options for Directory Search) 
# https://gcc.gnu.org/onlinedocs/gcc/Directory-Options.html
# Tells gcc where to look for .h files
INCLUDE_C_LIST = \
-Iinclude

OBJECTS_LIST = 
OBJECTS_LIST += $(addprefix $(BUILD_DIR)/, $(notdir $(SOURCE_S_LIST:.s=.o)))
OBJECTS_LIST += $(addprefix $(BUILD_DIR)/, $(notdir $(SOURCE_C_LIST:.c=.o)))

# GNU MAKE (4.5.2 The vpath Directive)
# https://www.gnu.org/software/make/manual/html_node/Selective-Search.html
vpath %.s $(sort $(dir $(SOURCE_S_LIST)))
vpath %.c $(sort $(dir $(SOURCE_C_LIST)))

CC = arm-none-eabi-gcc.exe -c
AS = arm-none-eabi-gcc.exe -c -x assembler
LD = arm-none-eabi-ld.exe
HX = arm-none-eabi-objcopy.exe --output-target ihex

MCU = -mcpu=cortex-m3 -mthumb

# GNU GCC (3.10 Options for Debugging Your Program)
# https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html
FLAGS_DEBUG = -g -gdwarf-2 -fdebug-prefix-map==../

FLAGS_AS =
FLAGS_AS += $(MCU)
# GNU MAKE (7.2 Syntax of Conditionals)
# https://www.gnu.org/software/make/manual/html_node/Conditional-Syntax.html
ifeq ($(DEBUG_ENABLED), 1)
FLAGS_AS += $(FLAGS_DEBUG)
endif

FLAGS_CC =
FLAGS_CC += $(MCU)
FLAGS_CC += -mlong-calls
ifeq ($(DEBUG_ENABLED), 1)
FLAGS_CC += $(FLAGS_DEBUG)
endif
# GNU GCC (3.13 Options Controlling the Preprocessor)
# https://gcc.gnu.org/onlinedocs/gcc/Preprocessor-Options.html
FLAGS_CC += -MMD -MP
FLAGS_CC += $(INCLUDE_C_LIST)

LINKER_SCRIPT = linker_script.ld

all : $(BUILD_DIR)/$(PROGRAM).elf $(BUILD_DIR)/$(PROGRAM).hex

$(BUILD_DIR)/$(PROGRAM).hex : $(BUILD_DIR)/$(PROGRAM).elf
	$(HX) $(<) $(@)

$(BUILD_DIR)/$(PROGRAM).elf : $(OBJECTS_LIST) makefile
	$(LD) -T $(LINKER_SCRIPT) -o $(@) $(OBJECTS_LIST)

$(BUILD_DIR)/%.o : %.s makefile | $(BUILD_DIR)
	$(AS) $(FLAGS_AS) -o $(@) $(<)

$(BUILD_DIR)/%.o : %.c makefile | $(BUILD_DIR)
	$(CC) $(FLAGS_CC) -o $(@) $(<)
	
$(BUILD_DIR) :
	mkdir $(@)
	
clean :
	rm -rf $(BUILD_DIR)
	
-include $(wildcard $(BUILD_DIR)/*.d)
