----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: register_file
-- Project Name: MIPS-SC
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Contains the general purpose registers of the processor.
-- 
-- Dependencies: generic_register
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY MIPS;
USE MIPS.PKG_MIPS.ALL;

ENTITY register_file IS
  PORT ( 
         write_data : IN reg32;
         read_reg1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
         read_reg2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
         write_reg : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
         write_en : IN STD_LOGIC;
         clk : IN STD_LOGIC;
         rst : IN STD_LOGIC;
         read_data1 : OUT reg32;
         read_data2 : OUT reg32 
  );
END register_file;

ARCHITECTURE behavioral OF register_file IS
    TYPE register_array_t IS ARRAY (31 DOWNTO 0) OF reg32;
    
    SIGNAL regs_value : register_array_t;
    SIGNAL regs_ld : reg32;
BEGIN
    GENERATE_REGS:
    FOR i IN 31 DOWNTO 0 GENERATE
        regs_ld(i) <= '1' when (i /= 0 AND TO_INTEGER(UNSIGNED(write_reg)) = i AND write_en = '1') else '0';
        
        GENERATE_GP_REGS:
        IF (i /= 29) GENERATE
        GP_REGS: ENTITY WORK.generic_register
        PORT MAP (
            D => write_data,
            ld => regs_ld(i),
            clk => clk,
            rst => rst,
            Q => regs_value(i)
        );
        END GENERATE;
        
        GENERATE_SP_REG:
        IF (i = 29) GENERATE
        SP_REG: ENTITY WORK.generic_register
        GENERIC MAP ( INIT_VALUE => x"10010800" )
        PORT MAP (
            D => write_data,
            ld => regs_ld(i),
            clk => clk,
            rst => rst,
            Q => regs_value(i)
        );
        END GENERATE;
    END GENERATE;

    read_data1 <= regs_value( TO_INTEGER( UNSIGNED(read_reg1) ) );  
    read_data2 <= regs_value( TO_INTEGER( UNSIGNED(read_reg2) ) );    
END behavioral;
