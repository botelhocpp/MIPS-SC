----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: alu
-- Project Name: MIPS-SC
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Performs arithmetic and logic operations on two operands.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY MIPS;
USE MIPS.PKG_MIPS.ALL;

ENTITY alu IS
    PORT(
        op1 : IN reg32;
        op2 : IN reg32;
        shamt : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        sel : IN instruction_t;
        zero : OUT STD_LOGIC;
        carry : OUT STD_LOGIC;
        res : OUT reg32
    );
END alu;

ARCHITECTURE behavioral OF alu IS
    CONSTANT CONST_ONE : reg32 := (0 => '1', OTHERS => '0');
    CONSTANT CONST_ZERO : reg32 := (OTHERS => '0');
    
    SIGNAL Q : reg32;
    SIGNAL set_lt : reg32;
    SIGNAL shift_amount : ureg32;
BEGIN
    res <= Q;
    shift_amount <= ureg32(RESIZE(ureg32(shamt), 32))
                    WHEN(sel = OP_SLL OR sel = OP_SRL OR sel = OP_SRA) ELSE 
                    ureg32(op1);
    
    WITH sel SELECT
        Q <=    (reg32(sreg32(op1) + sreg32(op2)))                          WHEN OP_ADD | OP_ADDI | OP_LW | OP_LB | OP_LBU | OP_SW | OP_SB,
                (reg32(sreg32(op1) - sreg32(op2)))                          WHEN OP_SUB | OP_BEQ | OP_BNE | OP_BGTZ | OP_BLEZ,
                (op1 AND op2)                                               WHEN OP_AND | OP_ANDI,
                (op1 OR op2)                                                WHEN OP_OR | OP_ORI,
                (op1 XOR op2)                                               WHEN OP_XOR | OP_XORI,
                (op1 NOR op2)                                               WHEN OP_NOR,
                (reg32(SHIFT_LEFT(ureg32(op2), TO_INTEGER(shift_amount))))  WHEN OP_SLLV | OP_SLL,
                (reg32(SHIFT_RIGHT(sreg32(op2), TO_INTEGER(shift_amount)))) WHEN OP_SRAV | OP_SRA,
                (reg32(SHIFT_RIGHT(ureg32(op2), TO_INTEGER(shift_amount)))) WHEN OP_SRLV | OP_SRL,
                (set_lt)                                                    WHEN OP_SLT | OP_SLTI,
                (op2)                                                       WHEN OTHERS;
	
	zero <= '1' WHEN (Q = CONST_ZERO) ELSE '0';
	carry <= '1' WHEN (op1 < op2) ELSE '0';
	set_lt <= CONST_ONE WHEN(op1 < op2) ELSE CONST_ZERO;
END ARCHITECTURE;
