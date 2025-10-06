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
		0 => to_unsigned(45871, 16), -- C0 16.35Hz
		1 => to_unsigned(43302, 16), -- C#0 17.32Hz
		2 => to_unsigned(40871, 16), -- D0 18.35Hz
		3 => to_unsigned(38560, 16), -- D#0 19.45Hz
		4 => to_unsigned(36407, 16), -- E0 20.6Hz
		5 => to_unsigned(34356, 16), -- F0 21.83Hz
		6 => to_unsigned(32439, 16), -- F#0 23.12Hz
		7 => to_unsigned(30612, 16), -- G0 24.5Hz
		8 => to_unsigned(28890, 16), -- G#0 25.96Hz
		9 => to_unsigned(27272, 16), -- A0 27.5Hz
		10 => to_unsigned(25737, 16), -- A#0 29.14Hz
		11 => to_unsigned(24295, 16), -- B0 30.87Hz
		12 => to_unsigned(22935, 16), -- C1 32.7Hz
		13 => to_unsigned(21645, 16), -- C#1 34.65Hz
		14 => to_unsigned(20430, 16), -- D1 36.71Hz
		15 => to_unsigned(19285, 16), -- D#1 38.89Hz
		16 => to_unsigned(18203, 16), -- E1 41.2Hz
		17 => to_unsigned(17182, 16), -- F1 43.65Hz
		18 => to_unsigned(16216, 16), -- F#1 46.25Hz
		19 => to_unsigned(15306, 16), -- G1 49.0Hz
		20 => to_unsigned(14448, 16), -- G#1 51.91Hz
		21 => to_unsigned(13636, 16), -- A1 55.0Hz
		22 => to_unsigned(12871, 16), -- A#1 58.27Hz
		23 => to_unsigned(12147, 16), -- B1 61.74Hz
		24 => to_unsigned(11466, 16), -- C2 65.41Hz
		25 => to_unsigned(10822, 16), -- C#2 69.3Hz
		26 => to_unsigned(10215, 16), -- D2 73.42Hz
		27 => to_unsigned(9642, 16), -- D#2 77.78Hz
		28 => to_unsigned(9100, 16), -- E2 82.41Hz
		29 => to_unsigned(8590, 16), -- F2 87.31Hz
		30 => to_unsigned(8108, 16), -- F#2 92.5Hz
		31 => to_unsigned(7653, 16), -- G2 98.0Hz
		32 => to_unsigned(7223, 16), -- G#2 103.83Hz
		33 => to_unsigned(6818, 16), -- A2 110.0Hz
		34 => to_unsigned(6435, 16), -- A#2 116.54Hz
		35 => to_unsigned(6074, 16), -- B2 123.47Hz
		36 => to_unsigned(5733, 16), -- C3 130.81Hz
		37 => to_unsigned(5411, 16), -- C#3 138.59Hz
		38 => to_unsigned(5107, 16), -- D3 146.83Hz
		39 => to_unsigned(4821, 16), -- D#3 155.56Hz
		40 => to_unsigned(4550, 16), -- E3 164.81Hz
		41 => to_unsigned(4295, 16), -- F3 174.61Hz
		42 => to_unsigned(4054, 16), -- F#3 185.0Hz
		43 => to_unsigned(3826, 16), -- G3 196.0Hz
		44 => to_unsigned(3611, 16), -- G#3 207.65Hz
		45 => to_unsigned(3409, 16), -- A3 220.0Hz
		46 => to_unsigned(3217, 16), -- A#3 233.08Hz
		47 => to_unsigned(3037, 16), -- B3 246.94Hz
		48 => to_unsigned(2866, 16), -- C4 261.63Hz
		49 => to_unsigned(2705, 16), -- C#4 277.18Hz
		50 => to_unsigned(2553, 16), -- D4 293.66Hz
		51 => to_unsigned(2410, 16), -- D#4 311.13Hz
		52 => to_unsigned(2275, 16), -- E4 329.63Hz
		53 => to_unsigned(2147, 16), -- F4 349.23Hz
		54 => to_unsigned(2027, 16), -- F#4 369.99Hz
		55 => to_unsigned(1913, 16), -- G4 392.0Hz
		56 => to_unsigned(1805, 16), -- G#4 415.3Hz
		57 => to_unsigned(1704, 16), -- A4 440.0Hz
		58 => to_unsigned(1608, 16), -- A#4 466.16Hz
		59 => to_unsigned(1518, 16), -- B4 493.88Hz
		60 => to_unsigned(1433, 16), -- C5 523.25Hz
		61 => to_unsigned(1352, 16), -- C#5 554.37Hz
		62 => to_unsigned(1276, 16), -- D5 587.33Hz
		63 => to_unsigned(1205, 16), -- D#5 622.25Hz
		64 => to_unsigned(1137, 16), -- E5 659.26Hz
		65 => to_unsigned(1073, 16), -- F5 698.46Hz
		66 => to_unsigned(1013, 16), -- F#5 739.99Hz
		67 => to_unsigned(956, 16), -- G5 783.99Hz
		68 => to_unsigned(902, 16), -- G#5 830.61Hz
		69 => to_unsigned(852, 16), -- A5 880.0Hz
		70 => to_unsigned(804, 16), -- A#5 932.33Hz
		71 => to_unsigned(759, 16), -- B5 987.77Hz
		72 => to_unsigned(716, 16), -- C6 1046.5Hz
		73 => to_unsigned(676, 16), -- C#6 1108.73Hz
		74 => to_unsigned(638, 16), -- D6 1174.66Hz
		75 => to_unsigned(602, 16), -- D#6 1244.51Hz
		76 => to_unsigned(568, 16), -- E6 1318.51Hz
		77 => to_unsigned(536, 16), -- F6 1396.91Hz
		78 => to_unsigned(506, 16), -- F#6 1479.98Hz
		79 => to_unsigned(478, 16), -- G6 1567.98Hz
		80 => to_unsigned(451, 16), -- G#6 1661.22Hz
		81 => to_unsigned(426, 16), -- A6 1760.0Hz
		82 => to_unsigned(402, 16), -- A#6 1864.66Hz
		83 => to_unsigned(379, 16), -- B6 1975.53Hz
		84 => to_unsigned(358, 16), -- C7 2093.0Hz
		85 => to_unsigned(338, 16), -- C#7 2217.46Hz
		86 => to_unsigned(319, 16), -- D7 2349.32Hz
		87 => to_unsigned(301, 16), -- D#7 2489.02Hz
		88 => to_unsigned(284, 16), -- E7 2637.02Hz
		89 => to_unsigned(268, 16), -- F7 2793.83Hz
		90 => to_unsigned(253, 16), -- F#7 2959.96Hz
		91 => to_unsigned(239, 16), -- G7 3135.96Hz
		92 => to_unsigned(225, 16), -- G#7 3322.44Hz
		93 => to_unsigned(213, 16), -- A7 3520.0Hz
		94 => to_unsigned(201, 16), -- A#7 3729.31Hz
		95 => to_unsigned(189, 16), -- B7 3951.07Hz
		96 => to_unsigned(179, 16), -- C8 4186.01Hz
		97 => to_unsigned(169, 16), -- C#8 4434.92Hz
		98 => to_unsigned(159, 16), -- D8 4698.64Hz
		99 => to_unsigned(150, 16), -- D#8 4978.03Hz
		100 => to_unsigned(142, 16), -- E8 5274.04Hz
		101 => to_unsigned(134, 16), -- F8 5587.65Hz
		102 => to_unsigned(126, 16), -- F#8 5919.91Hz
		103 => to_unsigned(119, 16), -- G8 6271.93Hz
		104 => to_unsigned(112, 16), -- G#8 6644.88Hz
		105 => to_unsigned(106, 16), -- A8 7040.0Hz
		106 => to_unsigned(100, 16), -- A#8 7458.62Hz
		107 => to_unsigned(94, 16), -- B8 7902.13Hz
		108 => to_unsigned(89, 16), -- C9 8372.02Hz
		109 => to_unsigned(84, 16), -- C#9 8869.84Hz
		110 => to_unsigned(79, 16), -- D9 9397.27Hz
		111 => to_unsigned(75, 16), -- D#9 9956.06Hz
		112 => to_unsigned(71, 16), -- E9 10548.08Hz
		113 => to_unsigned(67, 16), -- F9 11175.3Hz
		114 => to_unsigned(63, 16), -- F#9 11839.82Hz
		115 => to_unsigned(59, 16), -- G9 12543.85Hz
		116 => to_unsigned(56, 16), -- G#9 13289.75Hz
		117 => to_unsigned(53, 16), -- A9 14080.0Hz
		118 => to_unsigned(50, 16), -- A#9 14917.24Hz
		119 => to_unsigned(47, 16), -- B9 15804.27Hz
        others => to_unsigned(2866, 16) -- C3
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