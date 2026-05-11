// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
/* Copyright(c) Martin Blumenstingl <martin.blumenstingl@googlemail.com>
#include <linux/module.h>
 */

#include <linux/mmc/sdio_func.h>
#include "sdio_ids.h"
#include "main.h"
#include "rtw8822c.h"
#include "sdio.h"

static const struct sdio_device_id rtw_8822cs_id_table[] =  {
	{
		SDIO_DEVICE(SDIO_VENDOR_ID_REALTEK,
			    SDIO_DEVICE_ID_REALTEK_RTW8822CS),
		.driver_data = (kernel_ulong_t)&rtw8822c_hw_spec,
	},
	{}
};
MODULE_DEVICE_TABLE(sdio, rtw_8822cs_id_table);

static struct sdio_driver rtw_8822cs_driver = {
	.name = KBUILD_MODNAME,
	.probe = rtw_sdio_probe,
	.remove = rtw_sdio_remove,
	.id_table = rtw_8822cs_id_table,
	.drv = {
		.pm = &rtw_sdio_pm_ops,
		.shutdown = rtw_sdio_shutdown,
	}
};

MODULE_AUTHOR("Martin Blumenstingl <martin.blumenstingl@googlemail.com>");
MODULE_DESCRIPTION("Realtek 802.11ac wireless 8822cs driver");
MODULE_LICENSE("Dual BSD/GPL");

static int __init rtw_8822cs_driver_init(void)
{
	return sdio_register_driver(&rtw_8822cs_driver);
}
module_init(rtw_8822cs_driver_init);

static void __exit rtw_8822cs_driver_exit(void)
{
	sdio_unregister_driver(&rtw_8822cs_driver);
}
module_exit(rtw_8822cs_driver_exit);
