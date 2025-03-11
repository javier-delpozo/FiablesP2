library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divisor_3 is
    port(
        clk         : in  std_logic;
        ena         : in  std_logic;  -- reset asíncrono (activo en '0')
        f_div_2_5   : out std_logic;  -- salida de 2.5MHz (10MHz/4)
        f_div_1_25  : out std_logic;  -- salida de 1.25MHz (10MHz/8)
        f_div_500   : out std_logic   -- salida de 500KHz (10MHz/20)
    );
end entity divisor_3;

architecture Behavioral of divisor_3 is
    signal count_25   : integer range 0 to 1 := 0;
    signal count_12_5 : integer range 0 to 3 := 0;
    signal count_5    : integer range 0 to 9 := 0;
    
    signal pulse_25   : std_logic := '0';
    signal pulse_12_5 : std_logic := '0';
    signal pulse_5    : std_logic := '0';

begin
    -- Division de las frecuencias
    process(clk, ena)
    begin
    -- Reset asíncrono
        if ena = '0' then  
            count_25   <= 0;
            count_12_5 <= 0;
            count_5    <= 0;
            pulse_25   <= '0';
            pulse_12_5 <= '0';
            pulse_5    <= '0';
        elsif rising_edge(clk) then
            
            -- 25 MHz => 2 ciclos de reloj de 100 MHz
            if count_25 = 1 then
                count_25 <= 0;
                pulse_25 <= '1';
            else
                count_25 <= count_25 + 1;
                pulse_25 <= '0';
            end if;
            -- 12.5 MHz => 4 ciclos de reloj de 100 MHz
            if count_12_5 = 3 then
                count_12_5 <= 0;
                pulse_12_5 <= '1';
            else
                count_12_5 <= count_12_5 + 1;
                pulse_12_5 <= '0';
            end if;

            -- 5 MHz => 10 ciclos de reloj de 100 MHz
            if count_5 = 9 then
                count_5 <= 0;
                pulse_5 <= '1';
            else
                count_5 <= count_5 + 1;
                pulse_5 <= '0';
            end if;
        end if;
    end process;

    -- Asignaciones de salida: cada señal es un pulso de 1 ciclo de reloj
    f_div_2_5   <= pulse_25;
    f_div_1_25 <= pulse_12_5;
    f_div_500    <= pulse_5;
    
end Behavioral;
