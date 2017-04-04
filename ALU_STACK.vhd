----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2017 11:39:05
-- Design Name: 
-- Module Name: ALU_STACK - Behavioral
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

entity ALU_STACK is
  Port (Clk : in std_logic; 
        reset:in std_logic;   
        write_val:in std_logic; 
        input_buff:in std_logic_vector(7 downto 0);
        dat_complete:out std_logic;
        conv_complete:out std_logic;
        op_complete:out std_logic;
        ramo: out std_logic_vector(7 downto 0));
        
end ALU_STACK;

architecture Behavioral of ALU_STACK is
--require two stack components and two lists;



--two rams
type ram_t is array (0 to 255) of std_logic_vector(7 downto 0);
signal ram1 : ram_t:= (others=>(others=>'0'));
signal ram2 : ram_t:= (others =>(others => '0'));
signal stack : ram_t:= (others =>(others => '0'));
signal ram1_head:unsigned(7 downto 0):=(others=>'0');
signal ram2_head:unsigned(7 downto 0):=(others=>'0');
signal stack_head:unsigned(7 downto 0):=(others=>'1'); --intilize with ff
--ram operations
-- 0
-- 1
--     <-ram_head(+1 position to the current filled position
--it is always to be acccessed FIFO manner


--stack operations LIFO
--   0     
--   1
--   2       <-stack_head point
--NOTE statement don't get executed sequentially
-- while pushing elements, 1) increase stack_head point 2)add value
   --stack(to_integer(stack_head+1))<=input_buff;
   --stack_head<=stack_head+1;
-- while poping element    2)acess element   2)decrease stack_head point value
   --output_buffer<=stack(to_integer(stack_head));
   --stack_head<=stack_head-1;



--signal write_val:std_logic:='0';
signal data_complete: std_logic:='0'; --goes high when all data is available in ram1
signal conversion_complete: std_logic:='0';
signal computation_complete: std_logic:='0';
signal operation_complete: std_logic:='0';
--stack acess ports



signal tempo:std_logic_vector(7 downto 0);
signal final_result:std_logic_vector(7 downto 0);

--dummy infix notation  3+2

---

begin
   --ramo<=write_val & write_val & write_val & write_val & write_val & write_val & write_val & write_val ;
   --stack1:stack_m port map(Clk=>Clk,Enable=>Enable,Data_In=>Data_In,Data_Out=>Data_Out,stack_top=>stack_top,PUSH_barPOP=>PUSH_barPOP,Stack_Full=>Stack_Full,Stack_Empty=>Stack_Empty);          
    dat_complete<=data_complete;
    conv_complete<=conversion_complete;
    op_complete<=computation_complete;
   getvalues:process(Clk,write_val,data_complete,conversion_complete,computation_complete,operation_complete)   
      variable temp1:std_logic_vector(7 downto 0);
      variable temp2:std_logic_vector(7 downto 0);
      variable temp3:std_logic_vector(7 downto 0);
      variable temp4:std_logic_vector(7 downto 0);
      variable temp5:std_logic_vector(7 downto 0);
      variable temp6:signed (15 downto 0);
      variable op1:std_logic_vector(7 downto 0);
      variable op2:std_logic_vector(7 downto 0);
      variable result:signed (7 downto 0);
      begin
          
      if(rising_edge(Clk)) then
         
        if (data_complete='0') and (write_val='1') then
