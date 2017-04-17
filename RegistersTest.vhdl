library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegistersTest is
end RegistersTest;

architecture behavior of RegistersTest is
  component Registers is
    port(
      Clock: in std_logic;
      Enable: in std_logic;
      RegSelA: in std_logic_vector(3 downto 0);
      RegSelB: in std_logic_vector(3 downto 0);
      RegSelO: in std_logic_vector(3 downto 0);
      DataA: out std_logic_vector(15 downto 0);
      DataB: out std_logic_vector(15 downto 0);
      DataO: in std_logic_vector(15 downto 0);
      WriteEnable: in std_logic
    );
  end component;

  signal Clock: std_logic := '0';
  signal Enable: std_logic := '1';
  signal RegSelA: std_logic_vector(3 downto 0) := (others => '0');
  signal RegSelB: std_logic_vector(3 downto 0) := (others => '0');
  signal RegSelO: std_logic_vector(3 downto 0) := (others => '0');
  signal DataA: std_logic_vector(15 downto 0) := (others => '0');
  signal DataB: std_logic_vector(15 downto 0) := (others => '0');
  signal DataO: std_logic_vector(15 downto 0) := (others => '0');
  signal WriteEnable: std_logic := '0';

  constant clk: time := 1 ns;

  begin
    unit: Registers port map(
      Clock => Clock,
      Enable => Enable,
      RegSelA => RegSelA,
      RegSelB => RegSelB,
      RegSelO => RegSelO,
      DataA => DataA,
      DataB => DataB,
      DataO => DataO,
      WriteEnable => WriteEnable
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
      -- test write
      Enable <= '1';
      WriteEnable <= '1';
      for i in 0 to 7 loop
        RegSelO <= std_logic_vector(to_unsigned(i, 4));
        DataO <= std_logic_vector(to_unsigned(i, 16));
        wait for clk;
      end loop;

      -- test read
      Enable <= '1';
      WriteEnable <= '0';
      for i in 0 to 3 loop
        RegSelA <= std_logic_vector(to_unsigned(i*2+0, 4));
        RegSelB <= std_logic_vector(to_unsigned(i*2+1, 4));
        wait for clk;
      end loop;
      wait;
    end process;
end;
