library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegistersTest is
end RegistersTest;

architecture behavior of RegistersTest is
  component Registers is
    port(
      Clock: in std_logic;
      Reset: in std_logic;
      DataIn: in std_logic_vector(15 downto 0);
      DataOut: out std_logic_vector(15 downto 0);
      Address: in std_logic_vector(2 downto 0);
      Enable: in std_logic;
      IsWrite: in std_logic
      );
  end component;

  signal Clock: std_logic := '0';
  signal Reset: std_logic := '1';
  signal DataIn: std_logic_vector(15 downto 0) := (others => '0');
  signal DataOut: std_logic_vector(15 downto 0) := (others => '0');
  signal Address: std_logic_vector(2 downto 0) := (others => '0');
  signal Enable: std_logic := '0';
  signal IsWrite: std_logic := '0';

  constant clk: time := 1 ns;

  begin
    unit: Registers port map(
      Reset => Reset,
      Clock => Clock,
      DataIn => DataIn,
      DataOut => DataOut,
      Address => Address,
      Enable => Enable,
      IsWrite => IsWrite
    );

    ClockProcess: process
    begin
      Clock <= '0';
      wait for clk/2;
      Clock <= '1';
      wait for clk/2;
    end process;

    MainProcess: process
    begin
      -- start simulation
      wait for clk*1;
      Reset <= '0';

      -- test write
      for i in 0 to 7 loop
        Address <= std_logic_vector(to_unsigned(i, 3));
        DataIn <= std_logic_vector(to_unsigned(i, 16));
        IsWrite <= '1';
        wait for clk*3;
        Enable <= '1';
        wait for clk;
        Enable <= '0';
      end loop;

      -- test read
      for i in 0 to 7 loop
        Address <= std_logic_vector(to_unsigned(i, 3));
        IsWrite <= '0';
        wait for clk*3;
        Enable <= '1';
        wait for clk;
        Enable <= '0';
      end loop;
      wait;
    end process;
end;
