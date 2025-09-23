library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity synth is
    port(
        mclk, s1: in std_logic;
        sdi, sck, cs_n: out std_logic;
        debug: out std_logic_vector(4 downto 0)
    );
end entity;

architecture behav of synth is
    signal key: unsigned(7 downto 0) := to_unsigned(14, 8);
    signal oscclk: std_logic := '0';

    signal data: std_logic_vector(7 downto 0) := "00000000";
    signal data_en: std_logic := '1';
    signal send_data: std_logic_vector(7 downto 0) := "00000000";

    signal send: std_logic := '1';
    signal busy: std_logic;

    signal cnt: unsigned(31 downto 0) := to_unsigned(0, 32);

    begin
        fctl : entity work.fctl(behav)
            port map(
                clk => mclk, key => key, clkout => oscclk);

        osc: entity work.osc(behav)
            port map(
                clk => oscclk, sel => s1, data => data);

        dac: entity work.spi_dac(behav)
            port map(
                clk => mclk, send => send, data_in => send_data,
                sdi => sdi, sck => sck, cs_n => cs_n, busy => busy);

        send_data <= data when data_en = '1' else "01111111";

        -- Melody
        process(mclk) begin
            if rising_edge(mclk) then
                cnt <= cnt + 1;
                if cnt < 3375000 then
                    data_en <= '1';
                    key <= to_unsigned(21, 8);
                    debug <= "10000";
                elsif cnt > 3375000*2 and cnt < 3375000*3  then
                    data_en <= '1';
                    key <= to_unsigned(28, 8);
                    debug <= "01000";
                elsif cnt > 3375000*4 and cnt < 3375000*5 then
                    data_en <= '1';
                    key <= to_unsigned(14, 8);
                    debug <= "00100";
                elsif cnt > 3375000*6 and cnt < 3375000*7 then
                    data_en <= '1';
                    key <= to_unsigned(7, 8);
                    debug <= "00010";
                elsif cnt = 3375000*8 - 1 then
                    cnt <= to_unsigned(0, 32);
                else
                    data_en <= '0';
                    debug <= "00001";
                end if;
            end if;
        end process;
    end behav;