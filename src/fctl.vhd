library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fctl is
    port(
        clk: in std_logic;
        key: in unsigned(7 downto 0);
        clkout: out std_logic
    );
end entity;

architecture behav of fctl is
    type div is array(0 to 255) of unsigned(15 downto 0);
    constant div_table: div := (
        0 => to_unsigned(6450, 16), -- C1 32.7
        1 => to_unsigned(5746, 16), -- D1 36.71
        2 => to_unsigned(5119, 16), -- E1 41.2
        3 => to_unsigned(4832, 16), -- F1 43.65
        4 => to_unsigned(4304, 16), -- G1 49.0
        5 => to_unsigned(3835, 16), -- A1 55.0
        6 => to_unsigned(3416, 16), -- B1 61.74
        7 => to_unsigned(3224, 16), -- C2 65.41
        8 => to_unsigned(2873, 16), -- D2 73.42
        9 => to_unsigned(2559, 16), -- E2 82.41
        10 => to_unsigned(2415, 16), -- F2 87.31
        11 => to_unsigned(2152, 16), -- G2 98.0
        12 => to_unsigned(1917, 16), -- A2 110.0
        13 => to_unsigned(1708, 16), -- B2 123.47
        14 => to_unsigned(1612, 16), -- C3 130.81
        15 => to_unsigned(1436, 16), -- D3 146.83
        16 => to_unsigned(1279, 16), -- E3 164.81
        17 => to_unsigned(1208, 16), -- F3 174.61
        18 => to_unsigned(1076, 16), -- G3 196.0
        19 => to_unsigned(958, 16), -- A3 220.0
        20 => to_unsigned(854, 16), -- B3 246.94
        21 => to_unsigned(806, 16), -- C4 261.63
        22 => to_unsigned(718, 16), -- D4 293.66
        23 => to_unsigned(639, 16), -- E4 329.63
        24 => to_unsigned(604, 16), -- F4 349.23
        25 => to_unsigned(538, 16), -- G4 392.0
        26 => to_unsigned(479, 16), -- A4 440.0
        27 => to_unsigned(427, 16), -- B4 493.88
        28 => to_unsigned(403, 16), -- C5 523.25
        29 => to_unsigned(359, 16), -- D5 587.33
        30 => to_unsigned(319, 16), -- E5 659.26
        31 => to_unsigned(302, 16), -- F5 698.46
        32 => to_unsigned(269, 16), -- G5 783.99
        33 => to_unsigned(239, 16), -- A5 880.0
        34 => to_unsigned(213, 16), -- B5 987.77
        35 => to_unsigned(201, 16), -- C6 1046.5
        36 => to_unsigned(179, 16), -- D6 1174.66
        37 => to_unsigned(159, 16), -- E6 1318.51
        38 => to_unsigned(151, 16), -- F6 1396.91
        39 => to_unsigned(134, 16), -- G6 1567.98
        40 => to_unsigned(119, 16), -- A6 1760.0
        41 => to_unsigned(106, 16), -- B6 1975.53
        others => to_unsigned(1612, 16) -- C3
    );
    signal cnt: unsigned(15 downto 0) := to_unsigned(0, 16);
    signal key_div: unsigned(15 downto 0);
    signal clkout_reg: std_logic := '0';

    begin
        clkout <= clkout_reg;
        key_div <= div_table(to_integer(key));

        process(clk) begin
            if rising_edge(clk) then
                if cnt < key_div/2 then
                    cnt <= cnt + 1;
                    clkout_reg <= '0';
                elsif cnt < key_div then
                    cnt <= cnt + 1;
                    clkout_reg <= '1';
                else
                    cnt <= to_unsigned(0, 16);
                end if;
            end if;
        end process;
    end behav;