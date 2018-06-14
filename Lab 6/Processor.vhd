
-- -- Developer  : Don Dang, Brigid Kelly
-- -- Project    : Lab 6
-- -- ProjectName: Single Cycle Processor
-- -- Filename   : Processor.vhd
-- -- Date       : 5/30/18
-- -- Class      : Microprocessor Designs
-- -- Instructor : Ken Rabold
-- -- Purpose    : 
-- --             Creating the Single Cycle Processor
-- --
-- -- Notes      : 
-- -- This excercise is developed using Questa Sim 
-- -- The starting files for this project is Processor.vhd and ProcElements.vhd
			
-- -- Developer	Date		Activities
-- -- DD		5/30/18 	Download lab 6 from Team DangKelly from Github


-- library IEEE;
-- use IEEE.STD_LOGIC_1164.ALL;
-- use IEEE.STD_LOGIC_ARITH.ALL;
-- use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- entity Processor is
    -- Port ( reset : in  std_logic;
	       -- clock : in  std_logic);
-- end Processor;

-- architecture holistic of Processor is
	-- component Control
   	     -- Port( clk : in  STD_LOGIC;
               -- opcode : in  STD_LOGIC_VECTOR (6 downto 0);
               -- funct3  : in  STD_LOGIC_VECTOR (2 downto 0);
               -- funct7  : in  STD_LOGIC_VECTOR (6 downto 0);
               -- Branch : out  STD_LOGIC_VECTOR(1 downto 0);
               -- MemRead : out  STD_LOGIC;
               -- MemtoReg : out  STD_LOGIC;
               -- ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0);
               -- MemWrite : out  STD_LOGIC;
               -- ALUSrc : out  STD_LOGIC;
               -- RegWrite : out  STD_LOGIC;
               -- ImmGen : out STD_LOGIC_VECTOR(1 downto 0));
	-- end component;

	-- component ALU
		-- Port(DataIn1: in std_logic_vector(31 downto 0);
		     -- DataIn2: in std_logic_vector(31 downto 0);
		     -- ALUCtrl: in std_logic_vector(4 downto 0);
		     -- Zero: out std_logic;
		     -- ALUResult: out std_logic_vector(31 downto 0) );
	-- end component;
	
	-- component Registers
	    -- Port(ReadReg1: in std_logic_vector(4 downto 0); 
                 -- ReadReg2: in std_logic_vector(4 downto 0); 
                 -- WriteReg: in std_logic_vector(4 downto 0);
		 -- WriteData: in std_logic_vector(31 downto 0);
		 -- WriteCmd: in std_logic;
		 -- ReadData1: out std_logic_vector(31 downto 0);
		 -- ReadData2: out std_logic_vector(31 downto 0));
	-- end component;

	-- component InstructionRAM
    	    -- Port(Reset:	  in std_logic;
		 -- Clock:	  in std_logic;
		 -- Address: in std_logic_vector(29 downto 0);
		 -- DataOut: out std_logic_vector(31 downto 0));
	-- end component;

	-- component RAM 
	    -- Port(Reset:	  in std_logic;
		 -- Clock:	  in std_logic;	 
		 -- OE:      in std_logic;
		 -- WE:      in std_logic;
		 -- Address: in std_logic_vector(29 downto 0);
		 -- DataIn:  in std_logic_vector(31 downto 0);
		 -- DataOut: out std_logic_vector(31 downto 0));
	-- end component;
	
	-- component BusMux2to1
		-- Port(selector: in std_logic;
		     -- In0, In1: in std_logic_vector(31 downto 0);
		     -- Result: out std_logic_vector(31 downto 0) );
	-- end component;
	
	-- component ProgramCounter
	    -- Port(Reset: in std_logic;
		 -- Clock: in std_logic;
		 -- PCin: in std_logic_vector(31 downto 0);
		 -- PCout: out std_logic_vector(31 downto 0));
	-- end component ProgramCounter;

	-- component adder_subtracter
		-- port(	datain_a: in std_logic_vector(31 downto 0);
			-- datain_b: in std_logic_vector(31 downto 0);
			-- add_sub: in std_logic;
			-- dataout: out std_logic_vector(31 downto 0);
			-- co: out std_logic);
	-- end component adder_subtracter;
	
	-- component ImmGen
		-- Port(instype : in std_logic_vector(1 downto 0);
			-- immgen_in : in std_logic_vector(31 downto 0);
			-- immgen_out : out std_logic_vector(31 downto 0) );
		-- end component Immgen;
			
	-- component branchlogic is
		-- PORT( ctrlinput : in std_logic_vector (1 downto 0);
		      -- zeroIn : in std_logic;
       		      -- output : out std_logic);
		  
	-- end component branchlogic;


	-- ------------------------------------
	-- --     PROGRAM COUNTER SIGNALS    --
	-- ------------------------------------
