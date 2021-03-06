library ieee;
use ieee.std_logic_1164.all;

entity extend is
    port(
        imm16  : in  std_logic_vector(15 downto 0);
        signed : in  std_logic;
        imm32  : out std_logic_vector(31 downto 0)
    );
end extend;

architecture synth of extend is
begin
	extend_proc : process(imm16, signed)
	BEGIN 
	IF signed = '1' and imm16(15) = '1' THEN
        	imm32 <= X"FFFF" & imm16;
	ELSE 
		imm32 <= X"0000" & imm16;
	END IF;
	END process;	
end synth;
