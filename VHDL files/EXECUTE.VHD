--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

use work.pack.all;
ENTITY  Execute IS
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
END Execute;

ARCHITECTURE behavior OF Execute IS
--SIGNAL Ainput, Binput 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL ALU_output_mux		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL Branch_Add 			: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
SIGNAL ALU_ctl				: STD_LOGIC;
SIGNAL shift_res			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL Function_opcode		: STD_LOGIC_VECTOR( 5 DOWNTO 0 );
SIGNAL shamt				: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
SIGNAL Spec_opcode			: STD_LOGIC_VECTOR( 5 DOWNTO 0 );
SIGNAL zerot				: STD_LOGIC;
SIGNAL multres				: STD_LOGIC_VECTOR (63 DOWNTO 0);


BEGIN
	shf: Shifter port map (shamt,Binput,Function_opcode(1),shift_res);
	multres <= Ainput * Binput;
	
	RegDestmux <= Instruction(15 DOWNTO 11) when RegDst ='1'
	ELSE "11111" WHEN Spec_opcode = "000011"
	ELSE Instruction(20 DOWNTO 16);
	
	EX_Instruct <= Instruction;
	
	Ainput <= Read_data_1;
	Binput <= Read_data_2 WHEN (ALUSrc = '0') ELSE Sign_extend(31 DOWNTO 0);
		
	Spec_opcode 	<= Instruction( 31 DOWNTO 26 );	
	Function_opcode <= Instruction( 5 DOWNTO 0 );
	shamt 			<= Instruction( 10 DOWNTO 6 );
	
	
	
	
	
	Zero <= '1' WHEN (ALU_output_mux(31 DOWNTO 0)= X"00000000")  ELSE '0';
	JB  <= not Zero when Spec_opcode = "000101" ELSE
	'1' when Spec_opcode = "000010" 
	or Spec_opcode = "000011" 
	or (Instruction(31 DOWNTO 26)="000000" and Instruction(5 DOWNTO 0)="001000") ELSE
	Zero;
	
	ALU_ctl <= '1' when (Spec_opcode = "000000" and Function_opcode = "101010") or Spec_opcode = "001010" else '0';
	ALU_result <= X"0000000"&"000"&ALU_output_mux(31) WHEN  ALU_ctl = '1' ELSE ALU_output_mux(31 DOWNTO 0);
	
	
	Branch_Add	<= PC_plus_4( 9 DOWNTO 2 ) +  Sign_extend( 7 DOWNTO 0 ) ;
	Add_result 	<= "00"&Ainput(7 DOWNTO 2) when ((Instruction(31 DOWNTO 26) = "000000") and (Instruction(5 DOWNTO 0) = "001000"))
	else Branch_Add( 7 DOWNTO 0 ) ;
	
	
  PROCESS ( Spec_opcode,Function_opcode, Ainput, Binput,shift_res)
	BEGIN
 	CASE Spec_opcode IS
		WHEN "011100"	=>	ALU_output_mux 	<= multres(31 DOWNTO 0);msg<="mult ";
		WHEN "001000"	=>	ALU_output_mux 	<= Ainput + Binput; 	msg<="addi ";
		WHEN "001100"	=>	ALU_output_mux 	<= Ainput and Binput;	msg<="andi ";
		WHEN "001101"	=>	ALU_output_mux 	<= Ainput or Binput;	msg<="ori  ";
		WHEN "001110"	=>	ALU_output_mux 	<= Ainput xor Binput;	msg<="xori ";
		WHEN "001010"	=>	ALU_output_mux 	<= Ainput -	 Binput;	msg<="slti ";
		WHEN "000100"	=>	ALU_output_mux 	<= Ainput -	 Binput;	msg<="beq  ";
		WHEN "000101"	=>	ALU_output_mux 	<= Ainput -	 Binput;	msg<="bne  ";
 	 	WHEN "000010"	=>										    msg<="jump ";
		WHEN "000011"	=>	ALU_output_mux  <=X"00000"&"00"&PC_plus_4;	msg<="jal  ";
		WHEN "000000"	=>
			CASE Function_opcode IS 
				WHEN "100000" => ALU_output_mux <= Ainput + Binput;		msg<="add  ";
				WHEN "100010" => ALU_output_mux <= Ainput - Binput;		msg<="sub  ";
				WHEN "100100" => ALU_output_mux <= Ainput and Binput;	msg<="and  ";
				WHEN "100101" => ALU_output_mux <= Ainput or Binput; 	msg<="or   ";
				WHEN "100110" => ALU_output_mux <= Ainput xor Binput;	msg<="xor  ";
				WHEN "101010" => ALU_output_mux <= Ainput - Binput;   	msg<="slt  ";
				WHEN "100001" => ALU_output_mux <= Binput;	  		  	msg<="move ";
				WHEN "000000" => ALU_output_mux <= shift_res;	  		msg<="sll  ";
				WHEN "000010" => ALU_output_mux <= shift_res;	  		msg<="srl  ";
				WHEN "001000" => 										msg<="jr   ";
				WHEN OTHERS	=>	ALU_output_mux 	<= X"ZZZZZZZZ" ;		msg<="zzzz ";
			end case;
		WHEN "001111" => ALU_output_mux <= Binput(15 DOWNTO 0)&X"0000"; msg<="lui  ";
		WHEN "100011" => ALU_output_mux <= Ainput + Binput;	  		  	msg<="load ";
		WHEN "101011" => ALU_output_mux <= Ainput + Binput;	  		  	msg<="store";
		WHEN OTHERS	=>	ALU_output_mux 	<= X"ZZZZZZZZ" ;
  	END CASE;
  END PROCESS;
  
END behavior;

