library ieee;
use ieee.std_logic_1164.all;
-- TODO: no sure this could be used
use ieee.numeric_std.all;

entity decoder is
    port(
        address : in  std_logic_vector(15 downto 0);
        cs_LEDS : out std_logic;
        cs_RAM  : out std_logic;
        cs_ROM  : out std_logic;
	cs_BUTTONS : out std_logic
    );
end decoder;

architecture synth of decoder is
begin
	decoder_proc : process(address)
	Begin 
		cs_LEDS <= '0';
		cs_RAM <= '0';
		cs_ROM <= '0';
		cs_BUTTONS <= '0';
		-- TODO I don't know whether it should be 4096 here
		IF to_integer(unsigned(address)) >= 0 and to_integer(unsigned(address)) <= 4092 then
			cs_ROM <= '1';
		ELSIF to_integer(unsigned(address)) >= 4096 and to_integer(unsigned(address)) <= 8188 then 
			cs_RAM <= '1';
		ELSIF to_integer(unsigned(address)) >= 8192 and to_integer(unsigned(address)) <= 8204 then
			cs_LEDS <= '1';
		ELSIF to_integer(unsigned(address)) >= 8240 and to_integer(unsigned(address)) <= 8244 then
			cs_BUTTONS <= '1';
		END IF;
	END process;	
end synth;
