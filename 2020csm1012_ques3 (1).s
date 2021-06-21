#2020csm1012
#Kirandeep Kaur
.data

m : .byte 3
n : .byte 6


.text

lui x5 , 0x10000
lui x6 , 0x25
srli x6 , x6 , 4
add x5 , x5 , x6      #x5--->destination address
auipc x6 65536	
addi x6 x6 -16	      #x6---> address of m
auipc x7 65536	
addi x7 x7 -23		  #x7---> address of n
lb x6 , 0(x6)         
addi x6 , x6 , 2      #x6--->m+2 value as first 2 values need to be ignored
lb x7 , 0(x7)      
add x23 , x0 , x7    #x23--->n
addi x7 , x7 , 2      #x7---> n+2 value as first 2 values need to be ignored

addi x8 , x8 , 0      #base val 0
addi x9 , x9 , 1      #base val 1
lui x10 0x10001       #initial evaluating address
add x22 , x22 , x10
sb x8 0(x10)
sb x9 1(x10)
addi x10 , x10 , 1

fib:
addi x10 , x10 , 1
addi x31 , x31 , 1
addi x10 , x10 , -1
lb x11 , 0(x10)
addi x10 , x10 , -1
lb x12 , 0(x10)
add x15 , x12 , x11
addi x10 , x10 , 2
sb x15 , 0(x10)
ble x31 , x7 , fib
jal x0 , store_fib

store_fib:
add x22, x22 , x6        #adding initial fib stored address to m+1 to get first value
lb x20 , 0(x22)
sb x20 , 0(x5)
addi x5 , x5 , 1
addi x22 ,x22 , 1
addi x24 , x24 , 1
loop:
addi x24 , x24 ,1
lb x20 , 0(x22)
sb x20 , 0(x5)
addi x5 , x5 , 1
addi x22 , x22 , 1
ble x24 , x23 , loop
exit:











end: