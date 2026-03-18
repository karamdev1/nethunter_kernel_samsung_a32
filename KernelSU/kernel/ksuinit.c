#include <linux/export.h>
#include <linux/fs.h>
#include <linux/printk.h>
#include <linux/kobject.h>
#include <linux/module.h>
#include <generated/utsrelease.h>
#include <generated/compile.h>
#include <linux/version.h> /* LINUX_VERSION_CODE, KERNEL_VERSION macros */
#include <linux/sched.h>

#ifdef CONFIG_KSU_SUSFS
#include <linux/susfs.h>
#endif // #ifdef CONFIG_KSU_SUSFS

#include "allowlist.h"
#include "app_profile.h"
#include "arch.h"
#include "feature.h"
#include "klog.h" // IWYU pragma: keep
#include "manager.h"
#include "ksu.h"
#include "throne_tracker.h"
#ifdef CONFIG_KSU_SYSCALL_HOOK
#include "syscall_handler.h"
#endif
#if defined(CONFIG_KSU_MANUAL_HOOK) || defined(CONFIG_KSU_SUSFS)
#include "setuid_hook.h"
#include "sucompat.h"
#endif // #ifndef CONFIG_KSU_SUSFS
#include "ksud.h"
#include "supercalls.h"
#include "ksu.h"
#include "file_wrapper.h"
#include "selinux/selinux.h"

// workaround for A12-5.10 kernel
// Some third-party kernel (e.g. linegaeOS) uses wrong toolchain, which supports
// CC_HAVE_STACKPROTECTOR_SYSREG while gki's toolchain doesn't.
// Therefore, ksu lkm, which uses gki toolchain, requires this __stack_chk_guard,
// while those third-party kernel can't provide.
// Thus, we manually provide it instead of using kernel's
#if defined(CONFIG_STACKPROTECTOR) &&                                          \
    (defined(CONFIG_ARM64) && defined(MODULE) &&                               \
     !defined(CONFIG_STACKPROTECTOR_PER_TASK))
#include <linux/stackprotector.h>
#include <linux/random.h>
unsigned long __stack_chk_guard __ro_after_init
    __attribute__((visibility("hidden")));
__attribute__((no_stack_protector)) void ksu_setup_stack_chk_guard()
{
    unsigned long canary;

    /* Try to get a semi random initial value. */
    get_random_bytes(&canary, sizeof(canary));
    canary ^= LINUX_VERSION_CODE;
    canary &= CANARY_MASK;
    __stack_chk_guard = canary;
}

__attribute__((naked)) int __init kernelsu_init_early(void)
{
    asm("mov x19, x30;\n"
        "bl ksu_setup_stack_chk_guard;\n"
        "mov x30, x19;\n"
        "b kernelsu_init;\n");
}
#define NEED_OWN_STACKPROTECTOR 1
#else
#define NEED_OWN_STACKPROTECTOR 0
#endif

extern void __init ksu_lsm_hook_init(void);

void sukisu_custom_config_init(void)
{
}

void sukisu_custom_config_exit(void)
{
}

struct cred *ksu_cred;
bool ksu_late_loaded;

