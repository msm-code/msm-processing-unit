library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ControlTest is
end ControlTest;

architecture behavior of ControlTest is
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

  component Decode is
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
  end component;

  component ArithLogic is
    port(
      Clock: in std_logic;
      Enable: in std_logic;
      AluOp: in std_logic_vector(3 downto 0);
      DataA: in std_logic_vector(15 downto 0);
      DataB: in std_logic_vector(15 downto 0);
      Immediate: in std_logic_vector(7 downto 0);
      Result: out std_logic_vector(15 downto 0)
    );
  end component;

  component Control is
    port(
      Clock: in std_logic;
      State: out std_logic_vector(4 downto 0)
    );
  end component;

  component Ram is
    port(
      Clock: in std_logic;
      WriteEnable: in std_logic;
      Address: in std_logic_vector(15 downto 0);
      InData: in std_logic_vector(15 downto 0);
      OutData: out std_logic_vector(15 downto 0)
    );
  end component;

  signal Clock: std_logic := '0';
  signal EnableFetch: std_logic := '0';
  signal EnableDecoder: std_logic := '0';
  signal EnableRegRead: std_logic := '0';
  signal EnableRegWrite: std_logic := '0';
  signal EnableArith: std_logic := '0';
  signal EnableRegAny: std_logic := '0';
  signal EnableAnyRegWrite: std_logic := '0';
  signal RamWriteEnable: std_logic := '0';
  signal RamAddress: std_logic_vector(15 downto 0) := (others => '0');
  signal RamInData: std_logic_vector(15 downto 0) := (others => '0');
  signal RamOutData: std_logic_vector(15 downto 0) := (others => '0');
  signal ProgCounter: std_logic_vector(15 downto 0) := (others => '0');
  signal AluOp: std_logic_vector(3 downto 0) := (others => '0');
  signal Instruction: std_logic_vector(15 downto 0) := (others => '0');
  signal Immediate: std_logic_vector(7 downto 0) := (others => '0');
  signal RegSelA: std_logic_vector(3 downto 0) := (others => '0');
  signal RegSelB: std_logic_vector(3 downto 0) := (others => '0');
  signal RegSelO: std_logic_vector(3 downto 0) := (others => '0');
  signal DataA: std_logic_vector(15 downto 0) := (others => '0');
  signal DataB: std_logic_vector(15 downto 0) := (others => '0');
  signal DataO: std_logic_vector(15 downto 0) := (others => '0');
  signal State: std_logic_vector(4 downto 0) := (others => '0');

  constant clk: time := 1 ns;

  begin
    decoder: Decode port map(
      Clock => Clock,
      Enable => EnableDecoder,
      Instruction => Instruction,
      AluOp => AluOp,
      Immediate => Immediate,
      RegSelA => RegSelA,
      RegSelB => RegSelB,
      RegSelO => RegSelO
    );

    regs: Registers port map(
      Clock => Clock,
      Enable => EnableRegAny,
      RegSelA => RegSelA,
      RegSelB => RegSelB,
      RegSelO => RegSelO,
      DataA => DataA,
      DataB => DataB,
      DataO => DataO,
      WriteEnable => EnableAnyRegWrite
    );

    alu: ArithLogic port map(
      Clock => Clock,
      Enable => EnableArith,
      AluOp => AluOp,
      DataA => DataA,
      DataB => DataB,
      Result => DataO,
      Immediate => Immediate
    );

    ctrl: Control port map(
      Clock => Clock,
      State => State
    );

    mem: Ram port map(
      Clock => Clock,
      WriteEnable => RamWriteEnable,
      Address => RamAddress,
      InData => RamInData,
      OutData => RamOutData
    );

    EnableFetch <= state(0);
    EnableDecoder <= state(1);
    EnableRegRead <= state(2);
    EnableArith <= state(3);
    EnableRegWrite <= state(4);
    EnableRegAny <= EnableRegRead or EnableRegWrite;
    EnableAnyRegWrite <= EnableRegWrite;

    RamWriteEnable <= '0';
    RamAddress <= ProgCounter;
    RamOutData <= X"FFFF";
    Instruction <= RamInData;

    ClockProcess: process
    begin
      Clock <= '0';
      wait for clk/2;
      Clock <= '1';
      wait for clk/2;
    end process;

    MainProcess: process
    begin
      Instruction <= X"0301";  -- LDL A 01
      wait for clk*4;
      Instruction <= X"0402";  -- LDL B 02
      wait for clk*4;
      Instruction <= X"2534";  -- ADD C A B
      wait for clk*4;
      wait;
    end process;
end;
