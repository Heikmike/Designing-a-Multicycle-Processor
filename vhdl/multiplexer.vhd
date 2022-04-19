library ieee;
use ieee.std_logic_1164.all;

entity multiplexer is
    port(
        i0  : in  std_logic_vector(31 downto 0);
        i1  : in  std_logic_vector(31 downto 0);
        i2  : in  std_logic_vector(31 downto 0);
        i3  : in  std_logic_vector(31 downto 0);
        sel : in  std_logic_vector(1 downto 0);
        o   : out std_logic_vector(31 downto 0)
    );
end multiplexer;

architecture synth of multiplexer is
begin
	With sel SELECT
	o <= i0 WHEN "00" ,
  	     i1 WHEN "01" ,
  	     i2 WHEN "10" ,
	     i3 WHEN "11",
	     i0 WHEN others;
end synth;
