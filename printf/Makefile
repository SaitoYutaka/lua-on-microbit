CC = arm-none-eabi-gcc

CFLAGS = -DNRF51 -mcpu=cortex-m0 -mthumb -mabi=aapcs \
-Wall -O0 -g -mfloat-abi=soft -ffunction-sections -fdata-sections -fno-strict-aliasing -fomit-frame-pointer \
-fno-builtin --short-enums -c

INCDIR =-I../../common/inc \
-I../inc \
-I ../nrfx \
-I ../config \
-I ../nrfx/mdk \
-I ../CMSIS_5/CMSIS/Core/Include \
-I ../nrfx/drivers/include \
-I ../nrfx/hal \
-I ../lua-5.4.1/src

all : printf.o

printf.o: printf.c
	$(CC) $(TARGET_ARCH) $(INCDIR) $(CFLAGS) -o $@ -c $<
