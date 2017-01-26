`include "hazard_unit_if.vh"

// memory types
`include "cpu_types_pkg.vh"
 import cpu_types_pkg::*;

module hazard_unit (

  	hazard_unit_if huif
);
//001 EX_RegRd == ID_RegRs with lw instruction
//010 EX_RegRd == ID_RegRs 1 stage different
//011 Mem_RegRd = ID_RegRs with lw instruction
//100 Mem_RegRd = ID_RegRs 2 stage different
assign huif.hazard_type_a = (huif.EX_RegRd == huif.ID_RegRs && huif.EX_RegRd != 0) ? ((huif.lw) ? 3'b001 : 3'b010): ((huif.ID_RegRs == huif.Mem_RegRd && huif.Mem_RegRd != 0) ? ((huif.lw_later) ? 3'b011 : 3'b100) : 3'b000);
assign huif.hazard_type_b = (huif.EX_RegRd == huif.ID_RegRt && huif.EX_RegRd != 0) ? ((huif.lw) ? 3'b001 : 3'b010): ((huif.ID_RegRt == huif.Mem_RegRd && huif.Mem_RegRd != 0) ? ((huif.lw_later) ? 3'b011 : 3'b100) : 3'b000);

endmodule