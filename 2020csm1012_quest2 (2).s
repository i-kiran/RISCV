#2020csm1012
#Kirandeep Kaur
.data
.byte 0
.byte 11
.byte 0
.byte 0
.byte 0
.byte 11
.byte 6
.byte 15
load_word   : .byte 3
store_word  : .byte 35
add_sub_xor : .byte 51
slli_       : .byte 19
beq_        : .byte 103
jal_        : .byte 111

.text
lui x5 , 0x10000              # x5-----> initial address of the string
lui    x7 , 0x10000
addi x6 , x0 , 0x100
slli x6 , x6 ,4
add x6 , x6 , x7               # x6----> desired address to store string
addi x7 , x0 , 7               # x7----> string length-1
lui x8 , 0x10000
lui x9 , 0x01
add x9 , x9 , x8
addi x9 , x9 , 8
jal x0 , store_string

store_string:
addi x14 , x14 , 1             # x14---> counter
lb x15 , 0(x5)                 # &[default location] --> x15
sb x15 , 0(x6)                 # x15--->&[desired address]
addi x5 , x5 , 1
addi x6 , x6 , 1
ble x14 , x7 , store_string    #if counter <= string length , continue storing 
jal x0 , fetch_opcode          # els fetch the opcode now

fetch_opcode:
lui x5 , 0x10000              #initializing back the address of string in x5
lb x20 , 6(x5)                #load second last 
slli x20 , x20 , 4            #shift it by 2
lb x21 , 7(x5)                #load last
add x20,x20 , x21             #addi them to get last 8 bits
andi x20 , x20 , 0x7f            #extracting last 7bits in x20

auipc x21 , 65536
addi x21 , x21 , -88          #load the opcode for lw
lb x22 , 0(x21)
beq x20 , x22 , I             #if opcode matches then its I type

auipc x21 , 65536
addi x21 , x21 , -103        #load the opcode for sw
lb x22 , 0(x21)
beq x20 , x22 , S            #if opcode matches then its S type

auipc x21 , 65536   
addi x21 , x21 , -118        #load the add/xor/sub opcode
lb x22 , 0(x21)
beq x20 , x22 , R            #if it matches then its R type

auipc x21 , 65536
addi x21 , x21 , -133        #load the slli opcode
lb x22 , 0(x21)
beq x20 , x22 , I            #if it matches then its I type 

auipc x21 , 65536            #load the beq opcode
addi x21, x21 , -148
lb x22 , 0(x21)
beq x20 , x22 , S_B          #if it matches then its SB type

auipc x21 , 65536
addi x21, x21 , -163         #load the jal opcode
lb x22 , 0(x21) 
beq x20 , x22 , UJ           #if it matches the its UJ type

jal x0 , exit


S:    sb x20 , 0(x9)		  #storing the opcode at 0x10001008

	  lb x23 , 0(x5)
      slli x23 , x23 , 3
      lb x24 , 1(x5)
      andi x24 , x24 14
      srli x24 , x24 , 1
      add x24 , x23, x24
      slli x24 , x24 , 4
      lb x25 , 5(x5)
      add x25 x24 , x25
      slli x25 , x25 , 1
      lb x26 , 6(x5)
      andi x26 , x26 , 8
      srli x26 , x26 , 3
      add x26 , x26 , x25
      
      sb x26 , 4(x9)         #storing the immediate field
      

       lb  x23 , 4(x5)
     andi x23 , x23 , 7
     sb x23 , 8(x9)         #load the byte at 4th position and mask with 0111(i.e.4) to obtain last 3 bits of funct3
     
     
     lb x23 , 3(x5)
     slli x23 , x23 , 4
     lb x24 , 4(x5)
     add x25 , x24 , x23
     andi x26 , x25 , 248
     srli x27 , x26 , 3
     sb x27 , 12(x9)        #load the byte at 3rd add with 4th position and mask with 2480 to obtain first 5 bits of rs1
     
     lb x23 , 1(x5)
     slli x23 , x23 , 4
     lb x24 , 2(x5)
     add x25 , x24 , x23
     andi x26 , x25 , 31 
     sb x26 , 16(x9)       #load the byte at 1st and 2nd postiom and mask with 31 to extract last 5 bits of rs2
     
     jal x0 , exit


I:   sb x20 , 0(x9)		  #storing the opcode at 0x10001008
     
     lb x23 , 5(x5)
	 slli x23 , x23 , 4
     lb x24 , 6(x5)
     add x25 , x24 , x23
     andi x26 , x25 , 248 
     srli x27 , x26 , 3   
     sb x27 , 4(x9)			#load the byte at position 5 and 6 and extracting the rd(resource destination reg)
	 
     lb  x23 , 4(x5)
     andi x23 , x23 , 7
     sb x23 , 8(x9)         #load the byte at 4th position and mask with 0111(i.e.4) to obtain last 3 bits of funct3

     lb x23 , 3(x5)
     slli x23 , x23 , 4
     lb x24 , 4(x5)
     add x25 , x24 , x23
     andi x26 , x25 , 248
     srli x27 , x26 , 4
     sb x27 , 12(x9)        #load the byte at 3rd add with 4th position and mask with 248 to obtain first 5 bits of rs1

	 lb x23 , 0(x5)
     slli x23 , x23 , 4
     lb x24 , 1(x5)
     add x24 , x23 , x24
     slli x24 , x24 , 4
     lb x25 , 2(x5)
     add x25 , x24 , x25 
     sb x25 , 16(x9)        #load 0th,1stand 2nd byte positions to form 11:0 immediate field
     jal x0 , exit

