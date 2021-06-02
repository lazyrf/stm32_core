#include "config.h"

#if CONFIG_MCU_FAMILY_F4
#include "stm32f4xx_hal.h"
#elif CONFIG_MCU_FAMILY_F1
#include "stm32f1xx_hal.h"
#endif

void SysTick_Handler(void)
{
    HAL_IncTick();
    HAL_SYSTICK_IRQHandler();
}
