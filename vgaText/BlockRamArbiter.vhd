----------------------------------------------------------------------------------
-- Company: Visual Pulse
-- Engineer: Eric (MLM)
-- 
-- Create Date:    19:28:21 07/16/2013 
-- Design Name: 
-- Module Name:    BlockRamArbiter - Behavioral 
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

--note this line.The package is compiled to this directory by default.
--so don't forget to include this directory. 
library work;
--this line also is must.This includes the particular package into your program.
use work.text_package.all;


entity BlockRamArbiter is
	generic(
		numPorts: integer := 2
	);
	port (
		clk: in std_logic;
		reset: in std_logic;
		inPortArray: in type_inArbiterPortArray(0 to numPorts-1);
		outPortArray: out type_outArbiterPortArray(0 to numPorts-1)
	);
end BlockRamArbiter;

architecture Behavioral of BlockRamArbiter is
	signal romAddr_A: std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');
	signal romAddr_B: std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');
	
	-- Data that pops out from the RAM
	signal rowData_A: std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
	signal rowData_B: std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
begin

	textDB: entity work.fontROM
	generic map (
		addrWidth => ADDR_WIDTH,
		dataWidth => DATA_WIDTH
	)
	port map(
		clk => clk,
		addr_A => romAddr_A,
		data_A => rowData_A,
		addr_B => romAddr_B,
		data_B => rowData_B
	);
	
	arbitration: process(clk)
		variable currPortIndex_A: integer := 0;
		variable currPortIndex_B: integer := 1;
		
		variable prevCurrPortIndex_A: integer := 0;
		variable prevCurrPortIndex_B: integer := 1;
		
		variable isSetup: boolean;
		
		type type_arbiterLoopState is (state_updateRomAddr, state_presentData);
		variable currState: type_arbiterLoopState := state_updateRomAddr;
	begin
		if rising_edge(clk) then
		
			if reset = '1' or not(isSetup) then
				if(numPorts >= 2) then
					currPortIndex_A := 0;
					currPortIndex_B := 1;
				else
					currPortIndex_A := 0;
					currPortIndex_B := 0;
				end if;
				
				prevCurrPortIndex_A := currPortIndex_A;
				prevCurrPortIndex_B := currPortIndex_B;
				
				isSetup := true;
			else
				case currState is
					when state_updateRomAddr =>
						
						-- Turn off data waiting
						outPortArray(prevCurrPortIndex_A).dataWaiting <= false;
						outPortArray(prevCurrPortIndex_B).dataWaiting <= false;
						
						-- Update address
						romAddr_A <= inPortArray(currPortIndex_A).addr;
						romAddr_B <= inPortArray(currPortIndex_B).addr;
						
						-- Change State
						currState := state_presentData;
						
					when state_presentData =>
						outPortArray(currPortIndex_A).data <= rowData_A;
						outPortArray(currPortIndex_B).data <= rowData_B;
						
						-- Data waiting
						outPortArray(currPortIndex_A).dataWaiting <= true;
						outPortArray(currPortIndex_B).dataWaiting <= true;
						
						-- Store previous state so we can turn off data waiting later
						prevCurrPortIndex_A := currPortIndex_A;
						prevCurrPortIndex_B := currPortIndex_B;
						
						
						if(numPorts >= 2) then
							-- Jump ahead 2 because we have dual port ram
							currPortIndex_A := currPortIndex_A + 2;
							if currPortIndex_A > inPortArray'length-2 then
								currPortIndex_A := 0;
							end if;
							-- We want to be one ahead of A
							currPortIndex_B := currPortIndex_A + 1;
						else
							currPortIndex_A := 0;
							currPortIndex_B := 0;
						end if;
						
						-- Change State
						currState := state_updateRomAddr;
				end case;
				
			end if;
				
		end if;
	end process;

end Behavioral;

