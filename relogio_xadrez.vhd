--------------------------------------------------------------------------------
-- RELOGIO DE XADREZ
-- Author - Fernando Moraes - 25/out/2023
-- Revision - IaÃ§anÃ£ Ianiski Weber - 30/out/2023
--------------------------------------------------------------------------------
library IEEE;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;

entity relogio_xadrez is
    port( load,clock,reset: in std_logic;
          init_time: in std_logic_vector (7 downto 0);
          winJ1,winJ2: out std_logic;
	  contj1,contj2: out std_logic_vector (15 downto 0)
	);
          

        -- COMPLETAR DE ACORDO COM A ESPECIFICACAO
    
end relogio_xadrez;

architecture relogio_xadrez of relogio_xadrez is
    -- DECLARACAO DOS ESTADOS
    type states is ( INICIO, TIME0, START,j1 ,j2, VIT1, VIT2);
    signal EA, PE : states;
    signal load_interno, en1, en2: std_logic;
    signal cont1,cont2 : std_logic_vector (15 downto 0);
    -- ADICIONE AQUI OS SINAIS INTERNOS NECESSARIOS
    
begin

    -- INSTANCIACAO DOS CONTADORES
    contador1 : entity work.temporizador port map ( clock => clock, reset => reset, load => load_interno, en => en1, init_time => init_time, cont => cont1);
    contador2 : entity work.temporizador port map ( clock => clock, reset => reset, load => load_interno, en => en2, init_time => init_time, cont => cont2);

    -- PROCESSO DE TROCA DE ESTADOS
    process (clock, reset)
    begin
        if reset = '1' then
            EA <= INICIO;
        elsif rising_edge(clock) then
            EA <= PE;
        end if;
    
        -- COMPLETAR COM O PROCESSO DE TROCA DE ESTADO

    end process;

    -- PROCESSO PARA DEFINIR O PROXIMO ESTADO
    process (EA,en1,en2,cont1,cont2) --<<< Nao esqueca de adicionar os sinais da lista de sensitividade
begin
    case EA is
        when INICIO =>
            if load = '1' then
                PE <= TIME0;
            end if;
        when TIME0 =>
            PE <= START;
        when START =>
            if en1 = '1' then 
                PE <= j1;
            elsif en2 = '1' then
                PE <= j2;
            else PE <= START;
            end if;
        when j1 =>
            if en1 = '1' then 
                PE <= j2;
            elsif en1 = '0' then
                PE <= j1;
            elsif cont1 = '000000000000000' then
                PE <= VIT2;
            end if;
        when j2 =>
            if en2 = '1' then 
                PE <= j1;
            elsif en2 = '0' then
                PE <= j2;
            elsif cont2 = '000000000000000' then
                PE <= VIT1;
            end if;
        when VIT1 =>
                PE <= INICIO;
        when VIT2 =>
                PE <= INICIO;
    end case;
end process;

    -- ATRIBUICAO COMBINACIONAL DOS SINAIS INTERNOS E SAIDAS - Dica: faca uma maquina de Moore, desta forma os sinais dependem apenas do estado atual!!
    winJ1 <= '1' when EA = VIT1 else '0';
    winJ2 <= '1' when EA = VIT2 else '0';
    j1 <= '1' when EA = en1 else '0';
    j2 <= '1' when EA = en2 else '0';
    load_interno <= '1' when EA = TIME0 else '0';
    contj1 <= '1' when EA = cont1 else '0';
    contj2 <= '1' when EA = cont2 else '0';

end relogio_xadrez;

