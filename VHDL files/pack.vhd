LIBRARY ieee;
USE ieee.std_logic_1164.all;

package pack is



	COMPONENT MIPS IS
	PORT( 
		reset							: IN 	STD_LOGIC; 
		clock							: IN 	STD_LOGIC;
		ena								: IN 	STD_LOGIC;
--------------------------------------------------------------------------------
		PC								: OUT   STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		ID_Instruct						: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		read_data_1_out					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		read_data_2_out					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Regwrite_out					: OUT 	STD_LOGIC;	
--------------------------------------------------------------------------------	
		EX_Instruct						: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		ALU_result_out					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		EX_ALUAinput					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		EX_ALUBinput					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Zero_out						: OUT 	STD_LOGIC;
--------------------------------------------------------------------------------		
		DM_Instruct						: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Branch_out						: OUT 	STD_LOGIC;
		Memwrite_out					: OUT 	STD_LOGIC;
		write_data_out					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );		
		read_data						: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		MEM_Address						: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
--------------------------------------------------------------------------------		
		WB_Instruct						: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		RegwriteRRR						: out 	STD_LOGIC;
--------------------------------------------------------------------------------		
		CLKCNT							: out STD_LOGIC_VECTOR (15 downto 0);
		STCNT							: out STD_LOGIC_VECTOR (7 downto 0);
		FHCNT							: out STD_LOGIC_VECTOR (7 downto 0);
		BPADD							: in STD_LOGIC_VECTOR (9 downto 0);
		STtrigger						: out STD_LOGIC
--------------------------------------------------------------------------------		
--		IF_Instruct						: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
--		flush 							: out 	STD_LOGIC;
--		stall 							: out 	STD_LOGIC;
--		IF_msg							: out 	string(1 to 5);
--		EX_msg							: out 	string(1 to 5);
		);

END COMPONENT;

	COMPONENT Ifetch
   	     PORT(	Instruction			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				InstructionRRR		: in	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				IF_msg				: out string (1 to 5);
        		PC_plus_4_out 		: OUT  	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        		Add_result 			: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
        		Branch 				: IN 	STD_LOGIC;
        		JB	 				: IN 	STD_LOGIC;
        		PC_out 				: OUT 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        		clock,reset,en 		: IN 	STD_LOGIC );
	END COMPONENT; 

	COMPONENT Idecode
 	     PORT(	read_data_1 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		read_data_2 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		Instruction 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				ID_Instruct 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		read_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		ALU_result 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		RegWrite, MemtoReg 	: IN 	STD_LOGIC;
				WrRegAddr			: in 	std_logic_vector(4 DOWNTO 0);
        		Sign_extend 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		clock, reset		: IN 	STD_LOGIC );
	END COMPONENT;

	COMPONENT control
	     PORT( 	Instruction 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
             	RegDst 				: OUT 	STD_LOGIC;
             	ALUSrc 				: OUT 	STD_LOGIC;
             	MemtoReg 			: OUT 	STD_LOGIC;
             	RegWrite 			: OUT 	STD_LOGIC;
             	MemRead 			: OUT 	STD_LOGIC;
             	MemWrite 			: OUT 	STD_LOGIC;
             	Branch 				: OUT 	STD_LOGIC;
             	clock, reset		: IN 	STD_LOGIC );
	END COMPONENT;

	COMPONENT  Execute
	PORT(	Read_data_1 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Read_data_2 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Sign_extend 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Instruction		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			EX_Instruct		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALUSrc 			: IN 	STD_LOGIC;
			RegDst			: in 	STD_LOGIC;
			Zero 			: OUT	STD_LOGIC;
			JB	 			: OUT	STD_LOGIC;
			Ainput			: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Binput			: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALU_Result 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Add_Result 		: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			PC_plus_4 		: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			RegDestmux		: OUT	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			clock, reset	: IN 	STD_LOGIC;
			msg				: out string(1 to 5));
	END COMPONENT;


	COMPONENT dmemory
	     PORT(	read_data 			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		address 			: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
        		write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		MemRead, Memwrite 	: IN 	STD_LOGIC;
        		Clock,reset			: IN 	STD_LOGIC );
	END COMPONENT;


COMPONENT Bit1Register is
port (
clk : in std_logic;
reset : in std_logic;
en : in std_logic;
dataIn : in std_logic;
dataOut : out std_logic);
end COMPONENT;

COMPONENT Bit5Register is
port (
clk : in std_logic;
reset : in std_logic;
en : in std_logic;
dataIn : in std_logic_vector(4 downto 0);
dataOut : out std_logic_vector(4 downto 0));
end COMPONENT;

COMPONENT Bit10Register is
port (
clk : in std_logic;
reset : in std_logic;
en : in std_logic;
dataIn : in std_logic_vector(9 downto 0);
dataOut : out std_logic_vector(9 downto 0));
end COMPONENT;	

COMPONENT Bit32Register is
port (
clk : in std_logic;
reset : in std_logic;
en : in std_logic;
dataIn : in std_logic_vector(31 downto 0);
dataOut : out std_logic_vector(31 downto 0));
end COMPONENT;

COMPONENT Bit8Register is
port (
clk : in std_logic;
reset : in std_logic;
en : in std_logic;
dataIn : in std_logic_vector(7 downto 0);
dataOut : out std_logic_vector(7 downto 0));
end COMPONENT;

COMPONENT Bit2Register is
port (
clk : in std_logic;
reset : in std_logic;
en : in std_logic;
dataIn : in std_logic_vector(1 downto 0);
dataOut : out std_logic_vector(1 downto 0));
end COMPONENT;

COMPONENT Shifter IS
  GENERIC (n : INTEGER := 32;
		   k : INTEGER := 5); --- k must be log2(n)		
  PORT (    
			x: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			y: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			dir: IN STD_LOGIC;
            --cout: OUT STD_LOGIC;
            s : OUT STD_LOGIC_VECTOR(31 downto 0));
END COMPONENT;


end pack;

