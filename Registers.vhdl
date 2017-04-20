library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Registers is
  port(
    Clock: in std_logic;
    Enable: in std_logic;
    WriteEnable: in std_logic;
    RegSelA: in std_logic_vector(3 downto 0);
    RegSelB: in std_logic_vector(3 downto 0);
    RegSelO: in std_logic_vector(3 downto 0);
    DataO: in std_logic_vector(15 downto 0);
    DataA: out std_logic_vector(15 downto 0);
    DataB: out std_logic_vector(15 downto 0);
    Pc: out std_logic_vector(15 downto 0)
  );
end Registers;

architecture Behavioral of Registers is
  type MemoryStore is array (0 to 15) of std_logic_vector(15 downto 0);
  signal Memory: MemoryStore := (others => X"0000");
begin
  process(Clock)
  begin
    if rising_edge(Clock) then
      if Enable = '1' then
        if WriteEnable = '1' then
          Memory(to_integer(unsigned(RegSelO))) <= DataO;
          -- tiny hack - assumes 1 write/cycle
          if unsigned(RegSelO) /= 14 then
            Memory(14) <= std_logic_vector(unsigned(Memory(14)) + 1);
          end if;
        end if;
        DataA <= Memory(to_integer(unsigned(RegSelA)));
        DataB <= Memory(to_integer(unsigned(RegSelB)));
        Pc <= Memory(14);
      end if;
    end if;
  end process;
end Behavioral;
