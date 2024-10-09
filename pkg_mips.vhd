----------------------------------------------------------------------------------
-- Engineer: Pedro Botelho
-- 
-- Module Name: pkg_mips
-- Project Name: MIPS-SC
-- Target Devices: Zybo Zynq-7000
-- Language Version: VHDL-2008
-- Description: Common parameters for the MIPS-SC project.
-- 
-- Dependencies: none
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY STD;
USE STD.TEXTIO.ALL;

PACKAGE pkg_mips IS
    CONSTANT CONST_ADDR_NUM : INTEGER := 2048;
    
    SUBTYPE reg32 IS STD_LOGIC_VECTOR(31 DOWNTO 0);
    SUBTYPE ureg32 IS UNSIGNED(31 DOWNTO 0);
    SUBTYPE sreg32 IS SIGNED(31 DOWNTO 0);
   
    SUBTYPE byte IS STD_LOGIC_VECTOR(7 DOWNTO 0);
    SUBTYPE nibble IS STD_LOGIC_VECTOR(3 DOWNTO 0);
    
    TYPE mem_array_t IS ARRAY (0 TO CONST_ADDR_NUM - 1) OF reg32;
    
    TYPE instruction_t IS (
        OP_SLL,
        OP_SRL,
        OP_SRA,
        OP_SLLV,
        OP_SRLV,
        OP_SRAV,
        OP_JR,
        OP_JALR,
        OP_ADD,
        OP_SUB,
        OP_AND,
        OP_OR,
        OP_XOR,
        OP_NOR,
        OP_SLT,
        OP_ADDI,
        OP_ANDI,
        OP_ORI,
        OP_XORI,
        OP_LUI,
        OP_LB,
        OP_LBU,
        OP_LW,
        OP_SB,
        OP_SW,
        OP_BEQ,
        OP_BGTZ,
        OP_BLEZ,
        OP_BNE,
        OP_J,
        OP_JAL,
        OP_INVALID
    );
    
    PURE FUNCTION DecodeInstruction(instruction : reg32) RETURN instruction_t;
    PURE FUNCTION HexToBin(hex : CHARACTER) RETURN nibble;
    IMPURE FUNCTION InitMEM(file_name : STRING) RETURN mem_array_t;

END pkg_mips;

PACKAGE BODY pkg_mips IS
    PURE FUNCTION DecodeInstruction(instruction : reg32) RETURN instruction_t IS
        VARIABLE inst : instruction_t;
        ALIAS opcode IS instruction(31 DOWNTO 26);
        ALIAS funct IS instruction(5 DOWNTO 0);
    BEGIN
        IF(opcode = "000000") THEN
            WITH funct SELECT
                inst := OP_SLL      WHEN "000000",
                        OP_SRL      WHEN "000010",
                        OP_SRA      WHEN "000011",
                        OP_SLLV     WHEN "000100",
                        OP_SRLV     WHEN "000110",
                        OP_SRAV     WHEN "000111",
                        OP_JR       WHEN "001000",
                        OP_JALR     WHEN "001001",
                        OP_ADD      WHEN "100000",
                        OP_SUB      WHEN "100010",
                        OP_AND      WHEN "100100",
                        OP_OR       WHEN "100101",
                        OP_XOR      WHEN "100110",
                        OP_NOR      WHEN "100111",
                        OP_SLT      WHEN "101010",
                        OP_INVALID  WHEN OTHERS;
        ELSE
            WITH opcode SELECT
                inst := OP_ADDI     WHEN "001000",
                        OP_ANDI     WHEN "001100",
                        OP_ORI     WHEN "001101",
                        OP_XORI     WHEN "001110",
                        OP_LUI      WHEN "001111",
                        OP_LB       WHEN "100000",
                        OP_LBU      WHEN "100100",
                        OP_LW       WHEN "100011",
                        OP_SB       WHEN "101000",
                        OP_SW       WHEN "101011",
                        OP_BEQ      WHEN "000100",
                        OP_BNE      WHEN "000101",
                        OP_BLEZ     WHEN "000110",
                        OP_BGTZ     WHEN "000111",
                        OP_J        WHEN "000010",
                        OP_JAL      WHEN "000011",
                        OP_INVALID  WHEN OTHERS;
        END IF;
        RETURN inst;
    END DecodeInstruction;   
    
    PURE FUNCTION HexToBin(hex : CHARACTER) RETURN nibble IS
        VARIABLE bin : nibble;
    BEGIN
        CASE hex IS
            WHEN '0' => bin := "0000";
            WHEN '1' => bin := "0001";
            WHEN '2' => bin := "0010";
            WHEN '3' => bin := "0011";
            WHEN '4' => bin := "0100";
            WHEN '5' => bin := "0101";
            WHEN '6' => bin := "0110";
            WHEN '7' => bin := "0111";
            WHEN '8' => bin := "1000";
            WHEN '9' => bin := "1001";
            WHEN 'A' | 'a' => bin := "1010";
            WHEN 'B' | 'b' => bin := "1011";
            WHEN 'C' | 'c' => bin := "1100";
            WHEN 'D' | 'd' => bin := "1101";
            WHEN 'E' | 'e' => bin := "1110";   
            WHEN 'F' | 'f' => bin := "1111";
            WHEN OTHERS => bin := "0000";     
        END CASE;
        
        RETURN BIN;
    END HexToBin;

    
    IMPURE FUNCTION InitMEM(file_name : STRING) RETURN mem_array_t IS
      FILE text_file : TEXT;
      VARIABLE text_line : LINE;
      VARIABLE contents : mem_array_t := (OTHERS => (OTHERS => '0'));
      VARIABLE i : INTEGER := 0;
      VARIABLE success : FILE_OPEN_STATUS;
      VARIABLE hex_string : STRING(1 TO 8);
    BEGIN
        FILE_OPEN(success, text_file, file_name, READ_MODE);
        IF (success = OPEN_OK) THEN
          WHILE NOT ENDFILE(text_file) LOOP
            READLINE(text_file, text_line);
            READ(text_line, hex_string);
            
            FOR j IN 1 TO 8 LOOP
			     contents(i)((8 - j + 1)*4 - 1 DOWNTO (8 - j)*4) := HexToBin(hex_string(j));
            END LOOP;
            
            i := i + 1;
          END LOOP;
          
          FOR j IN i TO CONST_ADDR_NUM - 1 LOOP
            contents(j) := (OTHERS => '0');
          END LOOP;
      END IF;
      RETURN contents;
    END FUNCTION;
END pkg_mips;
