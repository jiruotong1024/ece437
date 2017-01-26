/*
  alu file test bench
*/

// mapped needs this
`include "alu_file_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module alu_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  alu_file_if aif ();
  // test program
  test PROG(CLK,aif);
  // DUT
`ifndef MAPPED
  alu_file DUT(CLK,aif);
`else
  alu_file DUT(
    .\aif.port_a (aif.port_a),
    .\aif.port_b (aif.port_b),
    .\aif.ALUOP (aif.ALUOP),
    .\aif.output_port (aif.output_port),
    .\aif.negative (aif.negative),
    .\aif.zero (aif.zero),
    .\aif.overflow (aif.overflow)
  );
`endif

endmodule

program test(input logic CLK, alu_file_if.tb tbif);
initial begin
#5;

//shift left test
@(negedge CLK)
tbif.ALUOP = ALU_SLL;
tbif.port_a = 32'b00001111000011110000000011111010;
tbif.port_b = 32'b00000000000000000011111111111111;
#5
if(tbif.output_port == tbif.port_a<<tbif.port_b)
begin
$display("test1 passed!");
end
else begin
$error("test1 failed!");
end
#5
//shift right test
@(negedge CLK)
tbif.ALUOP = ALU_SRL;
tbif.port_a = 32'b00001111000011110000000011111010;
tbif.port_b = 32'b00000000000000000011111111111111;
#5
if(tbif.output_port == tbif.port_a>>tbif.port_b)
begin
$display("test2 passed!");
end
else begin
$error("test2 failed!");
end

#5
//add test
@(negedge CLK)
tbif.ALUOP = ALU_ADD;
tbif.port_a = 32'b01101111000011110000000011111010;
tbif.port_b = 32'b01100000000000000011111111111111;
#5
if(tbif.overflow == 1)
begin
$display("test3_1 passed!");
end
else begin
$error("test3_1 failed!");
end
#5
//add test
@(negedge CLK)
tbif.ALUOP = ALU_ADD;
tbif.port_a = 32'b01010101010101010101010101010101;
tbif.port_b = 32'b10101010101010101010101010101010;
#5
if(tbif.negative == 1)
begin
$display("test3_2 passed!");
end
else begin
$error("test3_2 failed!");
end
#5
//sub test
@(negedge CLK)
tbif.ALUOP = ALU_SUB;
tbif.port_a = 32'b00000000000000000000000000000011;
tbif.port_b = 32'b00000000000000000000000000000001;
#5
if(tbif.output_port == 32'b00000000000000000000000000000010)
begin
$display("test4_1 passed!");
end
else begin
$error("test4_1 failed!");
end

#5
//sub test
@(negedge CLK)
tbif.ALUOP = ALU_SUB;
tbif.port_a = 32'b10000000000000000000000000000000;
tbif.port_b = 32'b11111111111111111111111111111111;
#5
if(tbif.overflow == 0)
begin
$display("test4_2 passed!");
end
else begin
$error("test4_2 failed!");
end

#5
//and test
@(negedge CLK)
tbif.ALUOP = ALU_AND;
tbif.port_a = 32'b00001111000011110000000011111010;
tbif.port_b = 32'b00000000000000000011111111111111;
#5
if(tbif.output_port == tbif.port_a&tbif.port_b)
begin
$display("test5 passed!");
end
else begin
$error("test5 failed!");
end
#5
//or test
@(negedge CLK)
tbif.ALUOP = ALU_OR;
tbif.port_a = 32'b00001111000011110000000011111010;
tbif.port_b = 32'b00000000000000000011111111111111;
#5
if(tbif.output_port == tbif.port_a|tbif.port_b)
begin
$display("test6 passed!");
end
else begin
$error("test6 failed!");
end
#5
//xor test
@(negedge CLK)
tbif.ALUOP = ALU_XOR;
tbif.port_a = 32'b00001111000011110000000011111010;
tbif.port_b = 32'b00000000000000000011111111111111;
#5
if(tbif.output_port == tbif.port_a^tbif.port_b)
begin
$display("test7 passed!");
end
else begin
$error("test7 failed!");
end

#5
//nor test
@(negedge CLK)
tbif.ALUOP = ALU_NOR;
tbif.port_a = 32'b00001111000011110000000011111010;
tbif.port_b = 32'b00000000000000000011111111111111;
#5
if(tbif.output_port == ~(tbif.port_a|tbif.port_b))
begin
$display("test8 passed!");
end
else begin
$error("test8 failed!");
end
#5
//STL test
@(negedge CLK)
tbif.ALUOP = ALU_SLT;
tbif.port_a = 32'b10001111000011110000000011111010;
tbif.port_b = 32'b00001111000011110000000011111010;
#5
if(tbif.output_port == 1)
begin
$display("test9 passed!");
end
else begin
$error("test9 failed!");
end
#5
//SLTU test
@(negedge CLK)
tbif.ALUOP = ALU_SLTU;
tbif.port_a = 32'b00001111000011110000000011111010;
tbif.port_b = 32'b10000000000000000011111111111111;
#5
if(tbif.output_port == 1)
begin
$display("test10 passed!");
end
else begin
$error("test10 failed!");
end

$finish;
end

endprogram