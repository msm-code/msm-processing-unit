library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Ram is
  port(
    Clock: in std_logic;
    WriteEnable: in std_logic;
    Address: in std_logic_vector(15 downto 0);
    InData: in std_logic_vector(15 downto 0);
    OutData: out std_logic_vector(15 downto 0)
  );
end Ram;

architecture Behavioral of Ram is
  type MemoryStore is array (0 to 255) of std_logic_vector(15 downto 0);
  signal Memory: MemoryStore := (others => X"0000");
begin
  process(Clock)
  begin
    if rising_edge(Clock) then
      if WriteEnable = '1' then
        Memory(to_integer(unsigned(Address))) <= InData;
      else
        OutData <= Memory(to_integer(unsigned(Address)));
      end if;
    end if;
  end process;
end Behavioral;