int __init kernelsu_init(void)
{
#ifdef MODULE
    ksu_late_loaded = (current->pid != 1);
#else
    ksu_late_loaded = false;
#endif

#ifndef DDK_ENV
	pr_info("Initialized on: %s (%s) with driver version: %u\n",
		UTS_RELEASE, UTS_MACHINE, KSU_VERSION);
#endif

#ifdef CONFIG_KSU_DEBUG
	pr_alert(
		"*************************************************************");
	pr_alert(
		"**     NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE    **");
	pr_alert(
		"**                                                         **");
	pr_alert(
		"**         You are running KernelSU in DEBUG mode          **");
	pr_alert(
		"**                                                         **");
	pr_alert(
		"**     NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE    **");
	pr_alert(
		"*************************************************************");
#endif

	ksu_cred = prepare_creds();
	if (!ksu_cred) {
		pr_err("prepare cred failed!\n");
	}

	ksu_feature_init();

	ksu_supercalls_init();

	sukisu_custom_config_init();

	if (ksu_late_loaded) {
        pr_info("late load mode, skipping kprobe hooks\n");

        apply_kernelsu_rules();
        cache_sid();
        setup_ksu_cred();

		// Grant current process (ksud late-load) root
        // with KSU SELinux domain before enforcing SELinux, so it
        // can continue to access /data/app etc. after enforcement.
        escape_to_root_for_init();

		ksu_lsm_hook_init();

        ksu_allowlist_init();
        ksu_load_allow_list();

#ifdef CONFIG_KSU_SYSCALL_HOOK
		ksu_syscall_hook_manager_init();
#endif
#if defined(CONFIG_KSU_MANUAL_HOOK) || defined(CONFIG_KSU_SUSFS)
		ksu_setuid_hook_init();
		ksu_sucompat_init();
#endif

        ksu_throne_tracker_init();

#ifdef CONFIG_KSU_SUSFS
		susfs_init();
#endif // #ifdef CONFIG_KSU_SUSFS

#if defined(CONFIG_KSU_SYSCALL_HOOK) || defined(CONFIG_KSU_SUSFS) ||           \
	(LINUX_VERSION_CODE >= KERNEL_VERSION(6, 8, 0) &&                      \
	 defined(CONFIG_KSU_MANUAL_HOOK))
		ksu_observer_init();
#endif

        ksu_file_wrapper_init();

        ksu_boot_completed = true;
        track_throne(false);

		if (!getenforce()) {
            pr_info("Permissive SELinux, enforcing\n");
            setenforce(true);
        }
		
    } else {
#ifdef CONFIG_KSU_SYSCALL_HOOK
        ksu_syscall_hook_manager_init();
#endif

		ksu_lsm_hook_init();

        ksu_allowlist_init();

#if defined(CONFIG_KSU_MANUAL_HOOK) || defined(CONFIG_KSU_SUSFS)
		ksu_setuid_hook_init();
		ksu_sucompat_init();
#endif

        ksu_throne_tracker_init();

#ifdef CONFIG_KSU_SUSFS
		susfs_init();
#endif // #ifdef CONFIG_KSU_SUSFS

#ifndef CONFIG_KSU_SUSFS
		ksu_ksud_init();
#endif // #ifndef CONFIG_KSU_SUSFS

        ksu_file_wrapper_init();
    }

#ifdef MODULE
#ifndef CONFIG_KSU_DEBUG
	kobject_del(&THIS_MODULE->mkobj.kobj);
#endif
#endif
	return 0;
}

#if defined(CONFIG_KSU_SYSCALL_HOOK) || defined(CONFIG_KSU_SUSFS) ||           \
	(LINUX_VERSION_CODE >= KERNEL_VERSION(6, 8, 0) &&                      \
	 defined(CONFIG_KSU_MANUAL_HOOK))
extern void ksu_observer_exit(void);
#endif

void kernelsu_exit(void)
{
	ksu_allowlist_exit();

	ksu_throne_tracker_exit();

#if defined(CONFIG_KSU_SYSCALL_HOOK) || defined(CONFIG_KSU_SUSFS) ||           \
	(LINUX_VERSION_CODE >= KERNEL_VERSION(6, 8, 0) &&                      \
	 defined(CONFIG_KSU_MANUAL_HOOK))
	ksu_observer_exit();
#endif
#ifndef CONFIG_KSU_SUSFS
	if (!ksu_late_loaded)
	ksu_ksud_exit();
#endif // #ifndef CONFIG_KSU_SUSFS
#ifdef CONFIG_KSU_SYSCALL_HOOK
	ksu_syscall_hook_manager_exit();
#endif
#if defined(CONFIG_KSU_MANUAL_HOOK) || defined(CONFIG_KSU_SUSFS)
	ksu_sucompat_exit();
	ksu_setuid_hook_exit();
#endif

	sukisu_custom_config_exit();

	ksu_supercalls_exit();

	ksu_feature_exit();

	if (ksu_cred) {
		put_cred(ksu_cred);
	}
}

#if NEED_OWN_STACKPROTECTOR
module_init(kernelsu_init_early);
#else
module_init(kernelsu_init);
#endif
module_exit(kernelsu_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("weishu");
MODULE_DESCRIPTION("Android KernelSU");

#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 0, 0)
#if LINUX_VERSION_CODE >= KERNEL_VERSION(6, 13, 0)
MODULE_IMPORT_NS("VFS_internal_I_am_really_a_filesystem_and_am_NOT_a_driver");
#else
MODULE_IMPORT_NS(VFS_internal_I_am_really_a_filesystem_and_am_NOT_a_driver);
#endif
#endif
