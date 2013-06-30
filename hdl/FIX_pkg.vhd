--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

--hardware implementation
library IEEE_PROPOSED;
use IEEE_PROPOSED.fixed_float_types.all;
use IEEE_PROPOSED.fixed_pkg.all;
use IEEE_PROPOSED.float_pkg.all;

package FIX_pkg is

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
	
	-- table parameters
	constant TABLE_LENGTH		: integer := 956;		-- check FIX table at:
																	-- http://www.fixprotocol.org/FIXimate3.0/en/FIX.4.4/fields_sorted_by_tagnum.html
	constant ASCII_LENGTH		: integer := 95;		-- ASCII table length

	-- testbench generic
	constant VECTOR_LENGTH		: integer := 10;
	type din_t is array (VECTOR_LENGTH-1 downto 0) of std_logic_vector(WIDTH_IN-1 downto 0);
	type dout_t is array (VECTOR_LENGTH-1 downto 0) of std_logic_vector(WIDTH_OUT-1 downto 0);
	
	-- hardware implementation
	type ASCIITableType is array (0 to ASCII_LENGTH-1) of string;
	constant ASCII: ASCIITableType := ( "sp", "!", "", "#", "$", "%", "&", "'",
													"(", ")", "*", "+", ",", "-", ".", "/",
													"0", "1", "2", "3", "4", "5", "6", "7",
													"8", "9", ":", ";", "<", "=", ">", "?",
													"@", "A", "B", "C", "D", "E", "F", "G",
													"H", "I", "J", "K", "L", "M", "N", "O",
													"P", "Q", "R", "S", "T", "U", "V", "W",
													"X", "Y", "Z", "[", "\", "]", "^", "_",
													"`", "a", "b", "c", "d", "e", "f", "g",
													"h", "i", "j", "k", "l", "m", "n", "o",
													"p", "q", "r", "s", "t", "u", "v", "w",
													"x", "y", "z", "{", "|", "}", "~");
	
	-- FIX partten defined below:
	
	type FIXTableType is array (0 to 9) of std_logic_vector(7 downto 0);
	-- FIX tag number
	constant FIXTag: FIXTagType := (	x"30", x"31", x"32", x"33", 
												x"34", x"35", x"36", x"37",
												x"38", x"39");
	type FIXSelType is array (0 to 25) of std_logic_vector(7 downto 0);
	-- FIX alphabet
	constant FIXSelPattern: FIXSelType := (	x"41", x"42", x"43", x"44",
															x"45", x"46", x"47", x"48",
															x"49", x"4A", x"4B", x"4C",
															x"4D", x"4E", x"4F", x"50",
															x"51", x"52", x"53", x"54",
															x"55", x"56", x"57", x"58",
															x"59", x"5A");
	constant FIXDot				: std_logic_vector(7 downto 0) := x"2E";
	constant FIXColon				: std_logic_vector(7 downto 0) := x"3A";
	constant FIXEqual				: std_logic_vector(7 downto 0) := x"3D";
	constant FIXGap				: std_logic_vector(7 downto 0) := x"01";
	constant FIXDash				: std_logic_vector(7 downto 0) := x"2D";
	
	
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--
	impure function ascii2bin(signal char: in string) return std_logic_vector(7 downto 0);
	impure function bin2ascii(signal bin: in std_logic_vector(7 downto 0)) return string;
	
	
end FIX_pkg;

package body FIX_pkg is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;
	
	impure function ascii2bin(signal char: in string) return std_logic_vector(7 downto 0) is
		variable bin: std_logic_vector(7 downto 0);
	begin
		
		return bin;
	end function;
	
	impure function bin2ascii(signal bin : in std_logic_vector(7 downto 0)) return string is
		variable char: string;
		variable index: integer;
	begin
		index := to_integer(unsigned'(bin));
		char := ASCII(index-32);
		return char;
	end function;
	
	
	
end FIX_pkg;