--------------------------------------------------------------------------------
-- RELOGIO DE XADREZ
-- Author - Fernando Moraes - 25/out/2023
-- Revision - Iaçanã Ianiski Weber - 30/out/2023
--------------------------------------------------------------------------------
library IEEE;
library ieee;
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
    type states is ( INICIO, TIME0, START, j1, j2, VIT1, VIT2);
    signal EA, PE : states;
    signal J1, J2, contj1,contj2 : std_logic;
    -- ADICIONE AQUI OS SINAIS INTERNOS NECESSARIOS
    
begin

    -- INSTANCIACAO DOS CONTADORES
    contador1 : entity work.temporizador port map ( clock => clock, reset => reset, load => load, en => j1, init_time => TIME0, cont => contj1);
    contador2 : entity work.temporizador port map ( clock => clock, reset => reset, load => load, en => j2, init_time => TIME0, cont => contj2);

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
    process (EA,J1,J2,contj1,contj2) --<<< Nao esqueca de adicionar os sinais da lista de sensitividade
begin
    case EA is
        when INICIO =>
            if load = '1' then
                PE <= TIME0;
            end if;
        when TIME0 =>
            PE <= START;
        when START =>
            if J1 = '1' then 
                PE <= j1;
            elsif J2 = '1' then
                PE <= j2;
            else PE <= START;
            end if;
        when j1 =>
            if J1 = '1' then 
                PE <= j2;
            elsif J1 = '0' then
                PE <= j1;
            elsif contj1 = '0' then
                PE <= VIT2;
            end if;
        when j2 =>
            if J2 = '1' then 
                PE <= j1;
            elsif J2 = '0' then
                PE <= j2;
            elsif contj2 = '0' then
                PE <= VIT1;
            end if;
        when VIT1 =>
                PE <= INICIO;
        when VIT2 =>
                PE <= INICIO;
    end case;
end process;

    -- ATRIBUICAO COMBINACIONAL DOS SINAIS INTERNOS E SAIDAS - Dica: faca uma maquina de Moore, desta forma os sinais dependem apenas do estado atual!!
    winJ1 <= '1' when PE = VIT1 else '0';
    winJ2 <= '1' when PE = VIT2 else '0';

end relogio_xadrez;

