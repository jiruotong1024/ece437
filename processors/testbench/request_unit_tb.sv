`include "request_unit_if.vh"

// memory types
`include "cpu_types_pkg.vh"
`timescale 1ns/1ns

module request_unit_tb;
parameter PERIOD = 20;
logic CLK = 1, nRST;

always #(PERIOD/2) CLK++;

request_unit_if ruif();

test PROG (CLK,nRST,ruif);
request_unit DUT(CLK,nRST,ruif);

endmodule

program test(
	input logic CLK,
	output logic nRST,
	request_unit_if ruif
	);

initial begin

#5;
	nRST = 0;
	#10;
	nRST = 1;
  ruif.ihit = 0;
  ruif.dhit = 0;
  ruif.MemtoReg = 0;
  ruif.MemWrite = 0;
  @(negedge CLK);
  ruif.ihit = 1;
  ruif.dhit = 0;
  ruif.MemtoReg = 0;
  ruif.MemWrite = 0;
  @(negedge CLK);
    ruif.ihit = 1;
  ruif.dhit = 1;
  ruif.MemtoReg = 0;
  ruif.MemWrite = 1;
  @(negedge CLK);
  ruif.ihit = 0;
  ruif.dhit = 1;
  ruif.MemtoReg = 1;
  ruif.MemWrite = 1;
  @(negedge CLK);
  ruif.ihit = 0;
  ruif.dhit = 1;
  ruif.MemtoReg = 0;
  ruif.MemWrite = 0;
  @(negedge CLK);
  ruif.ihit = 1;
  ruif.dhit = 0;
  ruif.MemtoReg = 0;
  ruif.MemWrite = 0;
    @(negedge CLK);
  ruif.ihit = 1;
  ruif.dhit = 0;
  ruif.MemtoReg = 1;
  ruif.MemWrite = 0;
    @(negedge CLK);
  ruif.ihit = 1;
  ruif.dhit = 0;
  ruif.MemtoReg = 0;
  ruif.MemWrite = 1;
  #50;
  $finish; 
  
end
endprogram