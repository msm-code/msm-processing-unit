library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Ram is
  port(
    Clock: in std_logic;
    Enabled: in std_logic;
    WriteEnable: in std_logic;
    Address: in std_logic_vector(15 downto 0);
    InData: in std_logic_vector(15 downto 0);
    OutData: out std_logic_vector(15 downto 0)
  );
end Ram;

architecture Behavioral of Ram is
  type MemoryStore is array (0 to 255) of std_logic_vector(15 downto 0);
  signal Memory: MemoryStore := (
    0 => X"0302", -- LDL A, 2
    1 => X"0401", -- LDL B, 1
    2 => X"2334", -- ADD A, B
    3 => X"0E02", -- JMP 02
    others => X"0000"
  );
begin
  process(Clock)
  begin
    if rising_edge(Clock) then
      if Enabled = '1' then
        if WriteEnable = '1' then
          Memory(to_integer(unsigned(Address(7 downto 0)))) <= InData;
        else
          OutData <= Memory(to_integer(unsigned(Address(7 downto 0))));
        end if;
      end if;
    end if;
  end process;
end Behavioral;
