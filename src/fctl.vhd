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
            1 => to_unsigned(6087, 16), -- C#1 34.65
            2 => to_unsigned(5746, 16), -- D1 36.71
            3 => to_unsigned(5423, 16), -- D#1 38.89
            4 => to_unsigned(5119, 16), -- E1 41.2
            5 => to_unsigned(4832, 16), -- F1 43.65
            6 => to_unsigned(4560, 16), -- F#1 46.25
            7 => to_unsigned(4304, 16), -- G1 49.0
            8 => to_unsigned(4063, 16), -- G#1 51.91
            9 => to_unsigned(3835, 16), -- A1 55.0
            10 => to_unsigned(3620, 16), -- A#1 58.27
            11 => to_unsigned(3416, 16), -- B1 61.74
            12 => to_unsigned(3224, 16), -- C2 65.41
            13 => to_unsigned(3043, 16), -- C#2 69.3
            14 => to_unsigned(2873, 16), -- D2 73.42
            15 => to_unsigned(2711, 16), -- D#2 77.78
            16 => to_unsigned(2559, 16), -- E2 82.41
            17 => to_unsigned(2415, 16), -- F2 87.31
            18 => to_unsigned(2280, 16), -- F#2 92.5
            19 => to_unsigned(2152, 16), -- G2 98.0
            20 => to_unsigned(2031, 16), -- G#2 103.83
            21 => to_unsigned(1917, 16), -- A2 110.0
            22 => to_unsigned(1810, 16), -- A#2 116.54
            23 => to_unsigned(1708, 16), -- B2 123.47
            24 => to_unsigned(1612, 16), -- C3 130.81
            25 => to_unsigned(1522, 16), -- C#3 138.59
            26 => to_unsigned(1436, 16), -- D3 146.83
            27 => to_unsigned(1355, 16), -- D#3 155.56
            28 => to_unsigned(1279, 16), -- E3 164.81
            29 => to_unsigned(1208, 16), -- F3 174.61
            30 => to_unsigned(1140, 16), -- F#3 185.0
            31 => to_unsigned(1076, 16), -- G3 196.0
            32 => to_unsigned(1015, 16), -- G#3 207.65
            33 => to_unsigned(958, 16), -- A3 220.0
            34 => to_unsigned(905, 16), -- A#3 233.08
            35 => to_unsigned(854, 16), -- B3 246.94
            36 => to_unsigned(806, 16), -- C4 261.63
            37 => to_unsigned(761, 16), -- C#4 277.18
            38 => to_unsigned(718, 16), -- D4 293.66
            39 => to_unsigned(677, 16), -- D#4 311.13
            40 => to_unsigned(639, 16), -- E4 329.63
            41 => to_unsigned(604, 16), -- F4 349.23
            42 => to_unsigned(570, 16), -- F#4 369.99
            43 => to_unsigned(538, 16), -- G4 392.0
            44 => to_unsigned(507, 16), -- G#4 415.3
            45 => to_unsigned(479, 16), -- A4 440.0
            46 => to_unsigned(452, 16), -- A#4 466.16
            47 => to_unsigned(427, 16), -- B4 493.88
            48 => to_unsigned(403, 16), -- C5 523.25
            49 => to_unsigned(380, 16), -- C#5 554.37
            50 => to_unsigned(359, 16), -- D5 587.33
            51 => to_unsigned(338, 16), -- D#5 622.25
            52 => to_unsigned(319, 16), -- E5 659.26
            53 => to_unsigned(302, 16), -- F5 698.46
            54 => to_unsigned(285, 16), -- F#5 739.99
            55 => to_unsigned(269, 16), -- G5 783.99
            56 => to_unsigned(253, 16), -- G#5 830.61
            57 => to_unsigned(239, 16), -- A5 880.0
            58 => to_unsigned(226, 16), -- A#5 932.33
            59 => to_unsigned(213, 16), -- B5 987.77
            60 => to_unsigned(201, 16), -- C6 1046.5
            61 => to_unsigned(190, 16), -- C#6 1108.73
            62 => to_unsigned(179, 16), -- D6 1174.66
            63 => to_unsigned(169, 16), -- D#6 1244.51
            64 => to_unsigned(159, 16), -- E6 1318.51
            65 => to_unsigned(151, 16), -- F6 1396.91
            66 => to_unsigned(142, 16), -- F#6 1479.98
            67 => to_unsigned(134, 16), -- G6 1567.98
            68 => to_unsigned(126, 16), -- G#6 1661.22
            69 => to_unsigned(119, 16), -- A6 1760.0
            70 => to_unsigned(113, 16), -- A#6 1864.66
            71 => to_unsigned(106, 16), -- B6 1975.53
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