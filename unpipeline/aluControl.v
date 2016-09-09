module aluControl(i_aluOp, i_func, o_aluControl);

localparam OP_LS = 2'b00, OP_BQ = 2'b01, OP_RTYPE = 2'b10;
localparam F_AND = 6'b100100, F_OR = 6'b100101,   F_ADD = 6'b100000;
localparam F_SUB = 6'b100010, F_SLT = 6'b101010, F_NOR = 6'b100111;
localparam F_ADDU = 6'b100001, F_SUBU = 6'b100011;

localparam ADD = 4'b0000, SUB = 4'b0010, AND = 4'b0100;
localparam OR  = 4'b0101, NOR = 4'b0110, SLT = 4'b1010;
   
input       [1:0]   i_aluOp;
input       [5:0]   i_func;
output  reg [3:0]   o_aluControl;

always @(i_aluOp or i_func) begin
  case(i_aluOp)
       OP_LS: o_aluControl <= ADD;
       OP_BQ: o_aluControl <= SUB;
    OP_RTYPE: 
      begin
        case(i_func)
           F_AND: o_aluControl <= AND; 
            F_OR: o_aluControl <= OR;
           F_ADD: o_aluControl <= ADD;
           F_SUB: o_aluControl <= SUB;
          F_SLT: o_aluControl <= SLT;
           F_NOR: o_aluControl <= NOR;
          F_ADDU: o_aluControl <= ADD;
          F_SUBU: o_aluControl <= SUB;
         endcase
       end
  endcase
end
endmodule
