library ieee;
use ieee.std_logic_1164.all;

entity synth is
    port(
        mclk, up, down: in std_logic;
        sdi, sck, cs_n: out std_logic
    );
end entity;

architecture behav of synth is
    signal oscclk: std_logic := '0';
    signal sel: std_logic := '1';

    signal data: std_logic_vector(7 downto 0) := "00000000";

    signal send: std_logic := '1';
    signal busy: std_logic;

    begin
        fctl : entity work.fctl(behav)
            port map(
                clk => mclk, up => up, down => down, clkout => oscclk);

        osc: entity work.osc(behav)
            port map(
                clk => oscclk, sel => sel, data => data);

        dac: entity work.spi_dac(behav)
            port map(
                clk => mclk, send => send, data_in => data,
                sdi => sdi, sck => sck, cs_n => cs_n, busy => busy);
    end behav;