		-- control module (implements MIPS control unit)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY control IS
   PORT( 	
	Instruction : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	RegDst 		: OUT 	STD_LOGIC;
	ALUSrc 		: OUT 	STD_LOGIC;
	MemtoReg 	: OUT 	STD_LOGIC;
	RegWrite 	: OUT 	STD_LOGIC;
	MemRead 		: OUT 	STD_LOGIC;
	MemWrite 	: OUT 	STD_LOGIC;
	Branch 		: OUT 	STD_LOGIC;
	clock, reset	: IN 	STD_LOGIC );

END control;

ARCHITECTURE behavior OF control IS

	SIGNAL  R_format, Lw, Sw, br,imALU ,jal,jmp,jr	: STD_LOGIC;
	SIGNAL Opcode: STD_LOGIC_VECTOR( 5 DOWNTO 0 );

BEGIN
    Opcode  <= Instruction( 31 DOWNTO 26 );
				-- Code to generate control signals using opcode bits
	R_format 	<=  '1'  WHEN  
				Opcode = "000000" or 
				Opcode = "011100" or
				Opcode = "001000" or		--addi
				Opcode = "001100" or		--andi
				Opcode = "001101" or		--ori
				Opcode = "001110" or		--xori
				Opcode = "001100" ELSE '0';
	
	Lw          <=  '1'  WHEN  Opcode = "100011"  ELSE '0';
 	Sw          <=  '1'  WHEN  Opcode = "101011"  ELSE '0';
	
	imALU 		<=  '1'	 WHEN
				Opcode = "001000" or		--addi
				Opcode = "001100" or		--andi
				Opcode = "001101" or		--ori
				Opcode = "001111" or		--lui
				Opcode = "001010" or		--slti 
				Opcode = "001110" ELSE '0';	--xori
				
	jal <= '1' when Opcode = "000011" else '0';
	jmp <= '1' when Opcode = "000010" else '0';
	jr  <= '1' when (Opcode = "000000" and Instruction(5 DOWNTO 0) = "001000") else '0';
   	br         <=  '1'  WHEN  Opcode = "000100" or Opcode = "000101" ELSE '0';
  	RegDst    	<=  R_format and not(imALU);
 	ALUSrc  	<=  Lw OR Sw OR imALU or jmp or jal;
	MemtoReg 	<=  Lw;
  	RegWrite 	<=  R_format OR Lw or imALU or jal;
  	MemRead 	<=  Lw;
   	MemWrite 	<=  Sw ; 
 	Branch      <=  br or jr or jal or jmp;
   END behavior;


