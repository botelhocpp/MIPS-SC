----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: datapath
-- Project Name: MIPS-SC
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: The data processing unit of the processor.
-- 
-- Dependencies: register_file, generic_register, alu
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY MIPS;
USE MIPS.PKG_MIPS.ALL;

ENTITY datapath IS
  PORT ( 
    instruction : IN reg32;
    data_in : IN reg32;
    
    reg_dst : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    jump_immed : IN STD_LOGIC;
    jump_reg : IN STD_LOGIC;
    branch_eq : IN STD_LOGIC;
    branch_ne : IN STD_LOGIC;
    branch_gtz : IN STD_LOGIC;
    branch_lez : IN STD_LOGIC;
    mem_to_reg : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    alu_src : IN STD_LOGIC;
    imm_ext : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    reg_write : IN STD_LOGIC;
    pc_to_reg : IN STD_LOGIC;   
    operation : IN instruction_t;
    
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    
    data_address : OUT reg32;
    instruction_address : OUT reg32;
    data_out : OUT reg32
  );
END datapath;

ARCHITECTURE behavioral OF datapath IS
    SIGNAL branch : STD_LOGIC;
    SIGNAL alu_zero : STD_LOGIC;
    SIGNAL alu_carry : STD_LOGIC;
    
    SIGNAL pc_input : reg32;
    SIGNAL pc_output : reg32;
    SIGNAL immediate : reg32;
    SIGNAL immediate_shifted_2 : reg32;
    SIGNAL long_immediate : reg32;
    SIGNAL reg1_value : reg32;
    SIGNAL reg2_value : reg32;
    SIGNAL alu_result : reg32;

    SIGNAL pc_plus_4 : reg32;
    SIGNAL pc_adder_immed : reg32;
    
    SIGNAL pc_branch_immed_mux : reg32;
    SIGNAL pc_jump_immed_mux : reg32;
    SIGNAL alu_op2_mux : reg32;
    SIGNAL write_data_mux : reg32;
    SIGNAL write_reg_mux : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL mem_to_reg_mux : reg32;

BEGIN
    PC_REG: ENTITY WORK.generic_register
    GENERIC MAP ( INIT_VALUE => x"00400000" )
    PORT MAP (
        D => pc_input,
        ld => '1',
        clk => clk,
        rst => rst,
        Q => pc_output
    );
    REGS_COMP : ENTITY WORK.register_file
    PORT MAP(
         write_data => write_data_mux,
         read_reg1 => instruction(25 DOWNTO 21),
         read_reg2 => instruction(20 DOWNTO 16),
         write_reg => write_reg_mux,
         write_en => reg_write,
         clk => clk,
         rst => rst,
         read_data1 => reg1_value,
         read_data2 => reg2_value
    );
    ALU_COMP : ENTITY WORK.alu
    PORT MAP(
        op1 => reg1_value, 
        op2 => alu_op2_mux,
        shamt => instruction(10 DOWNTO 6),
        sel => operation,
        zero => alu_zero,
        carry => alu_carry,
        res => alu_result
    );
    
    data_out <= reg2_value;
    data_address <= alu_result;
    
    -- Immediate Control
    WITH imm_ext SELECT
        immediate <= reg32(RESIZE(SIGNED(instruction(15 DOWNTO 0)), 32))    WHEN "00",
                     reg32(RESIZE(UNSIGNED(instruction(15 DOWNTO 0)), 32))  WHEN "01",
                     instruction(15 DOWNTO 0) & x"0000"                     WHEN OTHERS;   
    immediate_shifted_2 <= immediate(29 DOWNTO 0) & "00";
    long_immediate <= pc_output(31 DOWNTO 28) & instruction(25 DOWNTO 0) & "00";
    
    -- Branch Control
    branch <= '1' WHEN (
        (alu_zero = '1' AND branch_eq = '1') OR
        (alu_zero = '0' AND branch_ne = '1') OR
        ((alu_zero = '0' AND alu_carry = '0') AND branch_gtz = '1') OR
        ((alu_zero = '1' OR alu_carry = '1') AND branch_lez = '1')
    ) ELSE '0';
    
    -- Data Muxes
    alu_op2_mux <= immediate WHEN (alu_src = '1') ELSE reg2_value;
    write_data_mux <= pc_plus_4 WHEN (pc_to_reg = '1') ELSE mem_to_reg_mux;
    
    WITH mem_to_reg SELECT
        mem_to_reg_mux <= alu_result                                    WHEN "00",
                          data_in                                       WHEN "01",
                          x"000000" & data_in(7 DOWNTO 0)               WHEN "10",
                          reg32(RESIZE(sreg32(data_in(7 DOWNTO 0)), 32))WHEN OTHERS;
    
    WITH reg_dst SELECT
        write_reg_mux <= instruction(20 DOWNTO 16) WHEN "00",
                         instruction(15 DOWNTO 11) WHEN "01",
                         "11111"                   WHEN OTHERS;
    
    -- PC Control
    instruction_address <= pc_output;
    pc_plus_4 <= reg32(ureg32(pc_output) + 4);
    pc_adder_immed <= reg32(sreg32(pc_plus_4) + sreg32(immediate_shifted_2));
    
    -- PC Control (Mux)
    pc_branch_immed_mux <= pc_adder_immed WHEN (branch = '1') ELSE pc_plus_4;
    pc_jump_immed_mux <= long_immediate WHEN (jump_immed = '1') ELSE pc_branch_immed_mux;
    pc_input <= reg1_value WHEN (jump_reg = '1') ELSE pc_jump_immed_mux;
END Behavioral;
