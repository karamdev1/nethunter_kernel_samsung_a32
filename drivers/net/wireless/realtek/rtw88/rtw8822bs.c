// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
/* Copyright(c) Jernej Skrabec <jernej.skrabec@gmail.com>
#include <linux/module.h>
 */

#include <linux/mmc/sdio_func.h>
#include "sdio_ids.h"
#include "main.h"
#include "rtw8822b.h"
#include "sdio.h"

static const struct sdio_device_id rtw_8822bs_id_table[] =  {
	{
		SDIO_DEVICE(SDIO_VENDOR_ID_REALTEK,
			    SDIO_DEVICE_ID_REALTEK_RTW8822BS),
		.driver_data = (kernel_ulong_t)&rtw8822b_hw_spec,
	},
	{}
};
MODULE_DEVICE_TABLE(sdio, rtw_8822bs_id_table);

static struct sdio_driver rtw_8822bs_driver = {
	.name = KBUILD_MODNAME,
	.probe = rtw_sdio_probe,
	.remove = rtw_sdio_remove,
	.id_table = rtw_8822bs_id_table,
	.drv = {
		.pm = &rtw_sdio_pm_ops,
		.shutdown = rtw_sdio_shutdown,
	}
};

MODULE_AUTHOR("Jernej Skrabec <jernej.skrabec@gmail.com>");
MODULE_DESCRIPTION("Realtek 802.11ac wireless 8822bs driver");
MODULE_LICENSE("Dual BSD/GPL");

static int __init rtw_8822bs_driver_init(void)
{
	return sdio_register_driver(&rtw_8822bs_driver);
}
module_init(rtw_8822bs_driver_init);

static void __exit rtw_8822bs_driver_exit(void)
{
	sdio_unregister_driver(&rtw_8822bs_driver);
}
module_exit(rtw_8822bs_driver_exit);
