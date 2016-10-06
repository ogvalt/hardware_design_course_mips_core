module mux4in1 (i_op1, i_op2, i_op3, i_op4, i_ctrl, o_res);

  input wire [31:0] i_op1, i_op2, i_op3, i_op4;
  input wire [ 1:0] i_ctrl;
  
  output reg [31:0] o_res;
  
  
  always @*
    begin
      case (i_ctrl)
        2'b00: o_res <= i_op1;
        2'b01: o_res <= i_op2;
        2'b10: o_res <= i_op3;
        2'b11: o_res <= i_op4;
    endcase
  end
  
endmodule

