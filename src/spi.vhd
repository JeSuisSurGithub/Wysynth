library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_dac is
    port(
        clk, send: in std_logic; -- 96MHz
        data_in: in std_logic_vector(7 downto 0);
        sdi, sck, cs_n, busy: out std_logic -- Busy on high
    );
end spi_dac;

architecture behav of spi_dac is
    constant clk_div: integer := 96; -- 1MHz
    signal cnt: integer := 0;

    signal sck_en: std_logic := '0';
    signal sck_reg: std_logic := '0';

    signal sending: std_logic := '0';
    signal bit_cnt: integer range 0 to 15 := 0;
    signal shift_reg: std_logic_vector(15 downto 0) := (others => '0');

    begin
        sck <= sck_reg when sck_en = '1' else '0';
        sdi <= shift_reg(15);
        cs_n <= not sending;
        busy <= sending;

        process(clk)
        begin
            if rising_edge(clk) then
                if sending = '0' then
                    if send = '1' then
                        -- Load shift register with control + 12-bit data
                        -- Control bits + 8-bit data shifted to 12-bit
                        shift_reg <= "0011" & data_in & "0000";
                        sending   <= '1';
                        bit_cnt   <= 0;
                        cnt   <= 0;
                        sck_en    <= '1';
                        sck_reg   <= '0';
                    end if;
                else
                    -- Sending in progress
                    cnt <= cnt + 1;
                    if cnt = (clk_div / 2 - 1) then
                        sck_reg <= not sck_reg;
                        cnt <= 0;

                        if sck_reg = '1' then
                            -- Shift data on rising edge of SCK
                            shift_reg <= shift_reg(14 downto 0) & '0';
                            bit_cnt <= bit_cnt + 1;
                            if bit_cnt = 15 then
                                sending <= '0';
                                sck_en  <= '0';
                            end if;
                        end if;
                    end if;
                end if;
            end if;
        end process;
    end behav;