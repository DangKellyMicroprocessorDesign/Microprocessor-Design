
-- Developer : Don Dang/Brigid Kelly
-- Project   : Lab 3
-- Filename  : Register.vhd
-- Date      : 4/30/18
-- Class     : Microprocessor Designs
-- Instructor: Ken Rabold
-- Purpose   : 
--             Create 8 bits register
--             Create 32 bits register on top of 8 bits register
--	       Implement component technnique along with GENERATE
--
-- Notes     : 
-- This excercise is developed using Questa Sim 
			
-- Developer	Date		Activities
-- DD		4/30/18 	Modify Register.vhd
--				Complete step 1: An 8 bit register called register8 from components of the memory cell in register.vhd
--        		 	Attempt to work on step 2. A 32 bit register called register 32 built from components of register8
-- KK		5/2/18		Add compenent to register32
-- DD		5/4/18		Add FullAdder and Shift Register sections
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity bitstorage is
	port(bitin: in std_logic;
		 enout: in std_logic;
		 writein: in std_logic;
		 bitout: out std_logic);
end entity bitstorage;

architecture memlike of bitstorage is
	signal q: std_logic := '0';
begin
	process(writein) is
	begin
		if (rising_edge(writein)) then
			q <= bitin;
		end if;
	end process;
	
	-- Note that data is output only when enout = 0	
	bitout <= q when enout = '0' else 'Z';
end architecture memlike;

--------------------------------------------------------------------------------
--This is the FullAdder
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity fulladder is
    port (a : in std_logic;
          b : in std_logic;
          cin : in std_logic;
          sum : out std_logic;
          carry : out std_logic
         );
end fulladder;

architecture addlike of fulladder is
begin
  sum   <= a xor b xor cin; 
  carry <= (a and b) or (a and cin) or (b and cin); 
end architecture addlike;


----------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register8 is
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
end entity register8;


architecture memmy of register8 is

	component bitstorage
		port(bitin: in std_logic;
		 	 enout: in std_logic;
		 	 writein: in std_logic;
		 	 bitout: out std_logic);

	end component;
begin


	m0: bitstorage port map(datain(0),enout,writein, dataout(0));
	m1: bitstorage port map(datain(1),enout,writein, dataout(1));
	m2: bitstorage port map(datain(2),enout,writein, dataout(2));
	m3: bitstorage port map(datain(3),enout,writein, dataout(3));
	m4: bitstorage port map(datain(4),enout,writein, dataout(4));
	m5: bitstorage port map(datain(5),enout,writein, dataout(5));
	m6: bitstorage port map(datain(6),enout,writein, dataout(6));
	m7: bitstorage port map(datain(7),enout,writein, dataout(7));
end architecture memmy;

--------------------------------------------------------------------------------
-- EnableOut: 
-- 0: Active     - Enable output data. Data out
-- 1: Not Active - Disable output data. No data out

-- WriteIn
-- 0: Not Active - Don't write in
-- 1: Active     - Allow write in
--
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register32 is
	port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
end entity register32;

architecture biggermem of register32 is

        signal w32, w16, w8 : STD_LOGIC :='0';
        signal out32, out16, out8 : STD_LOGIC :='1';

	component register8 is
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
	end component;
begin
  
        w8 <= writein8  OR writein16 OR writein32; -- 8 or 16 or 32. In any case 8bits will get written
        w16 <= writein16 OR writein32;              -- 16 or 32. In any case 16 bits
        w32 <= writein32;                           -- 32 bits

	out8 <= enout8 AND enout16 AND enout32;     
        out16 <= enout16 AND enout32;
        out32 <= enout32;



	m0: register8 port map(datain(7 downto 0),   out8,   w8,  dataout(7 downto 0));
	m1: register8 port map(datain(15 downto 8),  out16,  w16, dataout(15 downto 8));
	m2: register8 port map(datain(23 downto 16), out32,  w32, dataout(23 downto 16));
	m3: register8 port map(datain(31 downto 24), out32,  w32, dataout(31 downto 24));

end architecture biggermem;

--------

-----------------



-------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity adder_subtracter is
	port(	datain_a: in std_logic_vector(31 downto 0);
		datain_b: in std_logic_vector(31 downto 0);
		add_sub: in std_logic;
		dataout: out std_logic_vector(31 downto 0);
		co: out std_logic);
end entity adder_subtracter;

architecture calc of adder_subtracter is



	COMPONENT FULLADDER IS    	-- FullAdder Component Declaration
		port (a : in std_logic;
          	      b : in std_logic;
          	      cin : in std_logic;
          	      sum : out std_logic;
          	      carry : out std_logic);
	END COMPONENT;
			 
SIGNAL cOut: STD_LOGIC_VECTOR (31 downto 0);
SIGNAL subB: STD_LOGIC_VECTOR(31 DOWNTO 0);

begin
      with add_sub select
	   subB <= NOT datain_b when '1',
			datain_b when '0',
			"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" when others;

---------------------------GENERATE--------------------------------
	 FA0: FullAdder PORT MAP(datain_a(0),subB(0), add_sub, dataout(0), cOut(0));
F1:	 for i IN 1 TO 31 GENERATE
            FAi: FullAdder 
               PORT MAP (datain_a(i), subB(i),cOut(i-1),dataout(i), cOut(i));
            END GENERATE; 
            
co<=cOut(31);


end calc;



--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity shift_register is
	port( datain: in std_logic_vector(31 downto 0);
    		dir: in std_logic;
		shamt: in std_logic_vector(4 downto 0);
		dataout: out std_logic_vector(31 downto 0));
	end entity shift_register;

architecture shifter of shift_register is
begin

	with dir & shamt select
		dataout <= datain(30 downto 0) & "0" when "000001",         --shifting right by 1 when direction and shamt (shift amount) =  1
				datain(29 downto 0) & "00" when "000010", 
				datain(28 downto 0) & "000" when "000011", 
				"0" & datain(31 downto 1) when "100001",    --shifting left by 1 when direction and shamt = 
				"00" & datain(31 downto 2) when "100010", 
				"000" & datain(31 downto 3) when "100011",
				datain(31 downto 0) when others; 

end architecture shifter;


 