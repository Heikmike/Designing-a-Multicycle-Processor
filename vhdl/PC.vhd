library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port(
        clk     : in  std_logic;
        reset_n : in  std_logic;
        en      : in  std_logic;
        sel_a   : in  std_logic;
        sel_imm : in  std_logic;
        add_imm : in  std_logic;
        imm     : in  std_logic_vector(15 downto 0);
        a       : in  std_logic_vector(15 downto 0);
        addr    : out std_logic_vector(31 downto 0)
    );
end PC;

architecture synth of PC is
SIGNAL tmp_addr : std_logic_vector(31 downto 0);
-- SIGNAL tmp_addr_2 : std_logic_vector(31 downto 0);
begin
	addr <= x"0000" & tmp_addr(15 downto 2) & "00";
	PC_process:process(clk, reset_n) 
	BEGIN
		IF reset_n = '0' THEN 
			tmp_addr <= X"00000000";
			-- addr <= X"00000000";
		ELSIF rising_edge(clk) THEN
			-- For the branch/call/callr/ret/jmp state
			--branch
			IF en = '1' AND add_imm = '1' THEN 
				tmp_addr <= std_logic_vector(unsigned(tmp_addr) + unsigned(imm));	
			-- call
			ELSIF en = '1' AND sel_imm = '1' THEN 
				tmp_addr <= "00000000000000" & imm & "00";
			-- callr/ret/jmp
			ELSIF en = '1' AND sel_a = '1' THEN
				tmp_addr <=  "0000000000000000" & a;
			-- For the normal way
			ELSIF en = '1' THEN 
				tmp_addr <= std_logic_vector(unsigned(tmp_addr) + 4);
			END IF;
		END IF;	
	END PROCESS;
end synth;
