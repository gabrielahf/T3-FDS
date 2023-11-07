--------------------------------------------------------------------------------
-- RELOGIO DE XADREZ
-- Author - Fernando Moraes - 25/out/2023
-- Revision - Iaçanã Ianiski Weber - 30/out/2023
--------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;

entity relogio_xadrez is
    port( j1,j2,load,clock,reset: in std_logic;
          init_time: in std_logic_vector (7 downto 0);
          winJ1,winJ2: out std_logic;
          contj1,contj2: out std_logic_vector (15 downto 0)

        -- COMPLETAR DE ACORDO COM A ESPECIFICACAO
    );
end relogio_xadrez;

architecture relogio_xadrez of relogio_xadrez is
    -- DECLARACAO DOS ESTADOS
    type states is (INICIO, TIME0, START, PLAY1, PLAY2, VIT1, VIT2);
    signal EA, PE : states;
    signal enable1, enable2, load_interno: std_logic;
    signal sin_contj1, sin_contj2 : std_logic_vector(15 downto 0);
begin

    -- INSTANCIACAO DOS CONTADORES
    contador1 : entity work.temporizador port map (clock => clock, reset => reset, load => load_interno, en => enable1,init_time => init_time, cont => sin_contj1);
    contador2 : entity work.temporizador port map (clock => clock,reset => reset,load => load_interno, en => enable2, init_time => init_time, cont => sin_contj2);

    

    -- PROCESSO DE TROCA DE ESTADOS
    process (clock, reset)
    begin
       if reset = '1' then
         EA <= INICIO;
       elsif rising_edge(clock) then
         EA <= PE;
       end if;
    end process;

    -- PROCESSO PARA DEFINIR O PROXIMO ESTADO
    process (EA, load_interno, j1, j2, sin_contj1, sin_contj2)
    begin
        case EA is
            
            when INICIO => if load_interno = '1' then  PE <= TIME0;
                                                 else  PE <= INICIO;
                           end if;

            when TIME0 => then PE <= START;

            when START =>  if j1 = '1'   then  PE <= PLAY1;
			enable1 <= '1';
            enable2 <= '0';
                        elsif j2 = '1' then PE <= PLAY2;
            enable1 <= '0';
            enable2 <= '1';
                                           else  PE <= START;
                           end if;

            when PLAY1 =>  if j1 = '1'    then  PE <= PLAY2;
			enable1 <= '0';
            enable2 <= '1';
                           elsif sin_contj1 = x"0000"then  PE <= VIT2;
			enable1 <= '0';
            enable2 <= '0';
							else  PE <= PLAY1;
                            end if;
           
            when PLAY2 =>  if j2 = '1' then  PE <= PLAY1;
			enable1 <= '1';
            enable2 <= '0';
                           elsif sin_contj2 = x"0000" then  PE <= VIT1;
			enable1 <= '0';
            enable2 <= '0';
						   else  PE <= PLAY2;
                            end if; 

            when VIT1 =>  PE <= INICIO;
            --winJ1 <= '1';   
            
            when VIT2 =>  PE <= INICIO;
            --winJ2 <= '1';

        end case;
    end process;

        -- ATRIBUICAO COMBINACIONAL DOS SINAIS INTERNOS E SAIDAS - Dica: faca uma maquina de Moore, desta forma os sinais dependem apenas do estado atual!!
        winJ1 <= '1' when EA = VIT1 else '0';
        winJ2 <= '1' when EA = VIT2 else '0';
        load_interno <= '1' when EA = TIME0 else '0';
        contj1 <= '1' when EA = sin_contj1 else '0';
        contj2 <= '1' when EA = sin_contj2 else '0';
	
end relogio_xadrez;
