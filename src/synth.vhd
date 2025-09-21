library ieee;
use ieee.std_logic_1164.all;

entity synth is
    port(
        clk, up, down: in std_logic;
        sdi         : out std_logic;
        sck         : out std_logic;
        cs_n        : out std_logic
    );
end entity;

architecture behav of synth is
    signal nclk: std_logic := '0';
    signal data: std_logic_vector(7 downto 0) := "00000000";
    signal send: std_logic := '1';
    signal busy: std_logic := '0';

    begin
        fctrl : entity work.fctl(behav)
            port map(
                clk => clk, up => up, down => down, nclk => nclk);

        saw: entity work.saw(behav)
            port map(
                clk => nclk, data => data);

        dac: entity work.spi_dac(behav)
            port map(
                clk => clk,
                data_in => data,
                send => send,
                sdi => sdi,
                sck => sck,
                cs_n => cs_n,
                busy => busy);
    end behav;