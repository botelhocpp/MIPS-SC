----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: testbench
-- Project Name: MIPS-SC
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Testbench for the processor, connecting it to the memories.
-- 
-- Dependencies: processor, memory
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY MIPS;
USE MIPS.PKG_MIPS.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE behavioral OF testbench IS
    CONSTANT CLK_PERIOD : TIME := 20ns;
    
    -- Intermediary Signals
    SIGNAL cpu_data_in : reg32;
    SIGNAL cpu_data_out : reg32;
    SIGNAL data_address : reg32;
    SIGNAL instruction_address : reg32;
    SIGNAL instruction : reg32;
    SIGNAL mem_write : STD_LOGIC;
    SIGNAL mem_read : STD_LOGIC;
    SIGNAL mem_bw : STD_LOGIC;
    
    -- Common Signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';
    
BEGIN
    PROCESSOR_COMP: ENTITY WORK.processor
    PORT MAP ( 
        data_in => cpu_data_in,
        instruction => instruction,
        clk => clk,
        rst => rst,
        mem_read => mem_read,
        mem_write => mem_write,
        mem_bw => mem_bw,
        instruction_address => instruction_address,
        data_address => data_address,
        data_out => cpu_data_out
    );
    RAM_COMP: ENTITY WORK.memory
    GENERIC MAP (
        START_ADDR => x"10010000",
        CONTENTS_FILE => "data.txt"
    )
    PORT MAP ( 
        data_in => cpu_data_out,
        address => data_address,
        we => mem_write,
        oe => mem_read,
        bw => mem_bw,
        clk => clk,
        data_out => cpu_data_in
    );
    ROM_COMP: ENTITY WORK.memory
    GENERIC MAP (
        START_ADDR => x"00400000",
        CONTENTS_FILE => "code.txt"
    )
    PORT MAP ( 
        data_in => (OTHERS => '0'),
        address => instruction_address,
        we => '0',
        oe => '1',
        bw => '0',
        clk => clk,
        data_out => instruction
    );
    
    clk <= NOT clk AFTER CLK_PERIOD/2;
    
    PROCESS
    BEGIN
        rst <= '1';
        WAIT FOR CLK_PERIOD/4;
        
        rst <= '0';
        WAIT;
    END PROCESS;
END behavioral;