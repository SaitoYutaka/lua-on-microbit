CMSISPATH=./CMSIS_5/CMSIS
NRFXPATH=./nrfx

IPATH=-I $(CMSISPATH)/Core/Include/
IPATH+=-I $(NRFXPATH)/hal/
IPATH+=-I $(NRFXPATH)/drivers/include/
IPATH+=-I $(NRFXPATH)/
IPATH+=-I $(NRFXPATH)/mdk/
IPATH+=-I ./config/
IPATH+=-I ./printf/
IPATH+=-I ./lua-5.4.1/src

CFLAGS = -DNRF51 \
 -mcpu=cortex-m0 \
 -mthumb -mabi=aapcs \
 -Wall -Werror -O0 -g \
 -mfloat-abi=soft \
 -ffunction-sections -fdata-sections -fno-strict-aliasing \
 -fno-builtin --short-enums

LDFLAGS = -mthumb -mabi=aapcs \
 -mcpu=cortex-m0 \
 -Wl,--gc-sections \
 --specs=nano.specs -lc -lnosys -nostdlib

OBJS = \
./lib/crt0.o \
main.o \
./lib/printf.o \
nrfx_uart.o \
./lua-5.4.1/src/liblua.a \
gcc_startup_nrf51.o \
system_nrf51.o \
./lib/libc.a \
init.o \
./lib/libnosys.a \
./lib/libm.a

# OBJS = \
# ./lib/crt0.o \
# main.o \
# ./lib/printf.o \
# nrfx_uart.o \
# ./lua-5.4.1/src/liblua.a \
# locale_ctype_ptr.o \
# gcc_startup_nrf51.o \
# system_nrf51.o \
# ./lib/libc.a \
# init.o \
# ./lib/libnosys.a \
# ./lib/libm.a

all : main.hex

main.hex : main.elf
	arm-none-eabi-objcopy $< $@ -O ihex

main.elf : $(OBJS)
	arm-none-eabi-gcc $(LDFLAGS) -T ./nrfx/mdk/nrf51_xxab.ld -L ./nrfx/mdk/ -L ./lib -o main.elf $(OBJS)

main.o : main.c
	arm-none-eabi-gcc -c $(CFLAGS) $(IPATH) -o $@ $<

locale_ctype_ptr.o : locale_ctype_ptr.c
	arm-none-eabi-gcc -c $(CFLAGS) $(IPATH) -o $@ $<

init.o : init.c
	arm-none-eabi-gcc -c $(CFLAGS) $(IPATH) -o $@ $<

nrfx_uart.o : ./nrfx/drivers/src/nrfx_uart.c
	arm-none-eabi-gcc -c $(CFLAGS) $(IPATH) -o $@ $<


system_nrf51.o : nrfx/mdk/system_nrf51.c
	arm-none-eabi-gcc -c $(CFLAGS) $(IPATH) -o $@ $<

gcc_startup_nrf51.o : ./nrfx/mdk/gcc_startup_nrf51.S
	arm-none-eabi-gcc -c -g -mcpu=cortex-m0 -o $@ $<

clean:
	rm -f *.hex
	rm -f *.o
	rm -f *.out
	rm -f *.elf
