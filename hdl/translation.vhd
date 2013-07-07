----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:44:04 07/03/2013 
-- Design Name: 
-- Module Name:    translation - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--library work;
--use work.FIX_pkg.all;

entity TAGtranslation is
	 Generic (
				endian			: string := "big";
				tag_bytes		: integer := 3);
    Port (
				clk				: in  STD_LOGIC;
				rst				: in  STD_LOGIC;
				ce					: in  STD_LOGIC;
				data_in			: in  STD_LOGIC_VECTOR(tag_bytes*8-1 downto 0);
				tag				: out	STD_LOGIC_VECTOR(9 downto 0));	-- tag number, we defined 1024 tage
end TAGtranslation;

architecture Behavioral of TAGtranslation is

type SegmentType is array (0 to tag_bytes-1) of unsigned(7 downto 0);
signal buff, segment: SegmentType := (others => (others => '0'));

signal ten_2, ten_1, ten_0: unsigned(9 downto 0);
signal tag_buff: std_logic_vector(9 downto 0);
signal zero_prefix: unsigned(1 downto 0);
constant offset: unsigned(7 downto 0) := x"1E";	-- 30 in decimal, number = ascii - 30 

begin

process(clk, rst)
type ZerosType is array (0 to tag_bytes-1) of unsigned(9 downto 0);
variable zeros_buff: ZerosType := (others => (others => '0'));
begin
	if rst = '1' then
		segment	<= (others => (others => '0'));
		buff		<= (others => (others => '0'));
		zeros_buff	:= (others => (others => '0'));
		ten_2		<= (others => '0');
		ten_1		<= (others => '0');
		ten_0		<= (others => '0');
		tag_buff	<= (others => '0');
		tag		<= (others => '0');
	elsif rising_edge(clk) then
		if ce = '1' then
			for i in 0 to tag_bytes-1 loop
				segment(i) <= unsigned(data_in(7+i*8 downto i*8));
				buff(i) <= segment(i) - offset;
				zeros_buff(i) := zero_prefix & buff(i);
			end loop;
			
			ten_2 <= shift_left(zeros_buff(2), 2) + shift_left(zeros_buff(2), 5) + shift_left(zeros_buff(2), 6);	-- zeros_buff * 100
			ten_1 <= shift_left(zeros_buff(1), 1) + shift_left(zeros_buff(1), 3);		-- zeros_buff * 10
			ten_0 <= zeros_buff(0);
			
			tag_buff <= std_logic_vector(ten_2 + ten_1 + ten_0);
			tag <= tag_buff;
		end if;
	end if;
end process;

end Behavioral;

