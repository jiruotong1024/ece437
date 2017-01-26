org 0x0000

ori $29,$0,0xfffc
ori $1,$0,0x0014#day
ori $2,$0,0x0008#month
ori $3,$0,0x07df#year
ori $4,$0,0x0001
ori $5,$0,0x001e
ori $9,$0,0x07d0#2000year
ori $10,$0,0x016d#365days
ori $15,$0,0x0002
ori $18,$0,0x0007
ori $20,$0,0x000f
ori $21,$0,0x016d

subu $2,$2,$4
push $2
push $5
j sub_routine

sub2:
subu $3,$3,$9
push $3
push $10

sub_routine:
ori $6,$0,0x0001
ori $7,$0,0x0000

pop $8
pop $11
mult: 
  beq $8,$0,exit1
  addu $7,$7,$11
  subu $8,$8,$6
  j mult

exit1: push $7
subu $15,$15,$6
beq $15,$0,final
j sub2

final:
pop $16
pop $17
addu $16,$16,$17
addu $16,$16,$1

push $16

halt
