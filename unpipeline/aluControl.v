module aluControl(i_aluOp, i_func, o_aluControl);

localparam OP_RTYPE = 6'h0, OP_ADDI = 6'h8, OP_ADDIU = 6'h9;
localparam OP_LUI = 6'b001111;
localparam OP_LW = 6'h23, OP_SW = 6'h2B;
localparam OP_BEQ = 6'h4, OP_J = 6'h2, OP_BNE = 6'h5;  

localparam F_AND = 6'b100100, F_OR = 6'b100101,   F_ADD = 6'b100000;
localparam F_SUB = 6'b100010, F_SLT = 6'b101010, F_NOR = 6'b100111;
localparam F_ADDU = 6'b100001, F_SUBU = 6'b100011;

localparam ADD = 4'b0000, ADDU = 4'b0001, SUB = 4'b0010, AND = 4'b0100;
localparam OR  = 4'b0101, NOR = 4'b0110, SLT = 4'b1010, LUI = 4'b1001;
   
input       [5:0]   i_aluOp;
input       [5:0]   i_func;
output  reg [3:0]   o_aluControl;

always @(i_aluOp or i_func) begin
  case(i_aluOp)
      OP_ADDI,
      OP_ADDIU,
      OP_LW,
      OP_SW:        o_aluControl <= ADD;
      OP_BEQ,
      OP_BNE :      o_aluControl <= SUB;
      OP_RTYPE: 
        begin
          case(i_func)
            F_ADD:  o_aluControl <= ADD;
            F_ADDU: o_aluControl <= ADDU;
            F_AND:  o_aluControl <= AND; 
            F_OR:   o_aluControl <= OR;
            F_SUB:  o_aluControl <= SUB;
            F_SLT:  o_aluControl <= SLT;
            F_NOR:  o_aluControl <= NOR;
            F_SUBU: o_aluControl <= SUB;
          endcase
        end
      OP_LUI:       o_aluControl <= LUI;
  endcase
end
endmodule