-- signal  PCout : std_logic_vector(31 downto 0);  --output of program counter to IM
-- --signal  PCplusFour : std_logic_vector(31 downto 0):= "00000000000000000000000000000100"; -- Signal for adding 4 to current instruction memory address
-- signal  PCAdderOut : std_logic_vector(31 downto 0);  --result of PC+4
-- signal  PCAddco : std_logic;  --Program counter adder carryout
-- signal  BNEout: std_logic;  --Branch logic output
-- signal  BranchAddOut: std_logic_vector(31 downto 0);  --  Signal out of add/sub for branch instructions
-- signal  BranchAddCarry: std_logic;

-- signal  PcMuxOut : std_logic_vector(31 downto 0);  -- Output from PC Mux

	-- -----------------------------------
	-- --   IMMEDIATE GENERATOR SIGNALS --
	-- -----------------------------------
-- signal ImmGenOut : std_logic_vector(31 downto 0);  --output of immediate generator
-- signal IMtoImmGen : std_logic_vector(31 downto 0);  -- Output from instruction memory to immediate generator

	-- ----------------------------------
	-- --  INSTRUCTION MEMORY SIGNAL  --
	-- ----------------------------------
-- signal IMOUT : std_logic_vector(31 downto 0);  --Output of instruction memory bank

	-- ----------------------------------
	-- --         REG32 SIGNALS        --
	-- ----------------------------------
-- signal RegDat1 : std_logic_vector(31 downto 0); -- Both signals are outputs from registers
-- signal RegDat2 : std_logic_vector(31 downto 0);  


	-- ----------------------------------
	-- --          ALU SIGNALS         --
	-- ----------------------------------
-- signal Mux2ALU : std_logic_vector(31 downto 0); -- Input to ALU
-- signal ALUOut  : std_logic_vector(31 downto 0); -- Output from ALU
-- signal ALUzero : std_logic;  -- Output from ALU zero detector

	-- ----------------------------------
	-- --     DATA MEMORY SIGNALS      --
	-- ----------------------------------
-- signal MemReadOut : std_logic_vector(31 downto 0);

-- signal MeMuxOut   : std_logic_vector(31 downto 0);

-- signal Acct30bit  : std_logic_vector(29 downto 0);  -- This is a special signal to account for proper addressing of memory


	-- ----------------------------------
	-- --    CONTROL BLOCK SIGNALS     --
	-- ----------------------------------
-- signal BranchCTRL   : std_logic_vector(1 downto 0);
-- signal MemReadCTRL  : std_logic;
-- signal MemToRegCTRL : std_logic;
-- signal ALUCTRLCTRL  : std_logic_vector(4 downto 0);
-- signal MemWriteCTRL : std_logic;
-- signal ALUSrcCTRL   : std_logic;
-- signal RegWriteCTRL : std_logic;
-- signal ImmGenCTRL   : std_logic_vector(1 downto 0);

