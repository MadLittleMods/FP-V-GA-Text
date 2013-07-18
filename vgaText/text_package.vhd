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

package text_package is
	
	type point_2d is
	record
		x : integer;
		y : integer;
	end record;

	type type_textColorMap is array(natural range <>) of std_logic_vector(7 downto 0); 
	
	
	type type_text_lineDebug is
	record
		debugDraw: std_logic_vector(39 downto 0);
	end record;
	

------------------------------------------

	
	type type_drawElement is
	record
		pixelOn: boolean;
		rgb: std_logic_vector(7 downto 0);
	end record;


------------------------------------------

	constant ADDR_WIDTH : integer := 11;
	constant DATA_WIDTH : integer := 8;

	type type_inArbiterPort is
	record
		addr: std_logic_vector(ADDR_WIDTH-1 downto 0);
	end record;
	type type_inArbiterPortArray is array(natural range <>) of type_inArbiterPort; 
	
	type type_outArbiterPort is
	record
		dataWaiting: boolean;
      data: std_logic_vector(DATA_WIDTH-1 downto 0);
	end record;
	type type_outArbiterPortArray is array(natural range <>) of type_outArbiterPort; 



end text_package;

package body text_package is

end text_package;
