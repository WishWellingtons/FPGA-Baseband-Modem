----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.12.2025 22:12:03
-- Design Name: 
-- Module Name: tb_prbs_gen - Behavioral
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


entity tb_prbs_gen is
-- empty - no ports for test bench
end tb_prbs_gen;

architecture sim of tb_prbs_gen is
    --1. Component Declaration:
    component prbs_gen
        port (
            clk         : in std_logic;
            rst         : in std_logic;
            ready_in    : in std_logic;
            valid_out   : out std_logic; 
            data_bit    : out std_logic
        );
    end component;
    
    --2. Signal Definitions: wires to connect to DUT
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal ready_in     : std_logic := '0';
    signal valid_out    : std_logic;
    signal data_bit     : std_logic;
    
    --clock period definition (100MHz = 10ns)
    constant CLK_PERIOD : time := 10ns;
    
begin
    --3. Instantiate the DUT
    uut: prbs_gen
    port map (
        clk         => clk,
        rst         => rst,
        ready_in    => ready_in,
        valid_out   => valid_out,
        data_bit    => data_bit
    );
    
    --4. Clock Process: Generate continuous clock pulse
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    --5. Stimulus Process
    stim_proc: process
    begin
        --Start in reset
        rst <= '1';
        ready_in <= '0';
        wait for 100ns; --hold reset for a bit
        --release reset
        rst <= '0';
        wait for CLK_PERIOD*2;
        --assert ready (start generation)
        ready_in <= '1';
        --run for a while to observe random bits
        wait for 2000ns;
        --test pause functionality
        ready_in <= '0';
        wait for 200ns;
        --resume
        ready_in <= '1';
        wait; --wait forever stops process
    end process;
        

end sim;
