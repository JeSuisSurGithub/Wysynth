library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity synth is
    port(
        mclk, wavesel, rst, rx: in std_logic; -- 27MHz Master Clock
        tx, sdi, sck, cs_n: out std_logic;
        debug: out std_logic_vector(5 downto 0)
    );
end entity;

architecture behav of synth is
    signal clk96: std_logic;

    signal rx_data: std_logic_vector(7 downto 0);
    signal rx_ready: std_logic;

    signal tx_busy: std_logic;
    signal tx_start: std_logic;
    signal tx_data: std_logic_vector(7 downto 0);

    signal key: unsigned(7 downto 0) := to_unsigned(48, 8); -- C4
    signal oscclk: std_logic := '0';

    signal data: std_logic_vector(7 downto 0) := "00000000";
    signal data_en: std_logic := '1';
    signal send_data: std_logic_vector(7 downto 0) := "00000000";

    signal send: std_logic := '1';
    signal busy: std_logic;

    signal cnt: unsigned(31 downto 0) := to_unsigned(0, 32);

    begin
        debug <= tx_data(6 downto 1);

        grpll: entity work.Gowin_rPLL(Behavioral)
            port map(clkout => clk96, clkin => mclk);

        uart_rx_inst: entity work.uart_rx
            port map (clk => clk96, rst => rst,
                rx => rx, data_out => rx_data, data_ready => rx_ready);

        uart_tx_inst: entity work.uart_tx
            port map (clk => clk96, rst => rst,
                tx_start => tx_start, data_in => tx_data, tx => tx, busy => tx_busy);

        fctl : entity work.fctl(behav)
            port map(
                clk => clk96, key => key, clkout => oscclk);

        osc: entity work.osc(behav)
            port map(
                clk => oscclk, sel => wavesel, data => data);

        dac: entity work.spi_dac(behav)
            port map(
                clk => clk96, send => send, data_in => send_data,
                sdi => sdi, sck => sck, cs_n => cs_n, busy => busy);

        send_data <= data when data_en = '1' else "01111111";

        -- Echo back
        process(clk96) begin
            if rising_edge(clk96) then
                if rst = '1' then
                    tx_start <= '0';
                else
                    if (rx_ready = '1') and (tx_busy = '0') then
                        tx_data <= rx_data;
                        tx_start <= '1';
                    else
                        tx_start <= '0';
                    end if;
                end if;
            end if;
        end process;

        -- Incoming key
        process(rx_ready) begin
            if rx_ready = '1' then
                -- Unsupported note / turn off
                if unsigned(rx_data) > 119 then
                    data_en <= '0';
                else
                    key <= unsigned(rx_data);
                    data_en <= '1';
                end if;
            end if;
        end process;
    end behav;