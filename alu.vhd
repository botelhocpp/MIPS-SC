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
        sel : IN instruction_t;
        zero : OUT STD_LOGIC;
        res : OUT reg32
    );
END alu;

ARCHITECTURE behavioral OF alu IS
    CONSTANT CONST_ONE : reg32 := (0 => '1', OTHERS => '0');
    CONSTANT CONST_ZERO : reg32 := (OTHERS => '0');
    
    SIGNAL Q : reg32;
BEGIN
    res <= Q;
    
    WITH sel SELECT
        Q <=    (reg32(sreg32(op1) + sreg32(op2)))                          WHEN OP_ADD | OP_ADDI | OP_LW | OP_SW,
                (reg32(sreg32(op1) - sreg32(op2)))                          WHEN OP_SUB | OP_BEQ | OP_BNE,
                (op1 AND op2)                                               WHEN OP_AND,
                (op1 OR op2)                                                WHEN OP_OR,
                (op1 XOR op2)                                               WHEN OP_XOR,
                (op1 NOR op2)                                               WHEN OP_NOR,
                (reg32(SHIFT_LEFT(ureg32(op1), TO_INTEGER(ureg32(op2)))))   WHEN OP_SLLV,
                (reg32(SHIFT_RIGHT(sreg32(op1), TO_INTEGER(ureg32(op2)))))  WHEN OP_SRAV,
                (reg32(SHIFT_RIGHT(ureg32(op1), TO_INTEGER(ureg32(op2)))))  WHEN OP_SRLV,
                (CONST_ONE WHEN(op1 < op2) ELSE CONST_ZERO)                 WHEN OP_SET_LT,
                (OTHERS => '0')                                             WHEN OTHERS;
	
	zero <= '1' WHEN (Q = CONST_ZERO) ELSE '0';
END ARCHITECTURE;
