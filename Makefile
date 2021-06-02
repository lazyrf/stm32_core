LIB_NAME 		:= libstcore.a
export LIB_NAME

CROSS_COMPILE  	:= arm-none-eabi-
CC 				:= $(CROSS_COMPILE)gcc
LD 				:= $(CROSS_COMPILE)ld
AS 				:= $(CROSS_COMPILE)as
CPP 			:= $(CC) -E
AR  			:= $(CROSS_COMPILE)ar
NM 				:= $(CORSS_COMPILE)nm
STRIP 			:= $(CROSS_COMPILE)strip
OBJCOPY 		:= $(CROSS_COMPILE)objcopy
OBJDUMP 		:= $(CROSS_COMPILE)objdump
SIZE 			:= $(CROSS_COMPILE)size
export CC LD AS CPP AR STRIP OBJCOPY OBJDUMP SIZE

TOPDIR 			:= $(shell pwd)
TOPDIRNAME 		:= $(notdir $(shell pwd))
SDKDIR 			:= $(TOPDIR)/sdk
BUILDIR 		:= $(TOPDIR)/build
export TOPDIR TOPDIRNAME SDKDIR BUILDIR

.PHONY: all clean distclean

-include .config

CORE = -mcpu=$(patsubst "%",%,$(CONFIG_MCU_CORE)) -mthumb -mfloat-abi=soft
DEFINITIONS = $(patsubst "%",%,$(CONFIG_MCU_SERIES)) \
			  USE_HAL_DRIVER

INC := .
INC += $(TOPDIR)
INC += $(SDKDIR)
INC += $(SDKDIR)/CMSIS/Include
ifeq ($(CONFIG_MCU_FAMILY_F1),y)
INC += $(SDKDIR)/CMSIS/Device/ST/STM32F1xx/Include
INC += $(SDKDIR)/STM32F1xx_HAL_Driver/Inc
else ifeq ($(CONFIG_MCU_FAMILY_F4),y)
INC += $(SDKDIR)/CMSIS/Device/ST/STM32F4xx/Include
INC += $(SDKDIR)/STM32F4xx_HAL_Driver/Inc
endif

CFLAGS := $(CORE) \
	$(addprefix -I,$(INC)) \
	$(addprefix -D,$(DEFINITIONS)) \
	-std=$(patsubst "%",%,$(CONFIG_GCC_C_STANDARD)) \
	$(patsubst "%",%,$(CONFIG_GCC_OPTIMIZATION_LEVEL)) \
	$(patsubst "%",%,$(CONFIG_GCC_DEBUG_LEVEL)) \
	$(patsubst "%",%,$(CONFIG_GCC_USE_PRINTF_FLOAT)) \
	$(patsubst "%",%,$(CONFIG_GCC_USE_SCANF_FLOAT)) \
	$(patsubst "%",%,$(CONFIG_GCC_DATA_SECTIONS)) \
	$(patsubst "%",%,$(CONFIG_GCC_FUNCTION_SECTIONS)) \
	$(patsubst "%",%,$(CONFIG_GCC_STACK_USAGE)) \
	$(patsubst "%",%,$(CONFIG_GCC_WARNING_ALL)) \
	$(patsubst "%",%,$(CONFIG_GCC_WARNING_ERROR)) \
	$(patsubst "%",%,$(CONFIG_GCC_WARNING_EXTRA)) \
	$(patsubst "%",%,$(CONFIG_GCC_WARNING_NO_UNUSED_PARAMETER)) \
	$(patsubst "%",%,$(CONFIG_GCC_WARNING_SWITCH_DEFAULT)) \
	$(patsubst "%",%,$(CONFIG_GCC_WARNING_SWITCH_ENUM)) \
	--specs=nano.specs
export CFLAGS

# Use := to avoid recusive issue
obj-y := core.o it.o msp.o
obj-y += sdk/
obj-y += startup/

all: chkconfig start_recursive_build gen_static_lib
	@echo $(LIB_NAME) has been build!

chkconfig:
	@test -f .config || (echo conifg is not found; exit 1)
#	@test -f .config || (echo .conifg is not found; exit 1)$(MAKE) -f scripts/Makefile menuconfig

start_recursive_build:
	make -C ./ -f $(TOPDIR)/Makefile.build

gen_static_lib:
	@$(AR) cruv $(LIB_NAME) $(shell find $(BUILDIR) -name "*.o")

menuconfig:
	@$(MAKE) -f scripts/Makefile $@

clean:
	rm -f *.a
	rm -f $(shell find -name "*.o")
	rm -f $(shell find -name "*.d")

distclean:
	rm -f *.a
	rm -f $(shell find -name "*.o")
	rm -f $(shell find -name "*.d")
	rm -f .config
	rm -f .config.old
	rm -f config.h

