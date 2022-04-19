library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
    port(
        clk     : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        write   : in  std_logic;
        address : in  std_logic_vector(9 downto 0);
        wrdata  : in  std_logic_vector(31 downto 0);
        rddata  : out std_logic_vector(31 downto 0));
end RAM;

architecture synth of RAM is
type ram_type is array(0 to 4095) of std_logic_vector(7 downto 0);
signal ram : ram_type;
signal raddr : std_logic_vector(9 downto 0);
signal s_read, s_cs : std_logic;
begin 
	rddata <= (ram(to_integer(unsigned(raddr))*4 + 3) & ram(to_integer(unsigned(raddr))*4 + 2) & ram(to_integer(unsigned(raddr))*4 + 1) & ram(to_integer(unsigned(raddr))*4)) when s_read = '1' and s_cs = '1' else  "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
	-- rddata <= (ram(to_integer(unsigned(address))*4 + 3) & ram(to_integer(unsigned(address))*4 + 2) & ram(to_integer(unsigned(address))*4 + 1) & ram(to_integer(unsigned(address))*4) ) when read = '1' and cs = '1' else  "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
	
 	ram_read_proc : process(clk) IS
	begin
		IF rising_edge(clk) THEN
			s_read <= read;
			s_cs <= cs;
			raddr <= address;
		END IF;
	END process ram_read_proc;

	ram_write_proc : process(clk) IS
	begin
		IF rising_edge(clk) THEN
			IF cs = '1' and write = '1' THEN
				ram(to_integer(unsigned(address))*4) <= wrdata(7 downto 0);
				ram(to_integer(unsigned(address))*4 + 1) <= wrdata(15 downto 8);
				ram(to_integer(unsigned(address))*4 + 2) <= wrdata(23 downto 16);
				ram(to_integer(unsigned(address))*4 + 3) <= wrdata(31 downto 24);
			END IF;
		END IF;
	END process ram_write_proc;

end synth;
