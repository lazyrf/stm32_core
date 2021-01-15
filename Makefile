LIB_NAME 		:= stm32_core
export PROJ_NAME

CROSS_COMPILE  	:= arm-none-eabi-
CC 				:= $(CROSS_COMPILE)gcc
LD 				:= $(CROSS_COMPILE)ld
AS 				:= $(CROSS_COMPILE)as
CPP 			:= $(CC) -E
AR  			:= $(CROSS_COMPILE)nm
STRIP 			:= $(CROSS_COMPILE)strip
OBJCOPY 		:= $(CROSS_COMPILE)objcopy
OBJDUMP 		:= $(CROSS_COMPILE)objdump
SIZE 			:= $(CROSS_COMPILE)siesz
export CC LD AS CPP AR STRIP OBJCOPY OBJDUMP SIZE

TOPDIR 			:= $(shell pwd)
SDKDIR 			:= $(TOPDIR)/sdk
BUILDIR 		:= $(TOPDIR)/build
export TOPDIR SDKDIR BUILDIR

.PHONY: all clean distclean

-include .config

CPU = $(patsubst "%",%,$(CONFIG_CPU_CORE))
CORE = -mcpu=$(CPU) -mthumb -mfloat-abi=soft
DEFINITIONS = $(patsubst "%",%,$(CONFIG_MCU_SERIES)) \
			  USE_HAL_DRIVER

INC := .
INC += $(TOPDIR)
INC += $(SDKDIR)
INC += $(SDKDIR)/CMSIS/Include
ifeq ($(CONFIG_HAL_LIB_F1),y)
INC += $(SDKDIR)/CMSIS/Device/ST/STM32F1xx/Include
INC += $(SDKDIR)/STM32F1xx_HAL_Driver/Inc
else
INC += $(SDKDIR)/CMSIS/Device/ST/STM32F4xx/Include
INC += $(SDKDIR)/STM32F4xx_HAL_Driver/Inc
endif

CFLAGS := $(CORE) \
	$(addprefix -D,$(DEFINITIONS)) \
	-std=gnu11 -g0 $(addprefix -I,$(INC)) \
	-ffunction-sections -fdata-sections \
	-u_scanf_float -u_printf_float \
	--specs=nosys.specs
export CFLAGS

# Use := to avoid recusive issue
obj-y :=
obj-y += sdk/
obj-y += startup/

all: chkconfig start_recursive_build
	@echo $(LIB_NAME) has been build!

chkconfig:
	@test -f .config || (echo conifg is not found; exit 1)
	# @test -f .config || (echo .conifg is not found; exit 1)$(MAKE) -f scripts/Makefile menuconfig

start_recursive_build:
	make -C ./ -f $(TOPDIR)/Makefile.build

menuconfig:
	@$(MAKE) -f scripts/Makefile $@

clean:
	rm -f $(shell find -name "*.o")
	rm -f $(shell find -name "*.d")

distclean:
	rm -f $(shell find -name "*.o")
	rm -f $(shell find -name "*.d")
	rm -f .config
	rm -f .config.old
	rm -f config.h

