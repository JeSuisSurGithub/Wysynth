library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fctl is
    port(
        clk, up, down: in std_logic;
        nclk: out std_logic
    );
end entity;

architecture behav of fctl is
    signal counter: unsigned(15 downto 0) := to_unsigned(0, 16);
    signal count_max: unsigned(15 downto 0) := to_unsigned(1024, 16); -- (27MHz / (50Hz * 256)) * 2 = 4218 ~ 4096
    signal nclkbuf, upbuf, downbuf: std_logic := '0'; 

    begin
        nclk <= nclkbuf;

        process(clk) begin
            if rising_edge(clk) then
                upbuf <= up;
                downbuf <= down;

                if upbuf = '0' and up = '1' and count_max > 31 then
                    count_max <= shift_right(count_max, 1);
                end if;

                if downbuf = '0' and down = '1' and count_max < 2049 then
                    count_max <= shift_left(count_max, 1);
                end if;

                if counter < count_max/2 then
                    counter <= counter + 1;
                    nclkbuf <= '0';
                elsif counter < count_max then
                    counter <= counter + 1;
                    nclkbuf <= '1';
                else
                    counter <= to_unsigned(0, 16);
                end if;
            end if;
        end process;
    end behav;