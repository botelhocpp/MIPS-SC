----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: processor
-- Project Name: MIPS-SC
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Pairing of the datapath and the control unit to form a processor.
-- 
-- Dependencies: datapath, control_unit
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

LIBRARY MIPS;
USE MIPS.PKG_MIPS.ALL;

ENTITY processor IS
  PORT ( 
    data_in : IN reg32;
    instruction : IN reg32;
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    mem_read : OUT STD_LOGIC;
    mem_write : OUT STD_LOGIC;
    mem_bw : OUT STD_LOGIC;
    instruction_address : OUT reg32;
    data_address : OUT reg32;
    data_out : OUT reg32
  );
END processor;

ARCHITECTURE behavioral OF processor IS
    SIGNAL reg_dst : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL jump_immed : STD_LOGIC;
    SIGNAL jump_reg : STD_LOGIC;
    SIGNAL branch_eq : STD_LOGIC;
    SIGNAL branch_ne : STD_LOGIC;
    SIGNAL branch_gtz : STD_LOGIC;
    SIGNAL branch_lez : STD_LOGIC;
    SIGNAL mem_to_reg : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL alu_src : STD_LOGIC;
    SIGNAL imm_ext : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL reg_write : STD_LOGIC;
    SIGNAL pc_to_reg : STD_LOGIC;
    SIGNAL operation : instruction_t;
BEGIN
    DP_COMP: ENTITY WORK.datapath
    PORT MAP(
        instruction => instruction,
        data_in => data_in,
        reg_dst => reg_dst,
        jump_immed => jump_immed,
        jump_reg => jump_reg,
        branch_eq => branch_eq,
        branch_ne => branch_ne,
        branch_gtz => branch_gtz,
        branch_lez => branch_lez,
        mem_to_reg => mem_to_reg,
        alu_src => alu_src,
        imm_ext => imm_ext,
        reg_write => reg_write,
        pc_to_reg => pc_to_reg,
        operation => operation,
        clk => clk,
        rst => rst,
        data_address => data_address,
        instruction_address => instruction_address,
        data_out => data_out
    );
    UC_COMP: ENTITY WORK.control_unit
    PORT MAP(
        instruction => instruction,
        reg_dst => reg_dst,
        jump_immed => jump_immed,
        jump_reg => jump_reg,
        branch_eq => branch_eq,
        branch_ne => branch_ne,
        branch_gtz => branch_gtz,
        branch_lez => branch_lez,
        mem_read => mem_read,
        mem_to_reg => mem_to_reg,
        mem_write => mem_write,
        mem_bw => mem_bw,
        alu_src => alu_src,
        imm_ext => imm_ext,
        reg_write => reg_write,
        pc_to_reg => pc_to_reg,
        operation => operation
    );
    
END behavioral;
