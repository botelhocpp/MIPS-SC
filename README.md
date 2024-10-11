# MIPS-SC
## A complete implementation of the single-cycle model of the MIPS processor, made in VHDL for teaching purposes.

<p align="center">
 <a href="#processor">Processor</a> •
 <a href="#assembler">Assembler</a> •
 <a href="#tools">Tools</a> • 
 <a href="#instructions">Instructions</a> • 
 <a href="#developer">Developer</a>
</p>

# Processor

The processor diagram implemented in this project is shown below:

![image](https://github.com/botelhocpp/MIPS-SC/blob/main/diagram.png)

# Assembler

Assembly code for this CPU can be converted to binary using the [SiMAS](https://github.com/botelhocpp/SiMAS/tree/main) assembler. The binary code of the instructions have to be put in the "code.txt" file and the variables used in the "data.txt" file.

# Tools

This CPU was made with VHDL-2008 and Vivado.

# Instructions

This CPU supports all major instructions of the MIPS architecture:

| Instruction | Type | Opcode  | Function         |
|:-----------:|:----:|:-------:|:----------------:|
|     sll     |   R  | 000000  |     000000       |
|     srl     |   R  | 000000  |     000010       |
|     sra     |   R  | 000000  |     000011       |
|    sllv     |   R  | 000000  |     000100       |
|    srlv     |   R  | 000000  |     000110       |
|    srav     |   R  | 000000  |     000111       |
|     jr      |   R  | 000000  |     001000       |
|    jalr     |   R  | 000000  |     001001       |
|     add     |   R  | 000000  |     100000       |
|     sub     |   R  | 000000  |     100010       |
|     and     |   R  | 000000  |     100100       |
|     or      |   R  | 000000  |     100101       |
|     xor     |   R  | 000000  |     100110       |
|     nor     |   R  | 000000  |     100111       |
|     slt     |   R  | 000000  |     101010       |
|     j       |   J  | 000010  |        -         |
|    jal      |   J  | 000011  |        -         |
|    beq      |   I  | 000100  |        -         |
|   bgtz      |   I  | 000111  |        -         |
|   blez      |   I  | 000110  |        -         |
|    bne      |   I  | 000101  |        -         |
|    addi     |   I  | 001000  |        -         |
|    slti     |   I  | 001010  |        -         |
|    andi     |   I  | 001100  |        -         |
|     ori     |   I  | 001101  |        -         |
|    xori     |   I  | 001110  |        -         |
|    lui      |   I  | 001111  |        -         |
|     lb      |   I  | 100000  |        -         |
|    lbu      |   I  | 100100  |        -         |
|     lw      |   I  | 100011  |        -         |
|     sb      |   I  | 101000  |        -         |
|     sw      |   I  | 101011  |        -         |

# Developer

My name is Pedro Botelho, and I'm a Computer Enginnering stundent at the Federal University of Ceará, in Brazil.

This program is still in the testing phase, so you can help in the development by reporting any error to the developer.

For more informations, or to report some error, send an e-mail to pedrobotelho15@alu.ufc.br.
