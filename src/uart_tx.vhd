library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx is
    port(
        clk, rst, tx_start: in std_logic;  -- 96MHz, Start on high
        data_in: in std_logic_vector(7 downto 0);
        tx, busy: out std_logic -- TX to HM-10 RX1, busy flag active on high
    );
end entity;

architecture behav of uart_tx is
    constant CLKS_PER_BIT: integer := 10000; -- 9600 bauds
    type state_type is (IDLE, START, DATA, STOP);

    signal tx_shift: std_logic_vector(7 downto 0) := (others => '0');
    signal state: state_type;
    signal clk_count: integer range 0 to CLKS_PER_BIT := 0;
    signal bit_index: integer range 0 to 7 := 0;

    begin
        busy <= '1' when state /= IDLE else '0';
        process(clk) begin
            if rising_edge(clk) then
                if rst = '1' then
                    state <= IDLE;
                    clk_count <= 0;
                    tx <= '1';
                    bit_index <= 0;
                else
                    case state is
                        when IDLE =>
                            tx <= '1';
                            if tx_start = '1' then
                                tx_shift <= data_in;
                                state <= START;
                                clk_count <= 0;
                            end if;
                        when START =>
                            tx <= '0';
                            if clk_count = CLKS_PER_BIT then
                                state <= DATA;
                                clk_count <= 0;
                                bit_index <= 0;
                            else
                                clk_count <= clk_count + 1;
                            end if;
                        when DATA =>
                            tx <= tx_shift(bit_index);
                            if clk_count = CLKS_PER_BIT then
                                clk_count <= 0;
                                if bit_index = 7 then
                                    state <= STOP;
                                else
                                    bit_index <= bit_index + 1;
                                end if;
                            else
                                clk_count <= clk_count + 1;
                            end if;
                        when STOP =>
                            tx <= '1';
                            if clk_count = CLKS_PER_BIT then
                                state <= IDLE;
                                clk_count <= 0;
                            else
                                clk_count <= clk_count + 1;
                            end if;
                        when others =>
                            state <= IDLE;
                    end case;
                end if;                
            end if;
        end process;
    end behav;