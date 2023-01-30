#define MICROPY_HW_BOARD_NAME "MKRZERO"
#define MICROPY_HW_MCU_NAME   "SAMD21G18A"

#define MICROPY_HW_XOSC32K                      (1)
#define MICROPY_PY_FSTRINGS         (1)

// fatfs configuration used in ffconf.h
#define MICROPY_FATFS_ENABLE_LFN            (1)
#define MICROPY_FATFS_RPATH                 (2)
#define MICROPY_FATFS_MAX_SS                (4096)
#define MICROPY_FATFS_LFN_CODE_PAGE         437 /* 1=SFN/ANSI 437=LFN/U.S.(OEM) */
