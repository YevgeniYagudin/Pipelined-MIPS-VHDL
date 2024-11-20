LIBRARY ieee;
USE ieee.std_logic_1164.all;
-------------------------------------
ENTITY Shifter IS
  GENERIC (n : INTEGER := 32;
		   k : INTEGER := 5); --- k must be log2(n)		
  PORT (    
			x: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			y: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			dir: IN STD_LOGIC;
            --cout: OUT STD_LOGIC;
            s : OUT STD_LOGIC_VECTOR(31 downto 0));
END Shifter;

ARCHITECTURE shifterArch OF Shifter IS

		type MATRIX is array (0 to k - 1)  of STD_LOGIC_VECTOR (n - 1 downto 0);
		constant zeros : std_logic_vector (n-1 DOWNTO 0 ) := (others => '0');
        signal resMat: MATRIX;     -- log(n)Xn matrix
        signal carryVec : std_logic_vector (0 to k - 1);

		
begin
		--------------------------first colum ---------------------------------------------------------
        resMat(0) <= y(n - 2 downto 0) & zeros(0) when (x(0)= '1' and dir ='0') else
                                zeros(0) & y(n - 1 downto 1)  when (x(0)= '1' and dir = '1') else
                                y;

        carryVec(0) <= y( n - 1 )  when (x(0)= '1' and dir ='0') else
                                y(0) when (x(0)= '1' and dir = '1') else
                                '0';
		--------------------------shift iterations-------------------------------------------------------
		loopi : for i in 1 to k - 1 generate
		
				resMAT(i) <= resMAT(i-1)(n-2**i - 1  downto 0) & zeros( 2**i - 1 downto 0 )  when (x(i)= '1' and dir ='0') else
						zeros(2**i - 1 downto 0) & resMAT(i-1)(n-1 downto 2**i)  when (x(i)= '1' and dir ='1') else
								resMAT(i-1);
				
				
                carryVec(i) <=  resMat(i-1)( n - 2**i )  when (x(i)= '1' and dir ='0') else
							resMat(i-1)( 2**i - 1) when (x(i)= '1' and dir = '1') else
								carryVec(i-1);
		end generate;
		-------------------------- output ----------------------------------------------------------
		s  <= resMat(k - 1) when dir = '0' or dir = '1'  else (others => '0');
        --cout <= carryVec(k - 1) when dir = '0' or dir = '1'  else '0';
		-----------------------------------------------------------------------------------------------
END shifterArch;