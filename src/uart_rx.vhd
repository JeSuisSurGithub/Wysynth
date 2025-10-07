library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx is
    port(
        clk, rst, rx: in std_logic; -- 96MHz, RX to HM-10 TX
        data_out: out std_logic_vector(7 downto 0);
        data_ready: out std_logic -- Ready on high
    );
end uart_rx;

architecture behav of uart_rx is
    constant CLKS_PER_BIT: integer := 10000; -- 9600 bauds
    type state_type is (IDLE, START, DATA, STOP, DONE);

    signal state: state_type;
    signal clk_count: integer range 0 to CLKS_PER_BIT := 0;
    signal bit_index: integer range 0 to 7 := 0;
    signal rx_shift: std_logic_vector(7 downto 0) := (others => '0');

    begin
        process(clk) begin
            if rising_edge(clk) then
                if rst = '1' then
                    state <= IDLE;
                    data_ready <= '0';
                    clk_count <= 0;
                    bit_index <= 0;
                else
                    case state is
                        when IDLE =>
                            data_ready <= '0';
                            if rx = '0' then
                                state <= START;
                                clk_count <= 0;
                            end if;
                        when START =>
                            if clk_count = (CLKS_PER_BIT/2) then
                                state <= DATA;
                                clk_count <= 0;
                                bit_index <= 0;
                            else
                                clk_count <= clk_count + 1;
                            end if;
                        when DATA =>
                            if clk_count = CLKS_PER_BIT then
                                clk_count <= 0;
                                rx_shift(bit_index) <= rx;
                                if bit_index = 7 then
                                    state <= STOP;
                                else
                                    bit_index <= bit_index + 1;
                                end if;
                            else
                                clk_count <= clk_count + 1;
                            end if;
                        when STOP =>
                            if clk_count = CLKS_PER_BIT then
                                state <= DONE;
                                clk_count <= 0;
                            else
                                clk_count <= clk_count + 1;
                            end if;
                        when DONE =>
                            data_ready <= '1';
                            data_out <= rx_shift;
                            state <= IDLE;
                        when others =>
                            state <= IDLE;
                    end case;
                end if;
            end if;
        end process;
    end behav;