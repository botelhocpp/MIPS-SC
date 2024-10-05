----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: control_unit
-- Project Name: MIPS-SC
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: The controller of the processor.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY MIPS;
USE MIPS.PKG_MIPS.ALL;

ENTITY control_unit IS
    PORT ( 
        instruction : IN reg32;
        
        reg_dst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        jump_immed : OUT STD_LOGIC;
        jump_reg : OUT STD_LOGIC;
        branch_zero : OUT STD_LOGIC;
        branch_not_zero : OUT STD_LOGIC;
        mem_read : OUT STD_LOGIC;
        mem_to_reg : OUT STD_LOGIC;
        mem_write : OUT STD_LOGIC;
        alu_src : OUT STD_LOGIC;
        reg_write : OUT STD_LOGIC;
        pc_to_reg : OUT STD_LOGIC;
        
        operation : OUT instruction_t
    );
END control_unit;

ARCHITECTURE behavioral OF control_unit IS
    SIGNAL op : instruction_t;
    SIGNAL is_r_type : STD_LOGIC;
BEGIN
    -- Internal Signals
    
    op <= DecodeInstruction(instruction);
    is_r_type <= '1' WHEN (instruction(31 DOWNTO 26) = "000000") ELSE '0';

    -- Control Signals

    operation <= op;

    jump_immed <= '1' WHEN (op = OP_J OR op = OP_JAL) ELSE '0';
    jump_reg <= '1' WHEN (op = OP_JR OR op = OP_JALR) ELSE '0';
    alu_src <= '1' WHEN (op = OP_LW OR op = OP_SW OR op = OP_ADDI) ELSE '0';
    mem_to_reg <= '1' WHEN (op = OP_LW) ELSE '0';
    mem_read <= '1' WHEN (op = OP_LW) ELSE '0';
    mem_write <= '1' WHEN (op = OP_SW) ELSE '0';
    branch_zero <= '1' WHEN (op = OP_BEQ) ELSE '0';
    branch_not_zero <= '1' WHEN (op = OP_BNE) ELSE '0';
    pc_to_reg <= '1' WHEN (op = OP_JAL OR op = OP_JALR) ELSE '0';
    
    reg_write <= '1' WHEN (
        is_r_type = '1' OR op = OP_LW OR op = OP_ADDI
        OR op = OP_JAL
    ) ELSE '0';
    
    reg_dst <=  "10" WHEN (op = OP_JAL OR op = OP_JALR) ELSE
                "01" WHEN (is_r_type = '1') ELSE
                "00";
END behavioral;
