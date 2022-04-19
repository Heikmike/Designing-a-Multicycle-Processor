library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
    port(
        a        : in  std_logic_vector(31 downto 0);
        b        : in  std_logic_vector(31 downto 0);
        sub_mode : in  std_logic;
        carry    : out std_logic;
        zero     : out std_logic;
        r        : out std_logic_vector(31 downto 0)
    );
end add_sub;

architecture synth of add_sub is
signal temp : std_logic_vector(32 downto 0);
signal b_xor : std_logic_vector(31 downto 0);
begin
	process(a, b, sub_mode, temp, b_xor)
	VARIABLE tmp_carry : integer;
	Begin
	tmp_carry := 0;
	b_xor <= "00000000000000000000000000000000";
	if (sub_mode = '0') then
		b_xor <= "00000000000000000000000000000000";
		tmp_carry := 0;
	elsif (sub_mode = '1') then
		b_xor <= "11111111111111111111111111111111";
		tmp_carry := 1;
	end if;
	temp <= STD_LOGIC_VECTOR(resize(unsigned("0" & a) + unsigned("0" & (b XOR b_xor)) + to_unsigned(tmp_carry, b'length), temp'length));
	r <= temp(31 downto 0);
 	carry <= temp(32);
	CASE temp(31 downto 0) is 
		WHEN "00000000000000000000000000000000" => zero <= '1';
		WHEN others => zero <= '0';
	END CASE;
	END process;
end synth;
