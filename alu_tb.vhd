----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2017 10:48:04
-- Design Name: 
-- Module Name: file_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity file_tb is
--  Port ( );
end file_tb;

architecture Behavioral of file_tb is
component ALU_STACK 
  Port (Clk : in std_logic; 
        reset: in std_logic;
        write_val:in std_logic; 
        input_buff:in std_logic_vector(7 downto 0);
        dat_complete:out std_logic;
        conv_complete:out std_logic;
        op_complete:out std_logic;
        ramo: out std_logic_vector(7 downto 0));
end component;



signal Clk:std_logic :='0';



signal ramo:std_logic_vector(7 downto 0);
signal write_val:std_logic:='0';
signal reset:std_logic:='0';
signal dat_complete:std_logic:='0';
signal conv_complete:std_logic:='0';
signal op_complete:std_logic:='0';
signal input_buff:std_logic_vector(7 downto 0);
constant Clk_period : time := 10 ns;
begin 

 uut:ALU_STACK port map(Clk=>Clk,write_val=>write_val,input_buff=>input_buff,ramo=>ramo,dat_complete=>dat_complete,conv_complete=>conv_complete,op_complete=>op_complete,reset=>reset);
 
Clk_process :process
   begin
        Clk <= '0';
        wait for Clk_period/2;
        Clk <= '1';
        wait for Clk_period/2;
   end process;

 stim_proc: process
   begin 
      wait for Clk_period*3;
      
      --start here
--      Data_In<="00001001";
--      Enable<='1';
--      PUSH_barPOP<='1';
--      wait for Clk_period;
--      PUSH_barPOP<='0';
--      wait for Clk_period;
--      wait;
    
      
      
      input_buff<="00111000";
      write_val<='1';
      wait for Clk_period;
      input_buff<="00101111";
      wait for Clk_period;
      input_buff<="00110100";
      wait for Clk_period;
      input_buff<="00101010";
      wait for Clk_period;
      input_buff<="00110011";
      wait for Clk_period;
      input_buff<="00111101";
      wait for Clk_period;
      write_val<='0';
      
     wait for Clk_period*25;
     reset<='1';
     wait for Clk_period;
     reset<='0';
     wait for Clk_period;
     input_buff<="00001000";
     write_val<='1';
     wait for Clk_period;
     input_buff<="00101111";
     wait for Clk_period;
     input_buff<="00000100";
     wait for Clk_period;
     wait for Clk_period*25;
      
            
   end process;   
end Behavioral;
