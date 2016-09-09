//`timescale 1ps/1ps;
module alu(i_op1, i_op2, i_control, o_result, o_overflow, o_zf);

localparam ADD = 4'b0000, SUB = 4'b0010, AND = 4'b0100;
localparam OR  = 4'b0101, NOR = 4'b0110, SLT = 4'b1010;
  
input       [31:0]  i_op1, i_op2;
input       [3:0]   i_control;
output  reg [31:0]  o_result;
output  reg         o_overflow;
output              o_zf;

assign o_zf = (o_result==0);

always @(i_control, i_op1, i_op2) begin
  o_overflow = 0;
  case(i_control)
    AND:   o_result = i_op1&i_op2;
     OR:   o_result = i_op1|i_op2;
    ADD:   o_result = i_op1+i_op2;
    SUB:   o_result = i_op1-i_op2;
    SLT:   o_result =(i_op1<i_op2)?(1):(0);
    NOR:   o_result =~(i_op1|i_op2);
  default: o_result = 32'b0;
  endcase
end  

endmodule // alu