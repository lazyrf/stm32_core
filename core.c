#include "config.h"

#if CONFIG_HAL_LIB_F4
#include "stm32f4xx_hal.h"
#else
#include "stm32f1xx_hal.h"
#endif

int core_init(void)
{
    HAL_Init();

    return 0;
}

