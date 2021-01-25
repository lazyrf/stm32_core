#include "config.h"

#if CONFIG_HAL_LIB_F4
#include "stm32f4xx_hal.h"
#else
#include "stm32f1xx_hal.h"
#endif

void HAL_MspInit(void)
{
    // 1. Set up the priority grouping of the ARM cortex-M processor
    HAL_NVIC_SetPriorityGrouping(NVIC_PRIORITYGROUP_4);

    //2 . Enable the require system exeptions of the ARM cortex-M processor
    SCB->SHCSR |= 0x7 << 16;

    // 3. Configure the priority of the System Exceptions
    HAL_NVIC_SetPriority(UsageFault_IRQn, 0, 0);
    HAL_NVIC_SetPriority(BusFault_IRQn, 0, 0);
    HAL_NVIC_SetPriority(MemoryManagement_IRQn, 0, 0);
}

