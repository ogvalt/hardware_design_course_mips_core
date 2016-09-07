module nextPC(i_pc, i_imm, i_jump, i_beq, i_bne, i_zerof, o_nextpc, o_pcsrc);
  input   [31:0]  i_pc;
  input   [25:0]  i_imm;
  input           i_jump;
  input           i_beq;
  input			  i_bne;
  input           i_zerof;
  output  [31:0]  o_nextpc;
  output          o_pcsrc;

  wire    [31:0]  o_add;
  wire    [31:0]  imm_conc;
  wire    [31:0]  o_ext;
  wire    [31:0]  o_shift;
  wire            i_zerof;
  wire			  inv_zero;
  
  assign imm_conc = {i_pc[31:28],i_imm[25:0],{2{i_zerof}}};
  assign inv_zero = ~i_zerof;
  assign o_pcsrc = i_jump|(i_zerof&i_beq)|(~i_zerof&i_bne);
  
  signExtend EXT(i_imm[15:0], inv_zero, o_ext);
  //shiftLeftBy2 shift(o_ext,o_shift);
  adder ADD(i_pc,o_ext,o_add); //adder ADD(i_pc,o_shift,o_add);
  mux2in1 MUX(o_add, imm_conc, i_zerof, o_nextpc);
  
endmodule
module nextPC_testbench();
  reg [31:0] i_pc;
  reg [25:0] i_imm;
  reg        i_jump;
  reg        i_beq;
  reg 		 i_bne;
  reg        i_zerof;
  wire [31:0]o_nextpc;
  wire       o_pcsrc;
  
  nextPC nPC(i_pc, i_imm, i_jump, i_beq, i_bne, i_zerof, o_nextpc, o_pcsrc);
  
  initial begin
    #1;
    i_pc <=  32'b100;
    i_imm <= 26'hfffc;
    i_jump <= 1'b0;
    i_beq <= 1'b0;
	i_bne <= 1'b1;
    i_zerof <= 1'b0;
  end
endmodule