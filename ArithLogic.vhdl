library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ArithLogic is
  port(
    Clock: in std_logic;
    Enable: in std_logic;
    AluOp: in std_logic_vector(3 downto 0);
    DataA: in std_logic_vector(15 downto 0);
    DataB: in std_logic_vector(15 downto 0);
    Immediate: in std_logic_vector(7 downto 0);
    Result: out std_logic_vector(15 downto 0)
  );
end ArithLogic;

architecture Behavioral of ArithLogic is
  signal ResultInternal: std_logic_vector(15 downto 0) := (others => '0');
begin
  process(Clock)
  begin
    if rising_edge(Clock) then
      case AluOp is
        when x"0" =>  -- LDL
          ResultInternal <= X"00" & Immediate(7 downto 0);
        when x"1" =>  -- LDH
          ResultInternal <= Immediate(7 downto 0) & X"00";
        when x"2" =>  -- ADD
          ResultInternal <= std_logic_vector(unsigned(dataa) + unsigned(datab));
        when X"3" =>  -- SUB
          ResultInternal <= std_logic_vector(unsigned(DataA) - unsigned(DataB));
        when X"4" =>  -- MUL
          ResultInternal <= std_logic_vector(unsigned(DataA) * unsigned(DataB));
        when X"5" =>  -- DIV
          ResultInternal <= std_logic_vector(unsigned(DataA) / unsigned(DataB));
        when X"6" =>  -- XOR
          ResultInternal <= std_logic_vector(unsigned(DataA) xor unsigned(DataB));
        when X"7" =>  -- OR
          ResultInternal <= std_logic_vector(unsigned(DataA) or unsigned(DataB));
        when X"8" =>  -- AND
          ResultInternal <= std_logic_vector(unsigned(DataA) and unsigned(DataB));
          -- JMP
        when others =>
          ResultInternal <= X"0000";
      end case;
    end if;
  end process;

  Result <= ResultInternal(15 downto 0);
end Behavioral;
