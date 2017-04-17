library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Control is
  port(
    Clock: in std_logic;
    State: out std_logic_vector(4 downto 0)
  );
end Control;

architecture Behavioral of Control is
  signal StateInternal: std_logic_vector(4 downto 0) := "00001";
begin
  process(Clock)
  begin
    if rising_edge(Clock) then
      case StateInternal is
        when "00001" =>
          StateInternal <= "00010";
        when "00010" =>
          StateInternal <= "00100";
        when "00100" =>
          StateInternal <= "01000";
        when "01000" =>
          StateInternal <= "10000";
        when others =>
          StateInternal <= "00001";
      end case;
    end if;
  end process;

  State <= StateInternal;
end Behavioral;
