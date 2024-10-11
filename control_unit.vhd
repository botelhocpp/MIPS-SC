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
        branch_eq : OUT STD_LOGIC;
        branch_ne : OUT STD_LOGIC;
        branch_gtz : OUT STD_LOGIC;
        branch_lez : OUT STD_LOGIC;
        mem_read : OUT STD_LOGIC;
        mem_to_reg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        mem_write : OUT STD_LOGIC;
        mem_bw : OUT STD_LOGIC;
        alu_src : OUT STD_LOGIC;
        imm_ext : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
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
    mem_read <= '1' WHEN (op = OP_LW OR op = OP_LB OR op = OP_LBU) ELSE '0';
    mem_write <= '1' WHEN (op = OP_SW OR op = OP_SB) ELSE '0';
    pc_to_reg <= '1' WHEN (op = OP_JAL OR op = OP_JALR) ELSE '0';
    mem_bw <= '1' WHEN (op = OP_SB) ELSE '0';
    
    branch_eq <= '1' WHEN (op = OP_BEQ) ELSE '0';
    branch_ne <= '1' WHEN (op = OP_BNE) ELSE '0';
    branch_gtz <= '1' WHEN (op = OP_BGTZ) ELSE '0';
    branch_lez <= '1' WHEN (op = OP_BLEZ) ELSE '0';

    mem_to_reg <=  "01" WHEN (op = OP_LW) ELSE
                "10" WHEN (op = OP_LBU) ELSE
                "11" WHEN (op = OP_LB) ELSE
                "00";
    
    imm_ext <=  "01" WHEN (op = OP_ANDI OR op = OP_ORI OR op = OP_XORI) ELSE
                "10" WHEN (op = OP_LUI) ELSE
                "00";
    
    alu_src <= '1' WHEN (
	   op = OP_ADDI OR op = OP_ANDI OR op = OP_ORI OR
       op = OP_XORI OR op = OP_LUI  OR op = OP_LB  OR
       op = OP_LBU  OR op = OP_LW   OR op = OP_SB  OR
       op = OP_SW   OR op = OP_SLTI
    ) ELSE '0';
    
    reg_write <= '1' WHEN (
        op /= OP_JR  AND op /= OP_SB   AND op /= OP_SW   AND
        op /= OP_BEQ AND op /= OP_BGTZ AND op /= OP_BLEZ AND
        op /= OP_BNE AND op /= OP_J
    ) ELSE '0';
    
    reg_dst <=  "10" WHEN (op = OP_JAL OR op = OP_JALR) ELSE
                "01" WHEN (is_r_type = '1') ELSE
                "00";
END behavioral;