R:   sb x20 , 0(x9)       #storing the opcode at 0x10001008

	 lb x23 , 5(x5)
	 slli x23 , x23 , 4
     lb x24 , 6(x5)
     add x25 , x24 , x23
     andi x26 , x25 , 248 
     srli x27 , x26 , 3   
     sb x27 , 4(x9)			#load the byte at position 5 and 6 and extracting the rd(resource destination reg)
	 
     lb  x23 , 4(x5)
     andi x23 , x23 , 7
     sb x23 , 8(x9)         #load the byte at 4th position and mask with 0111(i.e.4) to obtain last 3 bits of funct3
     
     lb x23 , 3(x5)
     slli x23 , x23 , 4
     lb x24 , 4(x5)
     add x25 , x24 , x23
     andi x26 , x25 , 248
     srli x27 , x26 , 3
     sb x27 , 12(x9)        #load the byte at 3rd add with 4th position and mask with 2480 to obtain first 5 bits of rs1
     
     lb x23 , 1(x5)
     slli x23 , x23 , 4
     lb x24 , 2(x5)
     add x25 , x24 , x23
     andi x26 , x25 , 31 
     sb x26 , 16(x9)       #load the byte at 1st and 2nd postiom and mask with 31 to extract last 5 bits of rs2
     
     lb x23 , 0(x5)
     slli x23 , x23 , 4
     lb x24 , 1(x5)
     add x25 , x24 , x23
     andi x26 , x25 , 254
     sb x26 , 20(x9)         #load 0th and 1st byte and mask woth 254 to extract first 7 bits of functc 7
     
     jal x0 , exit

S_B: sb x20 , 0(x9)       #storing the opcode at 0x10001008
	
     lb x23 , 0(x5)
     andi x23 , x23 , 8
     slli x23 , x23 , 3
     srli x23 , x23 , 1
     lb x24 , 6(x5)
     andi x24 , x24 , 8
     slli x24 , x24 , 1
     add x24 , x24 , x23
     slli x24 , x24 , 3
     lb x25 , 0(x5)
     andi x25 , x25 , 7
     add x25 , x24 , x25
     lb x26 , 1(x5)
     andi x26 , x26 , 14
     add x26 , x26 , x25
     slli x26 , x26 ,3
     lb x27 , 5(x5)
     add x27 , x26 , x27
     slli x27 , x27 , 1
     sb  x27 , 4(x9)
     
     
     

	 lb  x23 , 4(x5)
     andi x23 , x23 , 7
     sb x23 , 8(x9)         #load the byte at 4th position and mask with 0111(i.e.4) to obtain last 3 bits of funct3
     
     lb x23 , 3(x5)
     slli x23 , x23 , 4
     lb x24 , 4(x5)
     add x25 , x24 , x23
     andi x26 , x25 , 248
     srli x27 , x26 , 3
     sb x27 , 12(x9)        #load the byte at 3rd add with 4th position and mask with 2480 to obtain first 5 bits of rs1
     
     lb x23 , 1(x5)
     slli x23 , x23 , 4
     lb x24 , 2(x5)
     add x25 , x24 , x23
     andi x26 , x25 , 31 
     sb x26 , 16(x9)       #load the byte at 1st and 2nd postiom and mask with 31 to extract last 5 bits of rs2
     
	 jal x0 , exit

UJ: sb x20 , 0(x9)       #storing the opcode at 0x10001008
	
    lb x23 , 0(x5)
    andi x23 , x23 , 8
    srli x23 , x23 , 3
    slli x23 , x23 , 4
    lb x24 , 3(x5)
    add x24 , x24 , x23
    slli x24 , x24 , 4
    lb x25 , 4(x5)
    add x25 , x25 , x24
    slli x24 , x24 , 4
    lb x26 , 5(x5)
    add x26 , x26 , x25
    slli x26 , x26 , 4
    lb x27 , 6(x5)
    add x27 , x7 , x26
    slli x27 , x27 , 1
    lb x28 , 2(x5)
    andi x28 , x28 , 1
    add x28 , x28 , x27
    slli x28 , x28 , 3
    lb x29 , 0(x5)
    andi x29 , x29 , 7
    add x29 , x28 , x29
    slli x29 , x29 , 4
    lb x30 , 1(x5)
    add x30 , x30 , x29
    slli x30 , x30 , 3
    lb x31 , 2(x5)
    andi x31 , x31 ,4
    srli x31 , x31 , 1
    add x31 , x31 , x30 
    slli x31 , x31 , 1
    sb x31 , 4(x9)
    
    lb x23 , 5(x5)
    slli x23 , x23 , 4
    lb x24 , 6(x5)
    add x25 , x24 , x23
    andi x26 , x25 , 248 
    srli x27 , x26 , 3   
    sb x27 , 8(x9)			#load the byte at position 5 and 6 and extracting the rd(resource destination reg)
	jal x0 , exit

exit: