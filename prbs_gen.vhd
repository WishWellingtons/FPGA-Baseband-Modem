----------------------------------------------------------------------------------
-- Company: 
-- Engineer: William Morris
-- 
-- Create Date: 17.12.2025 22:39:07
-- Design Name: 
-- Module Name: prbs_gen - RTL
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Pseudo-Random Bit Sequence Generator 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity prbs_gen is
    port ( 
        clk       : in std_logic;
        rst       : in std_logic;
        ready_in  : in std_logic;
        valid_out : out std_logic;
        data_bit  : out std_logic
        );
end prbs_gen;

architecture RTL of prbs_gen is
    signal lfsr_reg : std_logic_vector(14 downto 0);

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                --load seed (must be non-zero)
                --set bit 0 to 1 and the rest to 0
                lfsr_reg <= (0 => '1', others => '0');
                valid_out <= '0';
            elsif ready_in = '1' then
                --shift left and insert XOR result at bit 0
                lfsr_reg <= lfsr_reg(13 downto 0) & (lfsr_reg(14) xor lfsr_reg(13));
                
                --output valid as long as we aren't in reset
                valid_out <= '1';
            end if;
        end if;
    end process;
    
    --output assignments
    --connect top bit of register to output port
    data_bit <= lfsr_reg(14);
                

end RTL;
