# RISCV

<used venus for writing and executing these codes>

1. “PALINDROME” 
Write a procedure to identify whether a given string is a palindrome or not. The string
can contain aplhanumeric values too.

2.Assembly program to decode a machine code 
As you are aware, an instruction in RISC-V ISA is encoded and represented as a 32bit
(word) machine code. Assume that such a word is stored at a location in memory (say,
0x10001000). Write a program that reads this 32bit word, extracts the opcode field to find
out if its an instruction or not. If its an instruction, the program should then extract the
other fields appropriately and store them in consecutive words beginning at 0x20001000.
To limit the complexity, we’ll pick only 8 native RISC-V 32bit instructions, namely, lw,
sw, add, sub, xor, slli, beq, jal. And once an instruction is identified using the

fields opcode, func3, func6/7, store the fields in the specified location followed by the val-
ues of other fields of the instruction (like, rs1, rs2, rd, imm, etc).

3.Fibonnaci series
Write a recursive procedure that generates ‘n’ Fibonnaci numbers after the first ‘m’ num-
bers. Do not consider the first two Fibonnaci numbers (seed values), ‘0’ and ‘1’ in ‘n’ and
‘m’. Give option to change the seed values, ‘n’ and ‘m’ easily. Store the generated ‘n’
fibonnaci numbers at location starting from location 0x10002500.
