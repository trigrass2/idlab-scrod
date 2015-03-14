------------------------------------------------------------------------
--
--  b2tt_ddr.vhd -- TT-link DDR and delay hander for Belle2link frontend
--                  for Virtex-5 / Virtex-6
--
--  Mikihiko Nakao, KEK IPNS
--
--  20131002 separated from b2tt_decode.vhd and b2tt_encode.vhd
--  20131013 Spartan-6 support
--  20131028 slip fix, no auto wrap, separate Virtex-6 support
--  20131101 no more std_logic_arith
--
------------------------------------------------------------------------

------------------------------------------------------------------------
-- - b2tt_iddr
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.ALL;

entity b2tt_iddr is
  generic (
    FLIPIN    : std_logic := '0';
    REFFREQ   : real      := 203.546;
    WRAPCOUNT : integer   := 51 );
  port (
    clock    : in  std_logic;
    invclock : in  std_logic; -- spartan6 only
    inp      : in  std_logic;
    inn      : in  std_logic;
    incdelay : in  std_logic;
    clrdelay : in  std_logic;
    sigslip  : in  std_logic;
    enslip   : in  std_logic;
    autoslip : in  std_logic;
    decdelay : in  std_logic; -- debug only (decrement instead of increment)
    caldelay : in  std_logic; -- spartan6 only
    staslip  : out std_logic;
    bitddr   : out std_logic;
    bit2     : out std_logic_vector (1 downto 0);
    cntdelay : out std_logic_vector (11 downto 0) );

end b2tt_iddr;
------------------------------------------------------------------------
architecture implementation of b2tt_iddr is
  signal sig_ii     : std_logic_vector (1 downto 0) := "00";
  signal sig_di     : std_logic_vector (1 downto 0) := "00";
  signal sig_q      : std_logic_vector (1 downto 0) := "00";
  signal seq_inc    : std_logic_vector (1 downto 0) := "00";
  signal sig_inc    : std_logic_vector (1 downto 0) := "00";
  signal sig_clr    : std_logic := '0';
  signal cnt_delay  : std_logic_vector (5 downto 0) := "000000";
  signal cnt_delay2 : std_logic_vector (4 downto 0) := "00000";
  signal sig_raw2   : std_logic_vector (1 downto 0) := "00";
  signal sig_bit2   : std_logic_vector (1 downto 0) := "00";
  signal sta_slip   : std_logic := '0';
  signal buf_bit    : std_logic := '0';
  signal sig_incdir : std_logic := '1';
  
  -- following does not work because length of "string" is
  -- unconstrained:
  -- type   string_vector is array (natural range <>) of string;
  -- constant string : DLYSRC (1 downto 0) := ("DATAIN", "I");
