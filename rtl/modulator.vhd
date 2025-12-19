----------------------------------------------------------------------------------
-- Company: 
-- Engineer: William Morris
-- 
-- Create Date: 19.12.2025 21:34:12
-- Design Name: 
-- Module Name: modulator - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.NUMERIC_STD.ALL;



entity modulator is
    Port (
        clk     : in std_logic;
        rst     : in std_logic;
        
        -- Input Interface (from PRBS)
        data_in     : in std_logic;  --the bit to transmit
        valid_in    : in std_logic; --check prbs output valid
        ready_out    : out std_logic; -- request new bit
        
        -- Output Interface (to filter)
        symbol_out : out signed(15 downto 0); -- Q1.14 fixed point output
        valid_out  : out std_logic            -- Provides valid sample
    );
end modulator;

architecture rtl of modulator is
    --Counter to track over-sampling ratio (OSR) of 10
    --Range 0 to 9 counts 10 total steps
    signal counter: integer range 0 to 9 := 0;
begin
    
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                counter <= 0;
                valid_out <= '0';
                symbol_out <= (others => '0');
                ready_out <= '0';
            else
                --1. Counter logic: counts 0 to 9 repeatedly
                if counter < 9 then
                    counter <= counter + 1;
                else
                    counter <= 0;
                end if;
                
                --2. Output logic
                if counter = 0 then
                    --symbol slot (cycle 1)
                    ready_out <= '1'; --request next bit from prbs
                    valid_out <= '1'; -- output is valid
                    
                    if valid_in = '1' then
                        if data_in = '0' then
                            --Bit 0 -> +1.0
                            symbol_out <= to_signed(16384, 16);
                        else
                            --Bit 1 -> -1.0
                            symbol_out <= to_signed(-16384, 16);
                        end if;
                    
                    else
                        --if prbs isn't ready, output 0
                        symbol_out <= (others => '0');
                    end if;
                    
                else
                    --zero stuffing slots (cycles 2-10)
                    ready_out <= '0'; --tell prbs to wait
                    valid_out <= '1'; --this zero IS valid
                    symbol_out <= to_signed(0,16);
                end if;
            end if;
        end if;
    end process;                
    
end rtl;
