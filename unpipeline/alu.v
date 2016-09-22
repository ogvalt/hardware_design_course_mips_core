//`timescale 1ps/1ps;
module alu(i_op1, i_op2, i_control, o_result, o_overflow, o_zf);

localparam F_AND = 6'b100100, F_OR = 6'b100101,   F_ADD = 6'b100000;
localparam F_SUB = 6'b100010, F_SLT = 6'b101010, F_NOR = 6'b100111;
localparam F_ADDU = 6'b100001, F_SUBU = 6'b100011, F_XOR = 6'b100110;
localparam F_SLTU = 6'b101011, F_SLLV = 6'b000100, F_LUI = 6'b111100;
localparam F_SRLV = 6'b000110;

input       [31:0]  i_op1, i_op2;
input       [5:0]   i_control;
output  reg [31:0]  o_result;
output  reg         o_overflow;
output              o_zf;

reg         [32:0]  result;

assign o_zf = (o_result==0);

always @(i_control, i_op1, i_op2) begin
  o_overflow = 0;
  case(i_control)
    F_AND:   o_result = i_op1&i_op2;
     F_OR:   o_result = i_op1|i_op2;
    F_ADD:   
      begin
        result      = i_op1+i_op2;
        o_result    = result[31:0];
        o_overflow  = result[32];
      end
   F_ADDU:   o_result = i_op1+i_op2;
    F_SUB:   o_result = i_op1-i_op2;
    F_SLT:   o_result = $signed(i_op1)<$signed(i_op2) ? 1 : 0;
   F_SLTU:   o_result = i_op1<i_op2 ? 1 : 0;
    F_NOR:   o_result =~(i_op1|i_op2);
    F_LUI:   o_result = {i_op2,16'b0};
    F_XOR:   o_result = i_op1 ^ i_op2;
   F_SLLV:   o_result = i_op2 << i_op1;
   F_SRLV:   o_result = i_op2 >> i_op1;
  default: o_result = 32'b0;
  endcase
end  

endmodule // alu