begin
  -- in
  sig_incdir <= not decdelay;
  
  mpa_ibufds: ibufds
    port map ( o => sig_ii(0), i => inp, ib => inn );
  sig_ii(1) <= '0';
  sig_di(1) <= '0';--bmk sig_q(0);
  sig_di(1) <= sig_q(0);
  
  sig_q(1) <= sig_q(0);--bmk for single

    map_idelay0 : iodelaye1
    generic map (
      CINVCTRL_SEL          => FALSE,       -- Enable dynamic clock inversion ("TRUE"/"FALSE") 
      DELAY_SRC             => "I",         -- Delay input ("I", "CLKIN", "DATAIN", "IO", "O")
      HIGH_PERFORMANCE_MODE => TRUE,        -- Reduced jitter ("TRUE"), Reduced power ("FALSE")
      IDELAY_TYPE           => "VARIABLE",   -- "DEFAULT", "FIXED", "VARIABLE", or "VAR_LOADABLE" 
      IDELAY_VALUE          => 0,           -- Input delay tap setting (0-32)
      ODELAY_TYPE           => "VARIABLE",     -- "FIXED", "VARIABLE", or "VAR_LOADABLE" 
      ODELAY_VALUE          => 0,           -- Output delay tap setting (0-32)
      REFCLK_FREQUENCY      => REFFREQ,       -- IDELAYCTRL clock input frequency in MHz
      SIGNAL_PATTERN        => "DATA")      -- "DATA" or "CLOCK" input signal    
    port map (
      cntvalueout           => open, -- 5-bit output - Counter value for monitoring purpose
      dataout               => sig_q(0),     -- 1-bit output - Delayed data output
      c                     => clock,           -- 1-bit input - Clock input
      ce                    => sig_inc(0),          -- 1-bit input - Active high enable increment/decrement function
      cinvctrl              => '0',    -- 1-bit input - Dynamically inverts the Clock (C) polarity
      clkin                 => '0',       -- 1-bit input - Clock Access into the IODELAY
      cntvaluein            => (others => '0'),  -- 5-bit input - Counter value for loadable counter application
      datain                => sig_di(0),      -- 1-bit input - Internal delay data
      idatain               => sig_ii(0),     -- 1-bit input - Delay data input
      inc                   => sig_incdir,         -- 1-bit input - Increment / Decrement tap delay
      odatain               => '0',     -- 1-bit input - Data input for the output datapath from the device
      rst                   => sig_clr,         -- 1-bit input - Active high, synchronous reset, resets delay chain to IDELAY_VALUE/ODELAY_VALUE tap. If no value is specified, the default is 0.
      t                     => '1'            -- 1-bit input - 3-state input control. Tie high for input-only or internal delay or tie low for output only.
   );      

    -- map_idelay0 : iodelaye1
    -- generic map (
      -- CINVCTRL_SEL          => FALSE,       -- Enable dynamic clock inversion ("TRUE"/"FALSE") 
      -- DELAY_SRC             => "DATAIN",         -- Delay input ("I", "CLKIN", "DATAIN", "IO", "O")
      -- HIGH_PERFORMANCE_MODE => TRUE,        -- Reduced jitter ("TRUE"), Reduced power ("FALSE")
      -- IDELAY_TYPE           => "VARIABLE",   -- "DEFAULT", "FIXED", "VARIABLE", or "VAR_LOADABLE" 
      -- IDELAY_VALUE          => 0,           -- Input delay tap setting (0-32)
      -- ODELAY_TYPE           => "VARIABLE",     -- "FIXED", "VARIABLE", or "VAR_LOADABLE" 
      -- ODELAY_VALUE          => 0,           -- Output delay tap setting (0-32)
      -- REFCLK_FREQUENCY      => REFFREQ,       -- IDELAYCTRL clock input frequency in MHz
      -- SIGNAL_PATTERN        => "DATA")      -- "DATA" or "CLOCK" input signal    
    -- port map (
      -- cntvalueout           => open, -- 5-bit output - Counter value for monitoring purpose
      -- dataout               => sig_q(1),     -- 1-bit output - Delayed data output
      -- c                     => clock,           -- 1-bit input - Clock input
      -- ce                    => sig_inc(1),          -- 1-bit input - Active high enable increment/decrement function
      -- cinvctrl              => '0',    -- 1-bit input - Dynamically inverts the Clock (C) polarity
      -- clkin                 => '0',       -- 1-bit input - Clock Access into the IODELAY
      -- cntvaluein            => (others => '0'),  -- 5-bit input - Counter value for loadable counter application
      -- datain                => sig_di(1),      -- 1-bit input - Internal delay data
      -- idatain               => sig_ii(0),     -- 1-bit input - Delay data input
      -- inc                   => sig_incdir,         -- 1-bit input - Increment / Decrement tap delay
      -- odatain               => '0',     -- 1-bit input - Data input for the output datapath from the device
      -- rst                   => sig_clr,         -- 1-bit input - Active high, synchronous reset, resets delay chain to IDELAY_VALUE/ODELAY_VALUE tap. If no value is specified, the default is 0.
      -- t                     => '1'            -- 1-bit input - 3-state input control. Tie high for input-only or internal delay or tie low for output only.
   -- );      
  
  map_id: iddr
    generic map (
      DDR_CLK_EDGE => "SAME_EDGE" )
    port map (
      s  => '0',
      d  => sig_q(1),
      ce => '1',
      c  => clock,
      r  => '0',
      q1 => sig_raw2(0),
      q2 => sig_raw2(1) );

  sig_bit2(0) <= sig_raw2(0) xor FLIPIN;
  sig_bit2(1) <= sig_raw2(1) xor FLIPIN;

  proc: process (clock)
  begin
    if clock'event and clock = '1' then

      -- incdelay / clrdelay combination
      
      seq_inc <= seq_inc(0) & incdelay;

      -- VIRTEX5: idelayctrl clock tick = 7.8 ns / (8/5)
      -- tap = 7.8 ns / ((8/5*64))
      -- to cover half clock width (3.9ns): (8/5)*64/2 = about 51 (WRAPCOUNT)
      
      if clrdelay = '1' then
        sig_clr <= '1';
        cnt_delay2 <= (others => '0');
      elsif sig_incdir = '1' and seq_inc = "01" and cnt_delay = WRAPCOUNT then
        sig_clr <= '1';
        cnt_delay2 <= cnt_delay2 + 1;
      else
        sig_clr <= '0';
      end if;

      if sig_incdir = '1' and seq_inc = "01" and cnt_delay /= WRAPCOUNT then
        if cnt_delay(0) = '1' then
          sig_inc <= "10";
        else
          sig_inc <= "01";
        end if;
      elsif sig_incdir = '0' and seq_inc = "01" and cnt_delay /= 0 then
        if cnt_delay(0) = '1' then
          sig_inc <= "01";
        else
          sig_inc <= "10";
        end if;
      else
        sig_inc <= "00";
      end if;

      if sig_clr = '1' then
        cnt_delay <= (others => '0');
      elsif sig_inc /= 0 then
        if sig_incdir = '1' then
          cnt_delay <= cnt_delay + 1;
        else
          cnt_delay <= cnt_delay - 1;
        end if;
      end if;

      -- slip logic
      if autoslip = '1' and sigslip = '1' then
        sta_slip <= not sta_slip;
      elsif autoslip = '0' then
        sta_slip <= enslip;
      end if;
      buf_bit <= sig_bit2(0);

      -- bit2
      if sta_slip = '0' then
        bit2 <= sig_bit2;
      else
        bit2 <= buf_bit & sig_bit2(1);
      end if;
      
    end if; -- event
  end process;
  
  -- bit2 was generated here up to b2tt 0.11, but it is a bit timing-tight
  --   -- out (buf_bit is sync, sig_bit2 is async)
  --   bit2 <= sig_bit2 when sta_slip = '0' else buf_bit & sig_bit2(1);

  -- out
  bitddr   <= sig_q(1);
  staslip  <= sta_slip;
  cntdelay <= sta_slip & cnt_delay2 & cnt_delay;
      
