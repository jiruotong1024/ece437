`include "request_unit_if.vh"
// memory types
`include "cpu_types_pkg.vh"
 import cpu_types_pkg::*;

module request_unit (
	input logic CLK, nRST,
  request_unit_if ruif
);

logic tempdmemREN, tempdmemWEN, tempimemREN,next_dmemREN, next_dmemWEN,next_imemREN;

assign ruif.dmemREN = tempdmemREN;
assign ruif.dmemWEN = tempdmemWEN;
assign ruif.imemREN = tempimemREN;

always_ff @ (posedge CLK, negedge nRST)begin
if (nRST == 0)begin
	tempimemREN <= 1;
	tempdmemWEN <= 0;
	tempdmemREN <= 0;
	end
else begin
	tempdmemREN <= next_dmemREN;
	tempdmemWEN <= next_dmemWEN;
	tempimemREN <= next_imemREN;
	end
end

always_comb begin
next_imemREN = 1;
next_dmemWEN = tempdmemWEN;
next_dmemREN = tempdmemREN;
if(ruif.dhit == 1)begin
	next_dmemWEN = 0;
	next_dmemREN = 0;
	end
if(ruif.ihit == 1)begin
next_dmemREN = ruif.MemtoReg;
next_dmemWEN = ruif.MemWrite;
 end
end
endmodule