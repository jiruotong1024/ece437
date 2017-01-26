org 0x0000

ori $29,$0,0xfffc
ori $1,$0,0x000f
ori $2,$0,0x016d

push $1
push $2

ori $3,$0,0x0001
ori $4,$0,0x0000

pop $5
pop $6

mult: 
  beq $6,$0,exit
  subu $6,$6,$3
  addu $4,$4,$5
  j mult

exit: push $4
halt
