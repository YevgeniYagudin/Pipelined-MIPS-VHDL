				-- Top Level Structural Model for MIPS Processor Core
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.pack.all;

ENTITY MIPS IS

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
END 	MIPS;

ARCHITECTURE structure OF MIPS IS

	

					-- declare signals used to connect VHDL components
	SIGNAL PC_plus_4 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL PC_plus_4R 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL PC_plus_4RR 		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	
	SIGNAL read_data_1 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_1R 	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	SIGNAL read_data_2 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2R 	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2RR 	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	SIGNAL Sign_Extend 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_ExtendR 	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	SIGNAL Add_result 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL Add_resultR 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	
	SIGNAL ALU_result 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALU_resultR 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL ALU_resultRR 	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	--SIGNAL read_data 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_dataR 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	SIGNAL ALUSrc 			: STD_LOGIC;
	SIGNAL ALUSrcR 			: STD_LOGIC;
	
	SIGNAL Branch 			: STD_LOGIC;
	SIGNAL BranchR 			: STD_LOGIC;
	SIGNAL BranchRR 		: STD_LOGIC;
	
	SIGNAL RegDst 			: STD_LOGIC;
	SIGNAL RegDstR 			: STD_LOGIC;
	
	SIGNAL Regwrite 		: STD_LOGIC;
	SIGNAL RegwriteR 		: STD_LOGIC;
	SIGNAL RegwriteRR 		: STD_LOGIC;
	--SIGNAL RegwriteRRR 		: STD_LOGIC; --moved to "out"
	
	SIGNAL Zero 			: STD_LOGIC;
	
	SIGNAL JB	 			: STD_LOGIC;
	SIGNAL JBR	 			: STD_LOGIC;
	
	SIGNAL MemWrite 		: STD_LOGIC;
	SIGNAL MemWriteR 		: STD_LOGIC;
	SIGNAL MemWriteRR 		: STD_LOGIC;
	
	SIGNAL MemtoReg 		: STD_LOGIC;
	SIGNAL MemtoRegR 		: STD_LOGIC;
	SIGNAL MemtoRegRR 		: STD_LOGIC;
	SIGNAL MemtoRegRRR 		: STD_LOGIC;
	
	SIGNAL MemRead 			: STD_LOGIC;
	SIGNAL MemReadR			: STD_LOGIC;
	SIGNAL MemReadRR 		: STD_LOGIC;
	
	SIGNAL Instruction		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL InstructionR		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL InstructionRR	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL InstructionRRR	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL InstructionRRRR	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	signal RegDestmux		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	signal RegDestmuxR		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	signal RegDestmuxRR		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );

	SIGNAL fl			: STD_LOGIC;
	SIGNAL rstB2		: STD_LOGIC;
	SIGNAL enaB1		: STD_LOGIC;
	
	SIGNAL IF_Instruct						:  	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL flush 							:  	STD_LOGIC;
	SIGNAL stall 							:  	STD_LOGIC;
	SIGNAL IF_msg							:  	string(1 to 5);
	SIGNAL EX_msg							:  	string(1 to 5);	

BEGIN

	process 
	begin
		wait until rising_edge(clock);
		if reset = '1' then
			CLKCNT <= x"0000";
			STCNT <= x"00";
			FHCNT <=  x"00";
		else
			CLKCNT <= CLKCNT + 1 when STtrigger='0';
			STCNT  <= STCNT  + 1 when stall = '0' and STtrigger='0';
			FHCNT  <= FHCNT  + 1 when fl = '1';
		end if;
	end process;

	process (clock)
	begin
		if (PC = BPADD) then
			STtrigger <= '1';
		else
			STtrigger <= '0';
		end if;
	end process;
	
	
	fl <= '1' WHEN (JBR and BranchRR) else '0';
	flush <= fl or reset;
					-- copy important signals to output pins for easy 
					-- display in Simulator
	IF_Instruct 		<= Instruction;
	DM_Instruct 		<= InstructionRRR;
	WB_Instruct 		<= InstructionRRRR;
	ALU_result_out 		<= ALU_result;
	read_data_1_out 	<= read_data_1;
	read_data_2_out 	<= read_data_2;
	write_data_out  	<= read_data WHEN MemtoReg = '1' ELSE ALU_result;
	Branch_out 		<= Branch;
	Zero_out 		<= Zero;
	RegWrite_out 	<= RegWrite;
	MemWrite_out 	<= MemWrite;
	MEM_Address		<= x"000000"&ALU_ResultR (9 DOWNTO 2);


--stall <= '0' when (  ---old version (bad)
--				InstructionR(25 DOWNTO 21)=RegDestmux or 		
--				InstructionR(25 DOWNTO 21)=RegDestmuxR or
--				InstructionR(25 DOWNTO 21)=RegDestmuxRR or  
--				InstructionR(20 DOWNTO 16)=RegDestmux or 
--				InstructionR(20 DOWNTO 16)=RegDestmuxR or
--				InstructionR(20 DOWNTO 16)=RegDestmuxRR) and
--				InstructionR(25 DOWNTO 21) /= "00000" and
--				InstructionR(20 DOWNTO 16) /= "00000"
--				else '1';				
							
stall <= '1' when (
				(InstructionR(25 DOWNTO 21)/=RegDestmux and 		
				InstructionR(25 DOWNTO 21)/=RegDestmuxR and
				InstructionR(25 DOWNTO 21)/=RegDestmuxRR and  
				InstructionR(20 DOWNTO 16)/=RegDestmux and 
				InstructionR(20 DOWNTO 16)/=RegDestmuxR and
				InstructionR(20 DOWNTO 16)/=RegDestmuxRR) or 
				(RegDestmux = "00000" and RegDestmuxR = "00000" and RegDestmuxRR = "00000" ))
				and (STtrigger='0') else '0';
			
	
	enaB1 <= stall ;
	rstB2 <= flush or not(stall);
----------------------------------------BUFFER #1---------------------------------------
	regPC41:Bit10Register PORT MAP (clock,flush,enaB1,PC_plus_4,PC_plus_4R);		--1
	regIR1: Bit32Register PORT MAP (clock,flush,enaB1,Instruction,InstructionR); 	--1
----------------------------------------BUFFER #2---------------------------------------
	regRW1 : Bit1Register PORT MAP (clock,rstB2,'1',RegWrite,RegWriteR); 			--2
	regBr1 : Bit1Register PORT MAP (clock,rstB2,'1',Branch,BranchR); 	  			--2
	regMR1:  Bit1Register PORT MAP (clock,rstB2,'1',MemRead,MemReadR);   			--2
	regM2R1: Bit1Register PORT MAP (clock,rstB2,'1',MemtoReg,MemtoRegR); 			--2
	regMW1:  Bit1Register PORT MAP (clock,rstB2,'1',MemWrite,MemWriteR); 			--2
	regDsR:  Bit1Register PORT MAP (clock,rstB2,'1',RegDst,RegDstR); 				--2
	regASR : Bit1Register PORT MAP (clock,rstB2,'1',ALUSrc,ALUSrcR); 				--2
	regPC42:Bit10Register PORT MAP (clock,rstB2,'1',PC_plus_4R,PC_plus_4RR); 		--2
	regRD1: Bit32Register PORT MAP (clock,rstB2,'1',read_data_1,read_data_1R);  	--2
	regRD2: Bit32Register PORT MAP (clock,rstB2,'1',read_data_2,read_data_2R);  	--2	
	regExt: Bit32Register PORT MAP (clock,rstB2,'1',Sign_extend,Sign_extendR);		--2	
	regIR2: Bit32Register PORT MAP (clock,rstB2,'1',InstructionR,InstructionRR); 	--2
----------------------------------------BUFFER #3---------------------------------------
	regRW2 : Bit1Register PORT MAP (clock,flush,'1',RegWriteR,RegWriteRR); 			--3
	regM2R2: Bit1Register PORT MAP (clock,flush,'1',MemtoRegR,MemtoRegRR); 			--3
	regBr2 : Bit1Register PORT MAP (clock,flush,'1',BranchR,BranchRR); 				--3
	regMR2:  Bit1Register PORT MAP (clock,flush,'1',MemReadR,MemReadRR); 			--3
	regMW2:  Bit1Register PORT MAP (clock,flush,'1',MemWriteR,MemWriteRR); 			--3
	regAdd : Bit8Register PORT MAP (clock,flush,'1',Add_result,Add_resultR); 		--3	
	regJBr : Bit1Register PORT MAP (clock,flush,'1',JB,JBR);						--3
	regARS1:Bit32Register PORT MAP (clock,flush,'1',ALU_result,ALU_resultR); 		--3
	regRD3: Bit32Register PORT MAP (clock,flush,'1',read_data_2R,read_data_2RR); 	--3
	regDMX1: Bit5Register PORT MAP (clock,flush,'1',RegDestmux,RegDestmuxR);		--3	
	regIR3: Bit32Register PORT MAP (clock,flush,'1',InstructionRR,InstructionRRR);	--3
----------------------------------------BUFFER #4---------------------------------------	
	regRW3 : Bit1Register PORT MAP (clock,reset,'1',RegWriteRR,RegWriteRRR);  		--4
	regM2R3: Bit1Register PORT MAP (clock,reset,'1',MemtoRegRR,MemtoRegRRR);  		--4	
	reg2WB :Bit32Register PORT MAP (clock,reset,'1',read_data,read_dataR);   		--4
	regARS2:Bit32Register PORT MAP (clock,reset,'1',ALU_resultR,ALU_resultRR); 		--4
	regDMX2: Bit5Register PORT MAP (clock,reset,'1',RegDestmuxR,RegDestmuxRR); 		--4	
	regIR4: Bit32Register PORT MAP (clock,reset,'1',InstructionRRR,InstructionRRRR);--4
----------------------------------------------------------------------------------------

  IFE : Ifetch
	PORT MAP (	Instruction 	=> Instruction,
				InstructionRRR	=> InstructionRRR,
				IF_msg			=> IF_msg,
    	    	PC_plus_4_out 	=> PC_plus_4,
				Add_result 		=> Add_resultR,
				Branch 			=> BranchRR,
				JB 				=> JBR,
				PC_out 			=> PC,        		
				clock 			=> clock,  
				reset 			=> reset,
				EN				=> reset or stall);

   ID : Idecode
   	PORT MAP (	read_data_1 	=> read_data_1,
        		read_data_2 	=> read_data_2,
        		Instruction 	=> InstructionR,
				ID_Instruct		=> ID_Instruct,
        		read_data 		=> read_dataR,
				ALU_result 		=> ALU_resultRR,
				RegWrite 		=> RegWriteRRR,
				MemtoReg 		=> MemtoRegRRR,
				WrRegAddr		=> RegDestmuxRR,
				Sign_extend 	=> Sign_extend,
        		clock 			=> clock,  
				reset 			=> reset );

   EXE:  Execute
   	PORT MAP (	Read_data_1 	=> read_data_1R,
             	Read_data_2 	=> read_data_2R,
				Sign_extend 	=> Sign_extendR,
                Instruction		=> InstructionRR,
				EX_Instruct		=> EX_Instruct,
				ALUSrc 			=> ALUSrcR,
				RegDst			=> RegDstR,
				Zero 			=> Zero,
				JB				=> JB,
				Ainput			=> EX_ALUAinput,
				Binput			=> EX_ALUBinput,
                ALU_Result		=> ALU_Result,
				Add_Result 		=> Add_Result,
				PC_plus_4		=> PC_plus_4RR,
				RegDestmux		=> RegDestmux,
                Clock			=> clock,
				Reset			=> reset,
				msg				=> EX_msg);

   CTL:   control
	PORT MAP ( 	Instruction 	=> InstructionR,
				RegDst 			=> RegDst,
				ALUSrc 			=> ALUSrc,
				MemtoReg 		=> MemtoReg,
				RegWrite 		=> RegWrite,
				MemRead 		=> MemRead,
				MemWrite 		=> MemWrite,
				Branch 			=> Branch,
                clock 			=> clock,
				reset 			=> reset );



   MEM:  dmemory
	PORT MAP (	read_data 		=> read_data,
				address 		=> ALU_ResultR (9 DOWNTO 2),--jump memory address by 4
				write_data 		=> read_data_2RR,  
				MemRead 		=> MemReadRR, 
				Memwrite 		=> MemWriteRR, 
                clock 			=> clock,  
				reset 			=> reset );
END structure;

