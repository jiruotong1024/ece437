/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
  test PROG(CLK,nRST,rfif);
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
`else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test(input logic CLK, output logic nRST, register_file_if.tb tbrf);
initial begin
#5;
nRST = 0;
//first write
@(negedge CLK)
nRST = 1;
tbrf.wsel = 5'b00010;
tbrf.wdat = 32'h0fff;
tbrf.WEN = 1'b1;
tbrf.rsel1 = 5'b00000;
tbrf.rsel2 = 5'b00010;
#5
$display(tbrf.rdat2);


//second write
@(negedge CLK)
tbrf.wsel = 5'b00011;
tbrf.wdat = 32'h00ff;
tbrf.WEN = 1'b1;
tbrf.rsel1 = 5'b00000;
tbrf.rsel2 = 5'b00011;
//third write
@(negedge CLK)
tbrf.wsel = 5'b00001;
tbrf.wdat = 32'h0ff0;
tbrf.WEN = 1'b1;
tbrf.rsel1 = 5'b00001;
tbrf.rsel2 = 5'b00010;
//fouth write
@(negedge CLK)
tbrf.wsel = 5'b00110;
tbrf.wdat = 32'h0123;
tbrf.WEN = 1'b1;
tbrf.rsel1 = 5'b00110;
tbrf.rsel2 = 5'b00010;

//WEN test
@(negedge CLK)
tbrf.wsel = 5'b00010;
tbrf.wdat = 32'h011f;
tbrf.WEN = 1'b0;
tbrf.rsel1 = 5'b00010;
tbrf.rsel2 = 5'b00000;
#5
//reset test
@(negedge CLK)
nRST = 0;
tbrf.rsel1 = 5'b00000;
tbrf.rsel2 = 5'b00010;
$display(tbrf.rdat1);

#5;
$finish;
end
//program test
endprogram
