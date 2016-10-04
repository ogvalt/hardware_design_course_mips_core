module nextPC(i_pc, i_imm, i_jump, i_beq, i_bne, i_zerof, i_jr, i_Rs, o_nextpc, o_pcsrc);

  input   [31:0]  i_pc;
  input   [25:0]  i_imm;
  input           i_jump;
  input           i_beq;
  input			      i_bne;
  input           i_zerof;
  input           i_jr;
  input   [31:0]  i_Rs;
  output  [31:0]  o_nextpc;
  output          o_pcsrc;

  wire    [31:0]  add_out;
  wire    [31:0]  imm_concat;
  wire    [31:0]  extend;
  wire    [31:0]  o_shift;
  
  assign imm_concat = i_jr ? i_Rs : {i_pc[31:28],i_imm[25:0],2'b0};
  assign o_pcsrc = i_jump | (i_zerof&i_beq) | (~i_zerof&i_bne) | i_jr;
  
  signExtend EXT(i_imm[15:0], 1'b1, extend);
  adder ADD(i_pc, extend, add_out); 
  mux2in1 MUX(add_out, imm_concat, i_jump | i_jr, o_nextpc);
  
endmodule
