library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Decode is
  port(
    Clock: in std_logic;
    Enable: in std_logic;
    Instruction: in std_logic_vector(15 downto 0);
    AluOp: out std_logic_vector(3 downto 0);
    Immediate: out std_logic_vector(7 downto 0);
    RegSelA: out std_logic_vector(3 downto 0);
    RegSelB: out std_logic_vector(3 downto 0);
    RegSelO: out std_logic_vector(3 downto 0)
  );
end Decode;

architecture Behavioral of Decode is
begin
  process(Clock)
  begin
    if rising_edge(Clock) and Enable = '1' then
      AluOp <= Instruction(15 downto 12);
      RegSelO <= Instruction(11 downto 8);
      RegSelA <= Instruction(7 downto 4);
      RegSelB <= Instruction(3 downto 0);
      Immediate <= Instruction(7 downto 0);
    end if;
  end process;
end Behavioral;
