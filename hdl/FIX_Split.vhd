----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:17:45 07/07/2013 
-- Design Name: 
-- Module Name:    split - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FIX_Split is
	 Generic (
				endian			: string := "big";
				tag_bytes		: integer := 4);
    Port ( 
				clk				: in  STD_LOGIC;
				rst				: in  STD_LOGIC;
				ce					: in  STD_LOGIC;
				fault_seq		: out STD_LOGIC;
				data_in			: in  STD_LOGIC_VECTOR(7 downto 0);
				tag				: out STD_LOGIC_VECTOR(tag_bytes*8-1 downto 0));
end FIX_Split;

architecture Behavioral of FIX_Split is

type PatternStateType is (
	INIT, BEGIN_PATTERN, EQUAL_PATTERN, GAP_PATTERN, FAULT_PATTERN);
signal pattern_state: PatternStateType := INIT;

signal pattern_buf: std_logic_vector(7 downto 0);

signal tag_buf: std_logic_vector(8*tag_bytes-1 downto 0);
signal string_buf: std_logic_vector(143 downto 0);
signal zero_num: integer range 0 to 7 := 0;

begin

--entity work.FIX_Tag 
--		generic map
--			(	endian		=> endian,
--				tag_bytes	=> tag_bytes)
--		port map
--			(	clk			=> clk,
--				rst			=> rst,
--				ce				=> ce,
--				tag_



-- input/output buffer
--process(clk, rst)
--begin
--	if rst = '1' then
--		pattern_buf <= (others => '0');
--		
--	elsif rising_edge(clk) then
--		if ce = '1' then
--			for i in 0 to 6 loop
--				pattern_buf(0) <= data_in;
--				pattern_buf(i+1) <= pattern_buf(i); 
--			end loop;
--		end if;
--	end if;
--end process;

-- sequence detector
process(clk, rst)
begin
	if rst = '1' then
		pattern_state	<= INIT;
		zero_num			<= 0;
		tag_buf			<= (others => '0');
		string_buf		<= (others => '0');
		fault_seq		<= '0';
	elsif rising_edge(clk) then
		if ce = '1' then
			case pattern_state is
				when INIT =>
					if (data_in = x"00") then
						zero_num <= zero_num + 1;
						pattern_state <= INIT;
					elsif (data_in = x"38") and (zero_num = 2) then
						zero_num <= 0;
						tag_buf(7 downto 0) <= data_in;
						pattern_state <= BEGIN_PATTERN;
					else
						zero_num <= 0;
						pattern_state <= INIT;
					end if;
					
				when BEGIN_PATTERN =>
					if (data_in = x"3D") then			-- condition("=")?
						pattern_state <= EQUAL_PATTERN;
					else
						pattern_state <= FAULT_PATTERN;
					end if;
					
				when GAP_PATTERN =>
					if (data_in = x"00") then
						zero_num <= zero_num + 1;
					elsif (data_in = x"38") and (zero_num = 2) then
						zero_num <= 0;
						pattern_state <= BEGIN_PATTERN;
					elsif (data_in = x"3D") then
						-- tag info reset
						pattern_state <= EQUAL_PATTERN;
					else
						-- tag info written
						for j in 0 to 1 loop
							tag_buf(7+j*8 downto j*8) <= data_in;
							tag_buf(7+(j+1)*8 downto (j+1)*8) <= tag_buf(7+j*8 downto j*8);
						end loop;
						pattern_state <= GAP_PATTERN;
					end if;
				
				when EQUAL_PATTERN =>
					if (data_in = x"01") then
						-- string info reset
						pattern_state <= GAP_PATTERN;
					else
						-- string info written
						for i in 0 to 16 loop
							string_buf(7+i*8 downto i*8) <= data_in;
							string_buf(7+(i+1)*8 downto (i+1)*8) <= string_buf(7+i*8 downto i*8);
						end loop;
						pattern_state <= EQUAL_PATTERN;
					end if;
					
				when FAULT_PATTERN =>
					fault_seq <= '1';
					pattern_state <= FAULT_PATTERN;
			
			end case;
		end if;
	end if;	
end process;

end Behavioral;

