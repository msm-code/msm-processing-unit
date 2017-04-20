library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PcControl is
  port(
    Clock: in std_logic;
    ShouldBranch: in std_logic;
    SetPc: in std_logic_vector(15 downto 0);
    NewPc: out std_logic_vector(15 downto 0)
  );
end PcControl;

architecture Behavioral of PcControl is
  signal CurrentPc: std_logic_vector(15 downto 0) := X"0000";
begin
  process(Clock)
  begin
    if rising_edge(Clock) then
      case ShouldBranch is
        when '0' =>
          CurrentPc <= std_logic_vector(unsigned(CurrentPc) + 1);
        when '1' =>
          CurrentPc <= SetPc;
        when others =>
      end case;
    end if;
  end process;

  NewPc <= CurrentPc;
end Behavioral;
