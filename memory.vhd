----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: memory
-- Project Name: MIPS-SC
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: A generic memory module for the processor.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY MIPS;
USE MIPS.PKG_MIPS.ALL;

ENTITY memory IS
    GENERIC (
        START_ADDR : reg32 := (OTHERS => '0');
        CONTENTS_FILE : STRING := "none"
    );
    PORT (
        data_in : IN reg32;
        address : IN reg32;
        we : IN STD_LOGIC;
        oe : IN STD_LOGIC;
        bw : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        data_out : OUT reg32
    );
END memory;

ARCHITECTURE behavioral OF memory IS 
    SIGNAL contents : mem_array_t := InitMEM(CONTENTS_FILE);
    
    SIGNAL memory_address : ureg32;
    SIGNAL address_integer : INTEGER;
BEGIN 
    memory_address <= ureg32(address) - ureg32(START_ADDR);
    address_integer <= TO_INTEGER( memory_address );
    
    PROCESS(clk, address_integer, oe, we)
    BEGIN
        IF(address_integer >= 0 AND address_integer < CONST_ADDR_NUM) THEN
            IF(oe = '1') THEN        
                data_out(7 DOWNTO 0) <= contents(address_integer);            
                data_out(15 DOWNTO 8) <= contents(address_integer + 1);
                data_out(23 DOWNTO 16) <= contents(address_integer + 2);
                data_out(31 DOWNTO 24) <= contents(address_integer + 3);
            ELSIF(RISING_EDGE(clk) AND we = '1') THEN
                IF(bw = '0') THEN
                    contents(address_integer + 1) <= data_in(15 DOWNTO 8);
                    contents(address_integer + 2) <= data_in(23 DOWNTO 16);
                    contents(address_integer + 3) <= data_in(31 DOWNTO 24);
                END IF;
                contents(address_integer) <= data_in(7 DOWNTO 0);
            END IF;
        END IF;
    END PROCESS;
END behavioral;