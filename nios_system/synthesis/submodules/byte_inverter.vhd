library ieee;
use ieee.std_logic_1164.all;

entity byte_inverter is
    port(
        input  : in  std_logic_vector(31 downto 0);
        output : out std_logic_vector(31 downto 0);
        mode   : in  std_logic  -- 0 = inversion complète, 1 = inversion par paires
    );
end entity;

architecture RTL of byte_inverter is
begin

    -- Mode sélectionné via signal combinatoire
    output <= 
        -- Mode 0 : inversion complète [Octet0 | Octet1 | Octet2 | Octet3]
        input(7 downto 0) & input(15 downto 8) & input(23 downto 16) & input(31 downto 24)
            when mode = '0' else
        -- Mode 1 : inversion par paires [Octet1 | Octet0 | Octet3 | Octet2]
        input(15 downto 8) & input(7 downto 0) & input(31 downto 24) & input(23 downto 16);

end RTL;