--      --get value into ram1
         
         
         
          ram1(to_integer(ram1_head))<=input_buff;
          ram1_head<=ram1_head+1; --new value of this evaluated at the end of process, avilable at next run 
          
          if(input_buff="00111101") then  --  "=" sign encountered, stop buffering value
            data_complete<='1';
            ram1_head<="00000000";
          end if;
   
            
         end if; --get values into ram1 from uart
         --convert infix to postfix --use stack and ram2
       
       ------------------------------------------------------------------------------
       
         if (data_complete='1' and conversion_complete='0') then
          temp1:=ram1(to_integer(ram1_head));   
          temp4:=stack(to_integer(stack_head)); --maintain a point to top of stack THIS IS NOT POP operation
          --debug
          
            if(temp1= "00101011" and temp4 /= "00101011") then          -- "+" sign & should not be on stack top
              if (stack_head="11111111") then --stack empty, push it to stack
               stack(to_integer(stack_head+1))<=temp1;
               stack_head<=stack_head+1;
               ram1_head<=ram1_head+1;
              elsif (temp4="00101101" or temp4="00101010" or temp4="00101111") then --  "-" "*" or "/"
               stack_head<=stack_head-1; --decrease stack head value
               ram2(to_integer(ram2_head))<=temp4;
               ram2_head<=ram2_head+1;
              end if; 
                              
            elsif(temp1= "00101101" and temp4 /= "00101101") then          -- "-" sign
              if (stack_head="11111111") then --stack empty, push it to stack
                stack(to_integer(stack_head+1))<=temp1;
                stack_head<=stack_head+1;
                ram1_head<=ram1_head+1;
              elsif (temp4="00101011" or temp4="00101010" or temp4="00101111") then --  "+" "*" or "/"
                stack_head<=stack_head-1; --decrease stack head value
                ram2(to_integer(ram2_head))<=temp4;
                ram2_head<=ram2_head+1;
              end if; 
           
              
            elsif(temp1= "00101010" and temp4 /= "00101010") then          -- "*" sign
              if (stack_head="11111111" or temp4="00101011" or temp4="00101101") then --stack empty,"+" or "-" at stack head=> push it to stack,increase ram1
                stack(to_integer(stack_head+1))<=temp1;
                stack_head<=stack_head+1;
                ram1_head<=ram1_head+1;
              elsif (temp4="00101111") then  --- "/" sign
                stack_head<=stack_head-1; --decrease stack head value
                ram2(to_integer(ram2_head))<=temp4;
                ram2_head<=ram2_head+1;   
              end if;   
            
              
            elsif(temp1= "00101111" and temp4 /= "00101111") then          -- "/" sign
              if (stack_head="11111111" or temp4="00101011" or temp4="00101101") then --stack empty, push it to stack
                 stack(to_integer(stack_head+1))<=temp1;
                 stack_head<=stack_head+1;
                 ram1_head<=ram1_head+1;
              elsif (temp4="00101010") then  --- "*" sign
                 stack_head<=stack_head-1; --decrease stack head value
                 ram2(to_integer(ram2_head))<=temp4;
                 ram2_head<=ram2_head+1;
              end if;   
             
            
            elsif(temp1="00111101") then   ----"=" sign pop all the remaning operator from stack into ram2
             if(stack_head /= "11111111") then
               temp2:=stack(to_integer(stack_head));
               stack_head<=stack_head-1;
               ram2(to_integer(ram2_head))<=temp2;
               ram2_head<=ram2_head+1;
             else --assert conversion complete       --------------conversion is complete
              ram2(to_integer(ram2_head))<="00111101";
              ram2_head<="00000000";
              conversion_complete<='1';
             end if; 
             
            else     --its a number, store it in ram2
             ram2(to_integer(ram2_head))<=std_logic_vector(unsigned(temp1)-48);
             ram2_head<=ram2_head+1;
             ram1_head<=ram1_head+1; 
           
            end if;
          
         
        end if;--infix conversion
     -----------------------------------------------------------------     
         --evaluate postfix operation
         if(conversion_complete='1' and computation_complete='0') then
           temp5:=ram2(to_integer(ram2_head));
          if(temp5="00101011" and operation_complete='0') then   -- "+" sign
           --pop operand 1 and 2 from stack
           op2:=stack(to_integer(stack_head));        --pop two elements from stack and adjust stack pointer accordingly
           op1:=stack(to_integer(stack_head-1));
           stack_head<=stack_head-2;                                                --perform operation NOTE : when doing in UART convert to numbers using interger (op1-ASCII("0"))
           result:=signed(op1)+signed(op2);
           operation_complete<='1';
             
         
          elsif (temp5="00101101" and operation_complete='0') then -- "-" sign
           --pop operand 1 and 2 from stack
                     op2:=stack(to_integer(stack_head));        --pop two elements from stack and adjust stack pointer accordingly
                     op1:=stack(to_integer(stack_head-1));
                     stack_head<=stack_head-2;                                                --perform operation NOTE : when doing in UART convert to numbers using interger (op1-ASCII("0"))
                     result:=signed(op1)-signed(op2);
                     operation_complete<='1';
          
          elsif (temp5="00101010" and operation_complete='0') then     -- "*" sign   
          --pop operand 1 and 2 from stack
                     op2:=stack(to_integer(stack_head));        --pop two elements from stack and adjust stack pointer accordingly
                     op1:=stack(to_integer(stack_head-1));
                     stack_head<=stack_head-2;                                                --perform operation NOTE : when doing in UART convert to numbers using interger (op1-ASCII("0"))
                     temp6:=signed(op1)*signed(op2);
                     result:=temp6(7 downto 0);
                     operation_complete<='1';
          
          elsif (temp5="00101111" and operation_complete='0') then      -- "/" sign
         --pop operand 1 and 2 from stack
                     op2:=stack(to_integer(stack_head));        --pop two elements from stack and adjust stack pointer accordingly
                     op1:=stack(to_integer(stack_head-1));
                     stack_head<=stack_head-2;                                                --perform operation NOTE : when doing in UART convert to numbers using interger (op1-ASCII("0"))
                     result:=signed(op1)/signed(op2);
                     operation_complete<='1'; 
          
          
          elsif (temp5="00101111") then   --"=" sign stop computation
            computation_complete<='1';
            ramo<=std_logic_vector(result+48); 
            
            
          elsif(operation_complete='1') then --to store result in stack
            operation_complete<='0';
            --push result into stack and increment ram2_head
            stack(to_integer(stack_head+1))<=std_logic_vector(result);
            stack_head<=stack_head+1;
            ram2_head<=ram2_head+1;
            
          
          elsif(operation_complete='0') then  --numbers
           stack(to_integer(stack_head+1))<=temp5;
           stack_head<=stack_head+1;
           ram2_head<=ram2_head+1;
          end if;
                
        --display ram2 contents
         -- if(ram2_head /= "00000000") then 
--          temp3:=ram2(to_integer(ram2_head));
--          ram2_head<=ram2_head+1;
--          ramo<=temp3; 
     --     end if;
      end if;--computation (evaluation)
-------------------------------------------------------------------------------
--send the result back by uart    
      if(computation_complete='1') then 
           computation_complete<='0';
           data_complete<='0';
           conversion_complete<='0';
                    
      end if; 
       
       
         
      end if; --clock edge condition
    end process;
    
    

 





    

end Behavioral;
