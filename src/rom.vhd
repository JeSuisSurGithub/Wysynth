library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity saw is
    port(
        clk: in std_logic;
        data: out std_logic_vector(7 downto 0)
    );
end entity;

architecture behav of saw is
    signal addr: unsigned(7 downto 0) := "00000000";
    begin
        process(clk) begin
            if rising_edge(clk) then
                if addr < 255 then
                    addr <= addr + 1;
                else
                    addr <= to_unsigned(0, 8);
                end if;
                data <= std_logic_vector(addr); -- SAW
            end if;
        end process;
    end behav;