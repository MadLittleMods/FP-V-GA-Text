----------------------------------------------------------------------------------
-- Company: Visual Pulse
-- Engineer: Eric (MLM)
-- 
-- Create Date:    09:33:28 07/11/2013 
-- Design Name: 
-- Module Name:    vgaText_top - Behavioral 
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


entity vgaText_top is
	port(
		clk: in std_logic;
		reset: in std_logic; -- SW0
		Led: out std_logic_vector(7 downto 0);
		
		hsync: out std_logic;
		vsync: out std_logic;
		Red: out std_logic_vector(2 downto 0);
		Green: out std_logic_vector(2 downto 0);
		Blue: out std_logic_vector(2 downto 1)
	);
end vgaText_top;

architecture Behavioral of vgaText_top is
	COMPONENT text_line
	generic (
		textPassageLength: integer;
		fontWidth: integer;
		fontHeight: integer
	);
	PORT(
		clk: in std_logic;
		textPassage: in string;
		position: in point_2d;
		hCounter: in std_logic_vector(9 downto 0);
		vCounter: in std_logic_vector(9 downto 0);
		pixelOn: out std_logic;
		rgbPixel: out std_logic_vector(7 downto 0);
		debug: out type_text_lineDebug
   );
	END COMPONENT;
	
	signal hCounter: std_logic_vector(9 downto 0) := (others => '0');
	signal vCounter: std_logic_vector(9 downto 0) := (others => '0');
	
	signal divide_by_2 : std_logic := '0';
	
	signal pixelDraw_text1: std_logic_vector(8 downto 0);
	
	signal text_lineDebug: type_text_lineDebug;
	
begin

	Led <= std_logic_vector(to_unsigned(character'pos('A'), 8));
	--Led <= text_lineDebug.debugDraw(text_lineDebug.debugDraw'left downto text_lineDebug.debugDraw'left-7);

	textDrawComponent: text_line
	generic map (
		textPassageLength => 11,
		fontWidth => 8,
		fontHeight => 16
	)
	port map(
		clk => clk,
		textPassage => "Hello World",
		position => (50, 50),
		hCounter => hCounter,
		vCounter => vCounter,
		pixelOn => pixelDraw_text1(pixelDraw_text1'left),
		rgbPixel => pixelDraw_text1(pixelDraw_text1'left-1 downto 0),
		debug => text_lineDebug
	);
	
	
	vgasignal: process(clk)
		variable rgbDrawColor : std_logic_vector(7 downto 0);
	begin
		
		if rising_edge(clk) then
			if reset = '1' then
				hsync <= '0';
				vsync <= '0';
				hCounter <= (others => '0');
				vCounter <= (others => '0');
			else
				
				-- Running at 25 Mhz (50 Mhz / 2)
				if divide_by_2 = '1' then
					
					if(hCounter = 799) then
						hCounter <= (others => '0');
						
						if(vCounter = 524) then
							vCounter <= (others => '0');
						else
							vCounter <= vCounter + 1;
						end if;
					else
						hCounter <= hCounter + 1;
					end if;
					
					if (vCounter >= 490 and vCounter < 491) then
					  vsync <= '0';
					else
					  vsync <= '1';
					end if;
					
					if (hCounter >= 656 and hCounter < 752) then
					  hsync <= '0';
					else
					  hsync <= '1';
					end if;
					
					if (hCounter < 640 and vCounter < 480) then
						
						
						
						-- Draw stack:
						-- Draw text
						if (pixelDraw_text1(pixelDraw_text1'left) = '1') then
							rgbDrawColor := pixelDraw_text1(pixelDraw_text1'left-1 downto 0);		
						else
							rgbDrawColor := "000" & "000" & "00";
						end if;
						
						
						-- Show your colors
						Red <= rgbDrawColor(7 downto 5);
						Green <= rgbDrawColor(4 downto 2);
						Blue <= rgbDrawColor(1 downto 0);
						
						
						-- Test red square
						--if hCounter <= 10 and vCounter <= 10 then
						--	Red <= "111";
						--	Green <= "000";
						--	Blue <= "00";
						--end if;
						
					else
						Red <= "000";
						Green <= "000";
						Blue <= "00";
					end if;
			
				end if;
				divide_by_2 <= not divide_by_2;
			end if;
		end if;
	end process;

end Behavioral;

