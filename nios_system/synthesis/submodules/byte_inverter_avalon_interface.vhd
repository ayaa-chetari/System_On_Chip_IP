library ieee;
use ieee.std_logic_1164.all;

entity byte_inverter_avalon_interface is
    port(
        -- Interface Avalon-MM
        clock      : in  std_logic;
        resetn     : in  std_logic;
        read       : in  std_logic;
        write      : in  std_logic;
        address    : in  std_logic_vector(1 downto 0);
        writedata  : in  std_logic_vector(31 downto 0);
        readdata   : out std_logic_vector(31 downto 0);
        byteenable : in  std_logic_vector(3 downto 0)
    );
end entity;

architecture Structure of byte_inverter_avalon_interface is

    -- registres internes
    signal reg_input     : std_logic_vector(31 downto 0);
    signal reg_mode      : std_logic_vector(31 downto 0);
    signal inverted_data : std_logic_vector(31 downto 0);

    COMPONENT byte_inverter
        PORT (
            input  : in  std_logic_vector(31 downto 0);
            output : out std_logic_vector(31 downto 0);
            mode   : in  std_logic
        );
    END COMPONENT;

begin

    --------------------------------------------------------------------
    -- Processus d'écriture Avalon-MM
    --------------------------------------------------------------------
    process(clock, resetn)
    begin
        if resetn = '0' then
            reg_input <= (others => '0');
            reg_mode  <= (others => '0');

        elsif rising_edge(clock) then

            if write = '1' then

                case address is

                    -- registre d'entrée
                    when "00" =>
                        reg_input <= writedata;

                    -- registre mode
                    when "01" =>
                        reg_mode <= writedata;

                    when others =>
                        null;

                end case;

            end if;

        end if;
    end process;

    --------------------------------------------------------------------
    -- Lecture Avalon-MM
    --------------------------------------------------------------------
    process(read, address, inverted_data)
    begin

        if read = '1' then

            case address is

                -- lecture résultat inversion
                when "10" =>
                    readdata <= inverted_data;

                when others =>
                    readdata <= (others => '0');

            end case;

        else
            readdata <= (others => '0');

        end if;

    end process;

    --------------------------------------------------------------------
    -- Instanciation du module combinatoire
    --------------------------------------------------------------------
    inverter_inst : byte_inverter
        port map(
            input  => reg_input,
            output => inverted_data,
            mode   => reg_mode(0)
        );

end Structure;