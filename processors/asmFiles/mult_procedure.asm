org 0x0000

ori $29,$0,0xfffc
ori $1,$0,0x0003
ori $2,$0,0x0007
ori $3,$0,0x0002
ori $4,$0,0x0004
ori $15,$0,0x0003

push $1
push $2

sub_routin:
ori $5,$0,0x0001
ori $6,$0,0x0000

sub2:
pop $7
pop $8
mult: 
  beq $8,$0,exit1
  addu $6,$7,$6
  subu $8,$8,$5
  j mult

exit1: push $6

subu $15,$15,$5

beq $15,$0,final
beq $15,$5,sub_routin

push $3
push $4

j sub_routin

final:

halt
