module execute(i_imm, i_op1, i_op2,
               i_ALUSrc, i_ALUop, i_extOp, 
               o_op2, o_ALUres);
  
  input wire  [25:0] i_imm; //immidiate constant input
  input wire  [31:0] i_op1, i_op2; //operandrs input
  input wire         i_ALUSrc;
  input wire  [ 1:0] i_ALUop;
  input wire         i_extOp; // extender control
  
  output wire [31:0] o_op2;
  output wire [31:0] o_ALUres;
  
  wire               zerof; // zero flag - alures=0
  wire        [31:0] extended; //value after extender
  wire        [31:0] aluOp2; //second alu operand
  wire        [ 3:0] ALUCtrl; //aclu control code
  
  signExtend EXTENDER(i_imm[15:0], i_extOp, extended);
  mux2in1 ALUSOURCE(i_op2, extended, i_ALUSrc, aluOp2);
  alu ALU(i_op1, aluOp2, ALUCtrl, o_ALUres, zerof);
  aluControl ALUCONTROL(i_ALUop, i_imm[5:0], ALUCtrl);
                
  assign o_op2 = i_op2;
endmodule