-- begin

	-- -----------------------------------
	-- --    PROGRAM COUNTER MAPS       --
	-- -----------------------------------
	-- PC :         ProgramCounter   port map(reset, clock, PCMuxOut, PCout);
	-- PCAdder:     adder_subtracter  port map(PCout,  "00000000000000000000000000000100", '0', PCAdderOut, PCAddco);
	-- Branchadder: adder_subtracter port map(PCout, ImmGenOut, '0', BranchAddOut, BranchAddCarry);
	-- PCmux:       BusMux2To1       port map(BNEout, PCAdderOut,  BranchAddOut, PCMuxOut);	
        -- BranchOrNot: branchlogic      port map(BranchCTRL, ALUZero, BNEOut);

	-- ----------------------------------
	-- --  INSTRUCTION MEMORY MAP      --
	-- ----------------------------------
	-- IM :         InstructionRAM   port map(reset, clock, PCOut(31 downto 2), IMOUT);


	-- ----------------------------------
	-- --     CONTROL BLOCK MAP        --
	-- ----------------------------------
	-- CTRL :       Control          port map(clock, IMOUT(6 downto 0), IMOUT(14 downto 12), IMOUT(31 downto 25), BranchCTRL, MemReadCTRL, MemToRegCTRL,
														 -- ALUCTRLCTRL, MemWriteCTRL, ALUSrcCTRL, RegWriteCTRL, ImmGenCTRL);

	-- ---------------------------------
	-- --         REG32 MAPS          --
	-- ---------------------------------
	-- Reg32 :      Registers        port map(IMOUT(19 downto 15), IMOUT(24 downto 20), IMOUT(11 downto 7), MeMuxOut, RegWriteCTRL, RegDat1, RegDat2);
       
	-- RegMux:      BusMux2To1       port map(ALUSrcCTRL, RegDat2, ImmGenOut, Mux2ALU);

	-- ---------------------------------
	-- --        IMMGEN MAP           --
	-- ---------------------------------
	-- IGEN :       ImmGen           port map(ImmGenCTRL, IMOUT, ImmGenOut);

	-- --------------------------------
	-- --        ALU MAP             --
	-- --------------------------------
	-- TheALU :     ALU              port map(RegDat1, Mux2ALU, ALUCTRLCTRL, ALUZero, ALUOut);

	-- --------------------------------
	-- --    DATA MEMORY MAPS        --
	-- --------------------------------
	-- Acct30bit <= "0000" & ALUOUT(27 downto 2);
	
	-- DMEM :       RAM              port map(reset, clock, MemReadCTRL, MemWriteCTRL, Acct30bit, RegDat2, MemReadOut);

	-- MeMux :      BusMux2To1       port map(MemToRegCTRL, ALUOut, MemReadOut, MeMuxOut);

-- end holistic;

--------------------------------------------------------------------------------
--
-- LAB #6 - Processor 
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Processor is
    Port ( reset : in  std_logic;
	   clock : in  std_logic);
end Processor;

