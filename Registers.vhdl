library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Registers is
  port(
    Clock: in std_logic;
    Reset: in std_logic;
    DataIn: in std_logic_vector(15 downto 0);
    DataOut: out std_logic_vector(15 downto 0);
    Address: in std_logic_vector(2 downto 0);
    Enable: in std_logic;
    IsWrite: in std_logic
  );
end Registers;

architecture Behavioral of Registers is
  type MemoryStore is array (0 to 7) of std_logic_vector(15 downto 0);
  signal Memory: MemoryStore := (others => X"0000");
begin
  process(Clock)
  begin
    if rising_edge(Clock) then
      if Reset = '1' then
        DataOut <= X"0000";
      elsif Enable = '1' then
        if IsWrite = '1' then
          DataOut <= X"0000";
        else
          DataOut <= Memory(to_integer(unsigned(Address)));
        end if;
      end if;
    end if;
  end process;

  process(Clock)
  begin
    if rising_edge(Clock) then
      if Reset = '1' then
        for i in Memory'range loop
          Memory(i) <= X"0000";
        end loop;
      elsif Enable = '1' then
        if IsWrite = '1' then
          Memory(to_integer(unsigned(Address))) <= DataIn;
        end if;
      end if;
    end if;
  end process;
end Behavioral;
