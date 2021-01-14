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

INC := .
INC += $(TOPDIR)
INC += $(SDKDIR)
INC += $(SDKDIR)/CMSIS/Include
INC += $(SDKDIR)/CMSIS/Device/ST/STM32F4xx/Include
INC += $(SDKDIR)/STM32F4xx_HAL_Driver/Inc

CFLAGS := -mcpu=cortex-m4 -std=gnu11 -g3 -DUSE_HAL_DRIVER -DDEBUG -DSTM32F429xx $(addprefix -I,$(INC))
export CFLAGS

# Use := to avoid recusive issue
obj-y :=
obj-y += sdk/

all: start_recursive_build
	@echo $(PROJ_NAME) has been build!

start_recursive_build:
	make -C ./ -f $(TOPDIR)/Makefile.build

clean:
	rm -f $(shell find -name "*.o")
	rm -f $(shell find -name "*.d")

