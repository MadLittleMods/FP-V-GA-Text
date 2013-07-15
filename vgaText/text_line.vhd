----------------------------------------------------------------------------------
-- Company: Visual Pulse
-- Engineer: Eric (MLM)
-- 
-- Create Date:    00:06:24 07/11/2013 
-- Design Name: 
-- Module Name:    text_line - Behavioral 
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--note this line.The package is compiled to this directory by default.
--so don't forget to include this directory. 
library work;
--this line also is must.This includes the particular package into your program.
use work.text_package.all;

entity text_line is
	generic(
		textPassageLength: integer := 11;
		fontWidth: integer := 8;
		fontHeight: integer := 16
	);
	port (
		clk: in std_logic;
		textPassage: in string(1 to textPassageLength);
		position: in point_2d := (0, 0); -- top left corner of text
		hCounter: in std_logic_vector(9 downto 0);
		vCounter: in std_logic_vector(9 downto 0);
		pixelOn: out std_logic;
		rgbPixel: out std_logic_vector(7 downto 0) := "111" & "111" & "11";
		debug: out type_text_lineDebug
	);

end text_line;

architecture Behavioral of text_line is

	COMPONENT fontROM
	generic (
		ADDR_WIDTH: integer;
		DATA_WIDTH: integer
	);
	PORT(
		clk: in std_logic;
      addr: in std_logic_vector(10 downto 0);
      data: out std_logic_vector(7 downto 0)
   );
	END COMPONENT;

	signal pixelBuffer : std_logic;
	signal RGBBuffer : std_logic_vector(7 downto 0) := "111" & "111" & "11";


	signal rom_addr: std_logic_vector(10 downto 0);
	-- Address in textROM where character is
	signal char_addr: std_logic_vector(6 downto 0); -- 2 ^ 7 = 128
	-- Vertical row of character in textROM at char_addr offset
	signal row_addr: std_logic_vector(3 downto 0) := (others => '0'); -- 2 ^ 4 = 16
	
	-- Data that pops out from the RAM
	signal fontRowData: std_logic_vector(7 downto 0);
	
	--type type_characterMemory is array (0 to fontHeight-1) of std_logic_vector(fontWidth-1 downto 0);
	--type type_textMemory is array (0 to textPassage'length-1) of type_characterMemory;
	
	-- Array of row map of all characters lined up
	type type_textMemory is array (0 to fontHeight-1) of std_logic_vector((textPassage'length*fontWidth)-1 downto 0);
	signal textMemory: type_textMemory;
	
begin
	
	pixelOn <= pixelBuffer;
	rgbPixel <= RGBBuffer;
	
	rom_addr <= char_addr & row_addr;

	textDB: fontROM
	generic map (
		ADDR_WIDTH => 11,
		DATA_WIDTH => 8
	)
	port map(
		clk => clk,
		addr => rom_addr,
		data => fontRowData
	);
	
	
	initializeMemory: process(clk)
		-- Strings index start at 1...
		variable currCharacter: integer := 1;
		
		type type_memoryFillLoopState is (state_updateCharAddr, state_fillMemory);
		variable currState: type_memoryFillLoopState := state_updateCharAddr;
		
		variable prevTextPassage: string(textPassage'left to textPassage'right);
		
	begin
		
		if rising_edge(clk) then
			if prevTextPassage /= textPassage then
				-- String index start at 1 so ye...
				if currCharacter-1 < textPassage'length then
					case currState is
						when state_updateCharAddr =>
							
							--char_addr <= ascii_address_xref(textPassage(currCharacter))(6 downto 0);
							char_addr <= std_logic_vector(to_unsigned(character'pos(textPassage(currCharacter)), 7));
							
							-- Change State
							currState := state_fillMemory;
							
						when state_fillMemory =>
							-- Store the data that poped out on the rising edge
							--textMemory(currCharacter)(to_integer(unsigned(row_addr))) <= fontRowData;
							textMemory(to_integer(unsigned(row_addr))) <= textMemory(to_integer(unsigned(row_addr)))(((textPassage'length-1)*fontWidth)-1 downto 0) & fontRowData;
					
							-- Now that we stored we advance the row address
							row_addr <= row_addr + 1;
							if row_addr >= fontHeight-1 then
								row_addr <= (others => '0');
								
								currCharacter := currCharacter + 1;
							end if;
							
							-- Change State
							currState := state_updateCharAddr;
							
					end case;
				else
					prevTextPassage := textPassage;
					currCharacter := 1;
				end if;
			end if;
				
		end if;
			
	end process;
	
	
	drawing: process(hCounter, vCounter, position)
	begin
		pixelBuffer <= '0';
		-- If we are drawing in the horizontal and vertical range of this line
		if hCounter < position.x + (fontWidth * textPassage'length) and hCounter >= position.x then
			if vCounter < position.y + fontHeight and vCounter >= position.y then
			
				-- to_integer(unsigned(vCounter - position.y))
				-- to_integer(unsigned(hCounter - position.x))
				if textMemory(to_integer(unsigned(vCounter - position.y)))(textMemory(0)'length-1 - to_integer(unsigned(hCounter - position.x))) = '1' then
					RGBBuffer <= "111" & "111" & "11";
					pixelBuffer <= '1';
				end if;
				
			end if;
		end if;
	end process;

end Behavioral;

