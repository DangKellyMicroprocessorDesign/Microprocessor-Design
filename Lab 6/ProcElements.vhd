
-- Developer  : Don Dang, Brigid Kelly
-- Project    : Lab 6
-- ProjectName: Single Cycle Processor
-- Filename   : ProcElements.vhd
-- Date       : 5/30/18
-- Class      : Microprocessor Designs
-- Instructor : Ken Rabold
-- Purpose    : 
--             Creating the Single Cycle Processor
--
-- Notes      : 
-- This excercise is developed using Questa Sim 
-- The starting files for this project is Processor.vhd and ProcElements.vhd
-- The ProcElements.vhd is the processor elements			
-- Developer	Date		Activities
-- DD		5/30/18 	Download lab 6 from Team DangKelly from Github


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BusMux2to1 is
	Port(	selector: in std_logic;
			In0, In1: in std_logic_vector(31 downto 0);
			Result: out std_logic_vector(31 downto 0) );
end entity BusMux2to1;

architecture selection of BusMux2to1 is
SIGNAL highz: STD_LOGIC_VECTOR(31 DOWNTO 0) := "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
begin
          WITH selector SELECT
		      Result <= In0 when '0',
			            In1 when '1',
                        highz when others;
end architecture selection;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control is
      Port(clk : in  STD_LOGIC;
           opcode : in  STD_LOGIC_VECTOR (6 downto 0);
           funct3  : in  STD_LOGIC_VECTOR (2 downto 0);
           funct7  : in  STD_LOGIC_VECTOR (6 downto 0);
           Branch : out  STD_LOGIC_VECTOR(1 downto 0);
           MemRead : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC;
           ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0);
           MemWrite : out  STD_LOGIC;
           ALUSrc : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC;
           ImmGen : out STD_LOGIC_VECTOR(1 downto 0));
end Control;

architecture Boss of Control is
begin
-- Add your code here

end Boss;


--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is
    Port(Reset: in std_logic;
	 Clock: in std_logic;
	 PCin: in std_logic_vector(31 downto 0);
	 PCout: out std_logic_vector(31 downto 0));
end entity ProgramCounter;

architecture executive of ProgramCounter is

SIGNAL lastcount : STD_LOGIC_VECTOR(31 DOWNTO 0);

SIGNAL nextcount : STD_LOGIC_VECTOR(31 DOWNTO 0);

begin
--adding code here
PCCount: process(Clock, Reset, PCin) IS -- Process takes these inputs to use

BEGIN
lastcount <= PCin;  
    
    IF rising_edge(clock) THEN
	nextcount <= PCin;  --On rising edge next gets PC+4
              
    END IF; 	

    IF RESET = '1' THEN
        lastcount <= X"00000000";
	nextcount <= X"00400000";
     END IF;  

PCout <= nextcount;  -- OUTPUT FOR NEXT
END PROCESS;

end executive;

--------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.A

entity ImmGen is 
	Port(   instype : in std_logic_vector(1 downto 0);
		    immgen_in : in std_logic_vector(31 downto 0);
	        immgen_out : out std_logic_logic_vector(31 downto 0) );
end ImmGen;

architecture SignExtender of Immgen is

SIGNAL immediate : STD_LOGIC_VECTOR(31 DOWNTO 0);


begin

  with instype select
	      immediate <=   
		                  		     		immgen_in(31) & "00000000000000000000" & immgen_in(30 downto 20)  when '00',  --I-TYPE
			                          "00000000000000000000" & immgen_in(31 downto 25) & immgen(11 downto 7)  when '01' , --S-TYPE
"0000000000000000000" & immgen_in(31) & immgen_in(7) & immgen_in(30 downto 25) & immgen_in(11 downto 8)& "0"  when '10',  -- B-TYPE
                                                                    immgen_in(31 downto 12) & "000000000000"  when others;-- U-TYPE
																
  immgen_out <= immediate;
					                                                                                                 
					 
END SignExtender;

  
  ---------------------------------------------------------
  
  
  
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.A

entity branchlogic is
	PORT( ctrlinput : std_logic_vector (1 downto 0);
	      zeroIn : std_logic;
		  output : std_logic);
		  
end branchlogic;

architecture brancher of branchlogic is

begin
with ctrlinput & zeroIn select
			output <= '0' when '111' or '010', 
			          '1' when '110' or '011',
					  '0' when others;
					  
end ctrlinput;

















