#include <nrfx.h>
#include <nrfx_rtc.h>
#include <nrfx_clock.h>
#include <nrfx_gpiote.h>
#include <nrf_gpio.h>
#include <nrfx_uart.h>
#include <system_nrf51.h>

#include <string.h> // memset

#include <printf.h>

#include <lua.h>       // lua_pcall(), lua_pop(), lua_close()
#include <lauxlib.h>   // LuaL_newstate(), luaL_loadbuffer()
#include <lualib.h>    // luaL_openlibs()

const nrfx_uart_t m_uart = NRFX_UART_INSTANCE(0);

#define BUFF_SIZE 256
static uint8_t rx_tmp[BUFF_SIZE];
static uint8_t rx_buffer[BUFF_SIZE];
static int i = 0;
void getc_uart(void){
    if(i >= BUFF_SIZE) return;
    nrfx_uart_rx(&m_uart, rx_tmp, 1);
    rx_buffer[i++] = rx_tmp[0];
}

int main(void){
    int error;
    lua_State* L = luaL_newstate();
    luaL_openlibs(L);

    nrfx_uart_config_t uart_config = NRFX_UART_DEFAULT_CONFIG(24,25);
    nrfx_uart_init(&m_uart, &uart_config, NULL);
    nrfx_uart_rx_enable(&m_uart);

    while(1){
        getc_uart();
        if(rx_tmp[0] == 0xd) {
            printf_("\n");
            error = luaL_loadbuffer(L, (char *)rx_buffer, strlen((char *)rx_buffer), "line") || 
                lua_pcall(L, 0, 0, 0);
            if(error){
                printf_("%s\n",lua_tostring(L, -1));
                lua_pop(L, 1);
            }
            i = 0;
            memset(rx_buffer, 0, sizeof(rx_buffer));
        } else {
            nrfx_uart_tx(&m_uart, rx_tmp, 1);
        }
    }

    return 0;
}
