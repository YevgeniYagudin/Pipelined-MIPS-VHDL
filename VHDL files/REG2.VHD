library IEEE;
use IEEE.std_logic_1164.all;

entity Bit2Register is
port (
  clk : in std_logic;
  reset : in std_logic;
  en : in std_logic;
  dataIn : in std_logic_vector(1 downto 0);
  dataOut : out std_logic_vector(1 downto 0)
);
end Bit2Register;

architecture Behavioral of Bit2Register is
begin
  process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        dataOut <= (others => '0');
      elsif en = '1' then
        dataOut <= dataIn;
      end if;
    end if;
  end process;
end Behavioral;