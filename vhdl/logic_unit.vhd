library ieee;
use ieee.std_logic_1164.all;

entity logic_unit is
    port(
        a  : in  std_logic_vector(31 downto 0);
        b  : in  std_logic_vector(31 downto 0);
        op : in  std_logic_vector(1 downto 0);
        r  : out std_logic_vector(31 downto 0)
    );
end logic_unit;

architecture synth of logic_unit is
begin
	With op SELECT
	r <= a NOR b  WHEN "00" ,
  	     a AND b  WHEN "01" ,
  	     a OR b   WHEN "10" ,
  	     a XNOR b WHEN "11" ,
	     a WHEN others;
end synth;
