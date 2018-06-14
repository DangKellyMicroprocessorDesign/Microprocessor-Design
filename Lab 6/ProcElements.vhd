
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
	--------------------------------------
        --       ALU CONTROL OUTPUT         --
        --------------------------------------
	ALUCtrl <= "00000" when opcode = "0110011"                        else         -- ADD/ADDI
	           "00100" when opcode = "0110011" and funct7 = "0100000" else         -- SUB
	           "00010" when opcode = "0110011" and funct3 = "111"     else         -- AND
		   "00011" when opcode = "0110011" and funct3 = "110"     else         -- OR
                   "00001" when opcode = "0110011" and funct3 = "001"     else         -- SLL
                   "01001" when opcode = "0110011" and funct3 = "101"     else         -- SRL 
                   "00000" when opcode = "0000011"                        else         -- LW
                   "00000" when opcode = "0100011"                        else         -- SW
	           "00100" when opcode = "1100011" and funct3 = "000"     else         -- BEQ
                   "00100" when opcode = "1100011" and funct3 = "001"     else         -- BNE
                   "00000" when opcode = "0110111"                        else         -- LUI
                   "00010" when opcode = "0010011" and funct3 = "000"     else         -- ANDI
	           "00011" when opcode = "0010011" and funct3 = "110"     else         -- ORI
	           "00001" when opcode = "0010011" and funct3 = "001"     else         -- SLLI
	           "01001" when opcode = "0010011" and funct3 = "101";                 -- SRLI

	----------------------------------------
	--         BRANCH LOGIC OUTPUT        --
	----------------------------------------
	Branch <= "01" when opcode = "110011" and funct3 = "000"  else	--BEQ
	          "11" when opcode = "110011" and funct3 = "001"  else  --BNE
	          "00";

	--------------------------------------
	--        MEMREAD OUTPUT            --
 	--------------------------------------
	
	MemRead <= '1' when opcode = "0000011" and funct3 = "101" else 
	           '0';

	--------------------------------------
	--        MEMTOREG OUTPUT           --
	--------------------------------------
	MemToReg <= '1' when opcode = "0000011" and funct3 = "101" else
		    '0';

	-------------------------------------
	--       MEMWRITE OUTPUT           --
	-------------------------------------
	
	MemWrite <= '1' when opcode = "0100011" and funct3 = "010" else
		    '0';
	-------------------------------------
	--         ALUSRC OUTPUT           --
	-------------------------------------
	ALUSrc <= '0' when opcode = "0110011" or opcode = "1100011" else -- R-type and B-type are the only times this is 0
		  '1';

	------------------------------------
	--        REGWRITE OUTPUT         --
	------------------------------------
	RegWrite <= '0' when opcode = "0100011" or opcode = "1100011" else -- Branch Type and Store word
		    '1';

	-----------------------------------
	--       IMMGEN OUTPUT           --
	-----------------------------------
	ImmGen <= "00" when opcode = "0010011" or opcode = "0000011" or opcode = "0010011" else -- I-Type 
                  "01" when opcode = "0100011" else                                             -- SW
		  "10" when opcode = "1100011" else                                             -- B-Type
		  "11";                                                                         -- Specifically LUI, but don't care when others  

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

PCCount: process(Clock, Reset) IS -- Process takes these inputs to use

BEGIN	
	IF RESET = '1' THEN
		PCout <= X"003FFFFC";	
	 ELSIF rising_edge(clock) THEN
	    PCout <= PCin;  --On rising edge next gets PC+4              
    END IF; 	
END PROCESS;

end executive;

--------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ImmGen is 
	Port(         instype : in std_logic_vector(1 downto 0);
		    immgen_in : in std_logic_vector(31 downto 0);
                   immgen_out : out std_logic_vector(31 downto 0) );
end ImmGen;

architecture SignExtender of Immgen is

SIGNAL immediate : STD_LOGIC_VECTOR(31 DOWNTO 0);


begin

  with instype select
	      immediate <=   
                                             immgen_in(31) & "00000000000000000000" & immgen_in(30 downto 20)  when "00",  --I-TYPE
                                    "00000000000000000000" & immgen_in(31 downto 25) & immgen_in(11 downto 7)  when "01" , --S-TYPE
"0000000000000000000" & immgen_in(31) & immgen_in(7) & immgen_in(30 downto 25) & immgen_in(11 downto 8)& "0"  when "10" , -- B-TYPE
                                                                    immgen_in(31 downto 12) & "000000000000"  when others;-- U-TYPE
																
  immgen_out <= immediate;
					                                                                                                 
					 
END SignExtender;

  
  ---------------------------------------------------------
  
  
  
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity branchlogic is
	PORT( ctrlinput : in std_logic_vector (1 downto 0);
	      zeroIn : in std_logic;
		  output : out std_logic);
		  
end branchlogic;

architecture brancher of branchlogic is
SIGNAL otpsig: std_logic;
begin
with ctrlinput & zeroIn select
			otpsig <=  '0' when "111",
                                   '0' when"010", 
			           '1' when "110",
                                   '1' when "011",
					  '0' when others;

output <= otpsig;
					  
end brancher;

















