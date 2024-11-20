				-- Top Level Structural Model for MIPS Processor Core
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
use work.pack.all;
ENTITY MIPStb IS
	
END MIPStb;

ARCHITECTURE structure OF MIPStb IS

		signal reset: std_logic ;
		signal clock: std_logic:='1';
		signal ena: std_logic;
--------------------------------------------------------------------------------	
		signal PC:	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		signal ID_Instruct :STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		signal read_data_1_out:STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		signal read_data_2_out:STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		signal ID_Regwrite : STD_LOGIC;
--------------------------------------------------------------------------------		
		signal EX_Instruct :STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		signal ALU_result_out:STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		signal EX_ALUAinput: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		signal EX_ALUBinput: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		signal Zero_out:STD_LOGIC;
--------------------------------------------------------------------------------		
		signal DM_Instruct :STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		signal Branch_out:STD_LOGIC;
		signal Memwrite_out:STD_LOGIC;
		signal write_data_out:STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		signal MEM_read_data: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		signal MEM_Address: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
--------------------------------------------------------------------------------			
		signal WB_Instruct :STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		signal Regwrite_out:STD_LOGIC;
--------------------------------------------------------------------------------		
		signal CLKCNT: STD_LOGIC_VECTOR (15 downto 0);
		signal STCNT	:  STD_LOGIC_VECTOR (7 downto 0);
		signal FHCNT	:  STD_LOGIC_VECTOR (7 downto 0);
		signal BPADD:  STD_LOGIC_VECTOR (9 downto 0);
		signal STtrigger : STD_LOGIC;

		--signal Line_mars:	STD_LOGIC_VECTOR( 9 DOWNTO 0 );  	--not needed for now
		--signal IF_Instruct :STD_LOGIC_VECTOR( 31 DOWNTO 0 );	--not needed for now
		--signal flush: STD_LOGIC;								--not needed for now
		--signal stall: STD_LOGIC;								--not needed for now
		--signal IF_msg:string(1 to 5); 						--not needed for now
		--signal EX_msg:string(1 to 5);							--not needed for now
	--begin
	--L1: MIPS port map(reset,clock,PC,CLKCNT,STCNT,FHCNT,BPADD,STtrigger,ALU_result_out,read_data_1_out,read_data_2_out,
	--write_data_out,Branch_out,Zero_out,Memwrite_out,Regwrite_out,flush,stall,
	--IF_msg,EX_msg,IF_Instruct,ID_Instruct,EX_Instruct,DM_Instruct,WB_Instruct);
	
	
	begin
	L1: MIPS port map(reset,clock,ena,PC,ID_Instruct,read_data_1_out,read_data_2_out,ID_Regwrite,EX_Instruct,
	ALU_result_out,EX_ALUAinput,EX_ALUBinput,Zero_out,DM_Instruct,Branch_out,Memwrite_out,write_data_out,
	MEM_read_data,MEM_Address,WB_Instruct,Regwrite_out,CLKCNT,STCNT,FHCNT,BPADD,STtrigger);
	
	
	ena <= '1';
	BPADD <= "0100000000","0100100000" after 13 us;
	clock <= not clock after 50 ns;
	reset <= '1','0' after 150 ns;
	--Line_mars <= "00"&PC(9 DOWNTO 2) + 1;
END structure;

