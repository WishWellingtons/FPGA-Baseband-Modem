----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.12.2025 21:55:27
-- Design Name: 
-- Module Name: tb_modulator - sim
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

entity tb_modulator is
--  Port ( );
end tb_modulator;

architecture sim of tb_modulator is

    --Component declarations
    component prbs_gen
        port (
            clk         : in std_logic;
            rst         : in std_logic;
            ready_in    : in std_logic;
            valid_out   : out std_logic;
            data_bit    : out std_logic
        );
    end component;
    
    component modulator
        port (
            clk         : in std_logic;
            rst         : in std_logic;
            data_in     : in std_logic;
            valid_in    : in std_logic;
            ready_out   : out std_logic;
            symbol_out  : out signed(15 downto 0);
            valid_out   : out std_logic
        );
    end component;
    
    --Signals to connect components
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    
    signal prbs_data    : std_logic;
    signal prbs_valid   : std_logic;
    signal mod_ready    : std_logic; --handshake signal
    
    signal mod_symbol   : signed(15 downto 0);
    signal mod_valid    : std_logic;
    
    constant CLK_PERIOD : time := 10ns; --100MHz clk freq
            
    

begin
    --1. Instantiate PRBS Generator
    u_prbs : prbs_gen
    port map (
        clk         => clk,
        rst         => rst,
        ready_in    => mod_ready, -- controlled by modulator
        valid_out   => prbs_valid,
        data_bit    => prbs_data
    );
    
    --2. Instantiate Modulator
    u_mod : modulator
    port map (
        clk         => clk,
        rst         => rst,
        data_in     => prbs_data, --FROM PRBS
        valid_in    => prbs_valid, --FROM PRBS 
        ready_out   => mod_ready, --TO PRBS
        symbol_out  => mod_symbol,
        valid_out   => mod_valid
    );
    
    --3. Clock Generation
    process 
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    --4. Test Stimulus
    process
    begin
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        
        --run for 2us to see multiple symbols
        wait for 2000 ns;
        
        std.env.finish;
    end process;      
    
end sim;