end implementation;

------------------------------------------------------------------------
-- - b2tt_oddr
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.ALL;

entity b2tt_oddr is
  generic (
    FLIPOUT  : std_logic := '0';
    REFFREQ  : real      := 203.546 );
  port (
    clock    : in  std_logic;
    invclock : in  std_logic; -- only for s6
    mask     : in  std_logic;
    bit2     : in  std_logic_vector (1 downto 0);
    bitddr   : out std_logic;
    outp     : out std_logic;
    outn     : out std_logic );

end b2tt_oddr;
------------------------------------------------------------------------
architecture implementation of b2tt_oddr is
  signal sig_o    : std_logic := '0';
  signal sig_oq   : std_logic := '0';
  signal sig_bit2 : std_logic_vector (1 downto 0) := "00";
begin
  -- in
  sig_bit2(0) <= bit2(0) xor FLIPOUT;
  sig_bit2(1) <= bit2(1) xor FLIPOUT;
  
  map_obufdst: obuftds
    port map ( i => sig_o, o => outp, ob => outn, t => mask );

  map_odelay: iodelay
    generic map (
      REFCLK_FREQUENCY => 203.546,
      HIGH_PERFORMANCE_MODE => FALSE,
      IDELAY_TYPE => "FIXED",
      DELAY_SRC   => "O" )
    port map (
      odatain => sig_oq,
      idatain => '0',
      datain  => '0',
      dataout => sig_o,
      ce  => '0',
      rst => '0',
      t   => '0',
      inc => '1',
      c   => '0' );

  map_od: oddr
    generic map (
      DDR_CLK_EDGE => "SAME_EDGE"
      )
    port map (
      s => '0',
      d1 => sig_bit2(1), -- order: d1 first, d2 second
      d2 => sig_bit2(0), -- (10b: left-most-bit first, right-most last)
      ce => '1',
      c  => clock,
      r  => '0',
      q  => sig_oq );

  -- out
  bitddr <= sig_o;
  
end implementation;