architecture holistic of Processor is
	component Control
   	     Port( clk : in  STD_LOGIC;
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
	end component;

	component ALU
		Port(DataIn1: in std_logic_vector(31 downto 0);
		     DataIn2: in std_logic_vector(31 downto 0);
		     ALUCtrl: in std_logic_vector(4 downto 0);
		     Zero: out std_logic;
		     ALUResult: out std_logic_vector(31 downto 0) );
	end component;
	
	component Registers
	    Port(ReadReg1: in std_logic_vector(4 downto 0); 
                 ReadReg2: in std_logic_vector(4 downto 0); 
                 WriteReg: in std_logic_vector(4 downto 0);
		 WriteData: in std_logic_vector(31 downto 0);
		 WriteCmd: in std_logic;
		 ReadData1: out std_logic_vector(31 downto 0);
		 ReadData2: out std_logic_vector(31 downto 0));
	end component;

	component InstructionRAM
    	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;

	component RAM 
	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;	 
		 OE:      in std_logic;
		 WE:      in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataIn:  in std_logic_vector(31 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;
	
	component BusMux2to1
		Port(selector: in std_logic;
		     In0, In1: in std_logic_vector(31 downto 0);
		     Result: out std_logic_vector(31 downto 0) );
	end component;
	
	component ProgramCounter
	    Port(Reset: in std_logic;
		 Clock: in std_logic;
		 PCin: in std_logic_vector(31 downto 0);
		 PCout: out std_logic_vector(31 downto 0));
	end component;

	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;


-- Program Counter Output
	signal PCOut       : std_logic_vector(31 downto 0);	-- Program Counter to Instruction Memory

	-- Adders signals
	signal AddOut1	   : std_logic_vector(31 downto 0);
	signal AddOut2	   : std_logic_vector(31 downto 0);
	signal c01, c02	   : std_logic;
	
	-- Intruction Memory Output
	signal instruction : std_logic_vector(31 downto 0); 	-- Instruction Memory to Control, Registers, ImmGen

	-- Control Output
	signal CtrlBranch  : std_logic_vector(1 downto 0);	-- Control to Branch (Eq | Not Eq)
	signal CtrlMemRead : std_logic;				-- Control to Data Memory
	signal CtrlMemtoReg: std_logic;				-- Control to Mux after Data Memory
	signal CtrlALUCtrl : std_logic_vector(4 downto 0);	-- Control to ALU
	signal CtrlMemWrite: std_logic;				-- Control to Data Memory
	signal CtrlALUSrc  : std_logic;				-- Control to Mux before ALU
	signal CtrlRegWrite: std_logic;				-- Control to Registers
	signal CtrlImmGen  : std_logic_vector(1 downto 0);	-- Control to ImmGen

	-- Registers Output
	signal ReadD1      : std_logic_vector(31 downto 0);	-- Registers to ALU
	signal ReadD2      : std_logic_vector(31 downto 0);	-- Registers to ALUMux, RAM

	-- Data Memory Output
	signal ReadD	   : std_logic_vector(31 downto 0);	-- 

	-- Muxes output
	signal ALUMuxOut   : std_logic_vector(31 downto 0);	-- Mux to ALU
	signal DMemMuxOut  : std_logic_vector(31 downto 0);	-- Mux to Register Write Data
	signal AddSumMuxOut: std_logic_vector(31 downto 0);	-- Mux to PC

	-- ALU output
	signal ALUResultOut: std_logic_vector(31 downto 0);
	signal ALUZero     : std_logic;
	signal BranchEqNot : std_logic;
	
	--ImmGen output
	signal ImmGenOut   : std_logic_vector(31 downto 0);    -- ImmGen to AddMux, ALUMux 
	
	signal finally : std_logic_vector(29 downto 0);
begin
	-- Add your code here
	-- TO DO: 1) write all internal in/out signals for components
        --        2) port map all signals
	-- Muxes
	ALUMux: BusMux2to1   port map(CtrlALUSrc, ReadD2, ImmGenOut, ALUMuxOut); -- ImmGen output goes into the missing port
	AddMux: BusMux2to1   port map(BranchEqNot, AddOut1, AddOut2, AddSumMuxOut);
	DMemMux: BusMux2to1  port map(CtrlMemtoReg, ALUResultOut, ReadD, DMemMuxOut);

	-- Adders
	PreAdder: adder_subtracter port map(PCOut, "00000000000000000000000000000100", '0', AddOut1, c01);
	AddSumAdder: adder_subtracter port map(PCOut, ImmGenOut, '0', AddOut2, c02); -- ImmGen output should be on missing spot

	-- Major components
	PC: ProgramCounter   port map(reset, clock, AddSumMuxOut, PCOut);

	IMEM: InstructionRAM port map(reset, clock, PCOut(31 downto 2), instruction);

	Ctrl: Control 	     port map(clock, instruction(6 downto 0), instruction(14 downto 12), instruction(31 downto 25), CtrlBranch, CtrlMemRead, CtrlMemtoReg, CtrlALUCtrl,CtrlMemWrite,CtrlALUSrc, CtrlRegWrite, CtrlImmGen);

	Regs: Registers      port map(instruction(19 downto 15), instruction(24 downto 20), instruction(11 downto 7), DMemMuxOut, CtrlRegWrite, ReadD1, ReadD2);

	ArithLU: ALU         port map(ReadD1, ALUMuxOut, CtrlALUCtrl, ALUZero, ALUResultOut);
	
	finally <= "0000"& ALUResultOut(27 downto 2);

	DMem: RAM	     port map(reset, clock, CtrlMemRead, CtrlMemWrite, finally, ReadD2, ReadD);

	with CtrlBranch & ALUZero select
	BranchEqNot <=   '1' when "101",
                         '1' when "010",
		         '0' when others;
	
	with CtrlImmGen & instruction(31) select
	ImmGenOut <=   "111111111111111111111" & instruction(30 downto 20) when "001",  --I_type
                       "000000000000000000000" & instruction(30 downto 20) when "000",  --I_type
		       "111111111111111111111" & instruction(30 downto 25) & instruction(11 downto 7) when "011",  --S_type
                       "000000000000000000000" & instruction(30 downto 25) & instruction(11 downto 7) when "010",  --S_type
		        "11111111111111111111" & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0' when "101", --B_type
                        "00000000000000000000" & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0' when "100", --B_type
			                   "1" & instruction(30 downto 12) & "000000000000" when "111", --U_type
                                           "0" & instruction(30 downto 12) & "000000000000" when "110", --U_type
            "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when others;
		-- "00000000000000000000000000000000" when others;
 
end holistic;
