library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
    port(
        a_31    : in  std_logic;
        b_31    : in  std_logic;
        diff_31 : in  std_logic;
        carry   : in  std_logic;
        zero    : in  std_logic;
        op      : in  std_logic_vector(2 downto 0);
        r       : out std_logic
    );
end comparator;

architecture synth of comparator is
begin
	With op SELECT
	r <= (a_31 AND NOT b_31) OR ((a_31 XNOR b_31) AND (diff_31 OR zero)) WHEN "001" ,
	     (NOT a_31 AND b_31) OR ((a_31 XNOR b_31) AND (NOT diff_31 AND NOT zero)) WHEN "010" ,
  	     NOT zero WHEN "011",
  	     zero WHEN "100",
  	     NOT carry OR zero WHEN "101" ,
  	     carry AND NOT zero WHEN "110" ,
  	     zero WHEN others;
end synth;
