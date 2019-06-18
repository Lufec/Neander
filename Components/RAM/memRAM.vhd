library ieee;
use ieee.std_logic_1164.all;
entity memRAM is
	port(
		ent: in std_logic_vector(7 downto 0);
		key: in std_logic_vector(7 downto 0);
		W,R,reset,clk: in std_logic;
		saida: out std_logic_vector(7 downto 0)	
	);
end memRAM;

architecture banco of memRAM is
	component memCell is	
		 port(ent: in std_logic_vector(7 downto 0);
		 X,Y,W,reset,clk: in std_logic;
		 saida: out std_logic_vector(7 downto 0)
		 );
	end component;
	component decoder_2_4 is
		port(
			key: in std_logic_vector(1 downto 0);
			sel: out std_logic_vector(3 downto 0)
		);
	end component;
type bank is array (0 to 15) of std_logic_vector(7 downto 0);
signal selX, selY: std_logic_vector(3 downto 0);
signal saidabank: bank;
signal saida_sgn: std_logic_vector(7 downto 0);
signal Rsgn: std_logic_vector(7 downto 0);
begin
	decodX: decoder_2_4 port map (sel => selX, key(1)=> key(3), key(0)=> key(2));
	decodY: decoder_2_4 port map (sel => selY, key(1)=> key(1), key(0)=> key(0));

		genx:for i in 0 to 3 generate
		   geny:for j in 0 to 3 generate
				gen: memCell port map(ent => ent, X => selX(i), Y=> selY(j), W=>W, reset=>reset , clk =>clk, saida=>saidabank(4*i+j));
			end generate;
		end generate;
		saida_sgn <= saidabank(0) or saidabank(1) or saidabank(2) or saidabank(3) or saidabank(4) or saidabank(5) or saidabank(6) or saidabank(7)
					or saidabank(8) or saidabank(9) or saidabank(10) or saidabank(11) or saidabank(12) or saidabank(13) or saidabank(14) or saidabank(15);
		process(R)
		begin
			for i in 0 to 7 loop
				Rsgn(i)<=R;
			end loop;
		end process;
		saida <= saida_sgn and Rsgn;

	end banco;