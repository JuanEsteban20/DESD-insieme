---------- DEFAULT LIBRARY ---------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;
--    use IEEE.MATH_REAL.all;
------------------------------------

entity exe1_vel is
generic(
       sr_length: integer range 0 to 16 := 4;
       sr_init  : integer := 0;
       vel_init: integer := 16
);
port (
    clk: IN std_logic;
    reset: IN std_logic;
    velocity: IN std_logic_vector (vel_init-1 downto 0);

    dout: OUT std_logic_vector(0 to sr_length-1)
);
end exe1_vel;

architecture Behavioral of exe1_vel is

    signal mem_to : std_logic_vector(0 to sr_length-1);
    signal count : integer := 0;
    signal din : std_logic := '1';
    signal v   : std_logic_vector (vel_init-1 downto 0);
    signal c : integer := -1;

begin
  dout <= mem_to;
  v <= velocity;

  shift_reg  :  process(reset, clk)
    begin
      if (reset = '1') then
          count <= 0;
          mem_to <= std_logic_vector(to_unsigned(sr_init,mem_to'length));
          din <= '1';
          c <= 0;

      elsif rising_edge(clk) then
        c <= c+1;
        if c = to_integer(unsigned(v)) then
          if (count >= 0 and count < sr_length) then
              mem_to <= din&mem_to(0 to sr_length-2);
              count <= count+1;
          end if;

          if (count = sr_length) then
            count <= count+sr_length;
            mem_to <= mem_to(1 to sr_length-1)&din;
          end if;

          if (count > sr_length+2)  then
            mem_to <= mem_to(1 to sr_length-1)&din;
            count <= count-1;
          end if;

          if (count = sr_length+2) then
            mem_to <= din&mem_to(0 to sr_length-2);
            count <= 2;
          end if;

          din <= '0';
          c <= -1;

        end if;

      end if;

    end process;

end Behavioral;
