-- uart.vhdl
--
-- complete uart
library IEEE;
use IEEE.std_logic_1164.all;

entity uart is
    generic (
        CLK_PERIOD      : time := 100 us;  -- 10 kHz clock
        BAUD_PERIOD     : time := 1600 us; -- 625 baud rate
        OVERSAMPLING    : integer range 1 to 16 := 16
    );
    port (
        clk             : in  std_logic;
        reset           : in  std_logic;

        rx              : in  std_logic;
        tx              : out std_logic;

        data_in         : in  std_logic_vector (7 downto 0);
        buffer_empty    : out std_logic;
        write           : in  std_logic;

        data_out        : out std_logic_vector (7 downto 0);
        data_ready      : out std_logic;
        read            : in  std_logic
    );
end entity uart;


architecture structural of uart is

    component uart_rx is
    generic (
        CLK_PERIOD      : time;
        BAUD_PERIOD     : time;
        OVERSAMPLING    : integer range 1 to 16
    );
    port (
        clk             : in  std_logic;
        reset           : in  std_logic;

        rx              : in  std_logic;

        read            : in  std_logic;
        data_ready      : out std_logic;
        data_out        : out std_logic_vector (7 downto 0)
    );
    end component uart_rx;

    component uart_tx is
    generic (
        CLK_PERIOD      : time;
        BAUD_PERIOD     : time;
        OVERSAMPLING    : integer range 1 to 16
    );
    port (
        clk             : in  std_logic;
        reset           : in  std_logic;

        write           : in  std_logic;
        data_in         : in  std_logic_vector (7 downto 0);
        buffer_empty    : out std_logic;

        tx              : out std_logic
    );
    end component uart_tx;


begin

uart_rx_map:
    uart_rx generic map (
        CLK_PERIOD      => CLK_PERIOD,
        BAUD_PERIOD     => BAUD_PERIOD,
        OVERSAMPLING    => OVERSAMPLING
    )
    port map (
        clk             => clk,
        reset           => reset,
        rx              => rx,
        read            => read,
        data_ready      => data_ready,
        data_out        => data_out
    );

uart_tx_map:
    uart_tx generic map (
        CLK_PERIOD      => CLK_PERIOD,
        BAUD_PERIOD     => BAUD_PERIOD,
        OVERSAMPLING    => OVERSAMPLING
    )
    port map (
        clk             => clk,
        reset           => reset,
        write           => write,
        data_in         => data_in,
        buffer_empty    => buffer_empty,
        tx              => tx
    );

end architecture structural;
