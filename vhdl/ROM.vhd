library ieee;
use ieee.std_logic_1164.all;

entity ROM is
    port(
        clk     : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        address : in  std_logic_vector(9 downto 0);
        rddata  : out std_logic_vector(31 downto 0)
    );
end ROM;

architecture synth of ROM is

    signal s_q: std_logic_vector(31 downto 0);
    signal s_read: std_logic;
    signal s_cs: std_logic;

    component ROM_BLOCK is
        port(
            address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		    clock		: IN STD_LOGIC  := '1';
		    q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    end component;

begin
	
	ROM_BLOCK_0: ROM_BLOCK port map(
	clock => clk,
        address => address,
        q => s_q
    	);

    	rddata <= s_q when s_read = '1' and s_cs = '1' else  "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
    	rom_read_proc : process(clk) IS
	begin
		IF rising_edge(clk) THEN
			s_read <= read;
			s_cs <= cs;
		END IF;
	END process rom_read_proc;
end synth;
