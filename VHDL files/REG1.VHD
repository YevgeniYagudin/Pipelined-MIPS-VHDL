library IEEE;
use IEEE.std_logic_1164.all;

entity Bit1Register is
port (
  clk : in std_logic;
  reset : in std_logic;
  en : in std_logic;
  dataIn : in std_logic;
  dataOut : out std_logic
);
end Bit1Register;

architecture Behavioral of Bit1Register is
begin
  process (clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        dataOut <= '0';
      elsif en = '1' then
        dataOut <= dataIn;
      end if;
    end if;
  end process;
end Behavioral;