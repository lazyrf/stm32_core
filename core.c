#include "config.h"

#if CONFIG_MCU_FAMILY_F4
#include "stm32f4xx_hal.h"
#elif CONFIG_MCU_FAMILY_F1
#include "stm32f1xx_hal.h"
#endif

int core_init(void)
{
    HAL_Init();

    return 0;
}

