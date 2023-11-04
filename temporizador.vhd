--------------------------------------------------------------------------------
-- Temporizador decimal do cronometro de xadrez
-- Fernando Moraes - 25/out/2023
--------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
library work;

entity temporizador is
    port( clock, reset, load, en : in std_logic;
          init_time : in  std_logic_vector(7 downto 0); --valor de inicialização dos minutos(8 bits)
          cont      : out std_logic_vector(15 downto 0) -- valor de saida do temporizador (16 bits)
      );
end temporizador;

architecture a1 of temporizador is
    signal segL, segH, minL, minH : std_logic_vector(3 downto 0);
    signal en1, en2, en3, en4: std_logic; --habilita contagem regressiva

begin
    en1 <= en AND (minH /= "0000" and minL /= "0000" and segH /= "0000" and segL /= "0000");
    en2 <= en1 AND (segL = "0000");
    en3 <= en2 AND (minL /= "0000");
    en4 <= en3 AND (minL = "0000");
--port map(realiza as conexões entre os sinais de um componente e a arquitetura)
    sL : entity work.dec_counter port map (first_value => "0000", limit => "1001", en=> en2, count =>segL); -- 9 a 0
    sH : entity work.dec_counter port map (first_value => "0000", limit => "0101", en=> en1, count =>segH); -- 5 a 0
    mL : entity work.dec_counter port map (first_value => "0000", limit => "1001", en=> en3, count =>minL); -- 9 a 0
    mH : entity work.dec_counter port map (first_value => "0000", limit => "1001", en=> en4, count =>minH); -- 9 a 0
   
   cont <= minH & minL & segH & segL;
end a1;

--OU
process (load, en, init_time)
    begin
        if load = '1' then
            minH <= "0000";
            minL <= init_time(7 downto 4);
            segH <= "0101"; -- Inicializa segH com 5 (59 segundos)
            segL <= "0000";
        elsif en = '1' then
            if en4 = '1' then
                if minH /= "0000" or minL /= "0000" or segH /= "0000" then
                    segL <= std_logic_vector(unsigned(segL) - 1);
                end if;
            elsif en3 = '1' then
                if segL = "0000" then
                    segH <= std_logic_vector(unsigned(segH) - 1);
                    segL <= "1001"; -- Reinicializa segL com 9
                end if;
            elsif en2 = '1' then
                if minL /= "0000" then
                    minL <= std_logic_vector(unsigned(minL) - 1);
                    segL <= "1001"; -- Reinicializa segL com 9
                end if;
            else
                if minH /= "0000" then
                    minH <= std_logic_vector(unsigned(minH) - 1);
                    minL <= "1001"; -- Reinicializa minL com 9
                    segH <= std_logic_vector(unsigned(segH) - 1);
                    segL <= "1001"; -- Reinicializa segL com 9
                end if;
            end if;
        end if;
    end process;

