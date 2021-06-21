.data 
string:.asciiz "121"

.text
auipc x5 , 65536
addi  x5 , x5 , 0      # x5--> string_address
add   x6 , x0 , x5     # x6-->keeping the copy of x5 i.e. base address for string
lui   x7 , 0x10000
addi  x7 , x7 , 0x100  # x7-->address where i want to store reversed string
add  x10 , x0 , x7     # x10-->copy of x7 i.e. base of reversed string
add  x30 , x0 , x7
jal   x0 , loop
addi x20 , x0 , 0       #casual initialization
addi x21 , x21, 0       #casual initialization

loop:
lb   x23 , 0(x5)          # x23-->load each byte of the string
beq  x23 , x0 , reverse   # now if byte loaded == 0 ==> the previous one was the last byte thus jump to reverse procedure
add   x8 , x0 , x5        # x8-->this gives the address of the last element in the parsed string
sub x28 , x8 , x6    
addi x28 , x28 ,1         # string length
addi  x5 , x5 ,1          # increment the address
jal   x0 , loop           # to read next byte continue the loop

reverse:
lb    x9 , 0(x8)          # load one by one every byte stored in reverse fashion
sb   x9 , 0(x10)          # storing the byte loaded in x9 --> x7
beq   x8 , x6 , loop1     # if the present decremented address = address of 1st element of syring then jump to case
addi  x8 , x8 , -1        # decrementing x8 to point to the previous position for reversal
addi  x10 , x10 , 1       # incrementing x7 to point to nxt location to store nxt byte
jal x0 , reverse

loop1:
beq x20 , x21 ,driver
bne x20 , x21 , exit

driver:
addi x27 , x27 ,1
addi x25 , x0 , 1         #storing 1 (true) in x25 if string is a pallindrome
lb x20 , 0(x6)            #load a byte of original string
lb x21 , 0(x30)           #load a byte of reversed string
addi x30 , x30 , 1
addi x6 , x6 , 1
ble x28 , x27 , loop1


exit:
addi x25 , x0 , 0 #storing 0 (false) in x25 if string is not pallindrome