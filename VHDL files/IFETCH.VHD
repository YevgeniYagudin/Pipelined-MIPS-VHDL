-- Ifetch module (provides the PC and instruction 
--memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY Ifetch IS
	PORT(	SIGNAL Instruction 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			SIGNAL InstructionRRR   : in	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			SIGNAL IF_msg			: out   string (1 to 5);
        	SIGNAL PC_plus_4_out 	: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	SIGNAL Add_result 		: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
        	SIGNAL Branch 			: IN 	STD_LOGIC;
        	SIGNAL JB 				: IN 	STD_LOGIC;
      		SIGNAL PC_out 			: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	SIGNAL clock, reset,en 	: IN 	STD_LOGIC);
END Ifetch;

ARCHITECTURE behavior OF Ifetch IS
	SIGNAL PC, PC_plus_4 	 : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL next_PC,prev_PC, Mem_Addr : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL Function_opcode		: STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	SIGNAL Spec_opcode			: STD_LOGIC_VECTOR( 5 DOWNTO 0 );
BEGIN
						--ROM for Instruction Memory
inst_memory: altsyncram
	
	GENERIC MAP (
		operation_mode => "ROM",
		width_a => 32,
		widthad_a => 8,
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "C:\TestPrograms\ModelSim\L1_Cache\asm_ver1\program.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		clock0     => clock,
		address_a 	=> Mem_Addr, 
		q_a 			=> Instruction );
		
		
		
					-- Instructions always start on word address - not byte
		PC(1 DOWNTO 0) <= "00";
					-- copy output signals - allows read inside module
		

		PC_out 			<=  PC;
		PC_plus_4_out 	<=  PC_plus_4;
  
		
		
		
						-- send address to inst. memory address register
		--Mem_Addr <= Next_PC when en = '1' else next_PC - 1 when en='0';
		--Mem_Addr <= Next_PC when en = '1' else prev_PC when en='0';
		--Mem_Addr <= Next_PC when en = '1';
		Mem_Addr <= Next_PC;
		
		PROCESS
		begin
			WAIT UNTIL rising_edge(clock) and en = '1';
			prev_PC <= Next_PC;
			--report "-----------"&to_string(prev_PC);
		end PROCESS;		
		
						-- Adder to increment PC by 4        
      	PC_plus_4( 9 DOWNTO 2 )  <= PC( 9 DOWNTO 2 ) + 1 when en = '1' else PC( 9 DOWNTO 2 );
       	PC_plus_4( 1 DOWNTO 0 )  <= "00";
						-- Mux to select Branch Address or PC + 4        
		Next_PC  <= X"00" WHEN Reset = '1' 
		else "00"&InstructionRRR(5 DOWNTO 0)   when  InstructionRRR(31 DOWNTO 26)="000011"
		else "00"&InstructionRRR(5 DOWNTO 0)   when  InstructionRRR(31 DOWNTO 26)="000010"
		--else InstructionRRR(25 DOWNTO 21) when (InstructionRRR(31 DOWNTO 26)="000000" and InstructionRRR(5 DOWNTO 0)="001000")
		else Add_result  WHEN ((Branch = '1')AND(JB = '1'))
		ELSE   PC_plus_4( 9 DOWNTO 2 );
			
		PROCESS
		begin
			WAIT UNTIL rising_edge(clock) AND Branch = '1';
			report "-----------------------------------------------JUMP OR BRANCH ? "&to_string((Branch = '1')AND(JB = '1'));
		end PROCESS;
			
	PROCESS
		BEGIN
			WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
			IF reset = '1' THEN
				   PC( 9 DOWNTO 2) <= "00000000" ;
			else 
				   PC( 9 DOWNTO 2 ) <= Next_PC;
			END IF;
	END PROCESS;
	
	Spec_opcode 	<= Instruction( 31 DOWNTO 26 );	
	Function_opcode <= Instruction( 5 DOWNTO 0 );
	PROCESS ( Spec_opcode,Function_opcode)
	BEGIN
 	CASE Spec_opcode IS
		WHEN "011100"	=>	IF_msg<="mult ";
		WHEN "001000"	=>	IF_msg<="addi ";
		WHEN "001100"	=>	IF_msg<="andi ";
		WHEN "001101"	=>	IF_msg<="ori  ";
		WHEN "001110"	=>	IF_msg<="xori ";
		WHEN "001010"	=>	IF_msg<="slti ";
		WHEN "000100"	=>	IF_msg<="beq  ";
		WHEN "000101"	=>	IF_msg<="bne  ";
 	 	WHEN "000010"	=>	IF_msg<="jump ";
		WHEN "000011"	=>	IF_msg<="jal  ";
		WHEN "000000"	=>
			CASE Function_opcode IS 
				WHEN "100000" => IF_msg<="add  ";
				WHEN "100010" => IF_msg<="sub  ";
				WHEN "100100" => IF_msg<="and  ";
				WHEN "100101" => IF_msg<="or   ";
				WHEN "100110" => IF_msg<="xor  ";
				WHEN "101010" => IF_msg<="slt  ";
				WHEN "100001" => IF_msg<="move ";
				WHEN "000000" => IF_msg<="sll  ";
				WHEN "000010" => IF_msg<="srl  ";
				WHEN "001000" => IF_msg<="j Reg";
				WHEN OTHERS	  => IF_msg<="zzzzz";
			end case;
		WHEN "001111" => IF_msg<="lui  ";
		WHEN "100011" => IF_msg<="load ";
		WHEN "101011" => IF_msg<="store";
		WHEN OTHERS	  => IF_msg<="zzzzz";
  	END CASE;
  END PROCESS;
	
	
	
	
	
END behavior;


