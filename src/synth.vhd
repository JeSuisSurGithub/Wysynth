library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity synth is
    port(
        clk, up, down: in std_logic;
        data: out std_logic_vector(7 downto 0)
    );
end entity;

architecture behav of synth is
    signal nclk: std_logic := '0';
    begin
        fctrl : entity work.fctl(behav)
            port map(
                clk => clk, up => up, down => down, nclk => nclk);

        saw: entity work.saw(behav)
            port map(
                clk => nclk, data => data);
    end behav;