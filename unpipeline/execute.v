module execute(i_pc, i_imm, i_op1, i_op2,
               i_ALUSrc, i_ALUop, i_jump, i_extOp,
               i_beq, i_bne, o_op2, 
               o_ALUres, o_nextPC, o_pcsrc);
  
  input wire  [31:0] i_pc; //address from pc
  input wire  [25:0] i_imm; //immidiate constant input
  input wire  [31:0] i_op1, i_op2; //operandrs input
  input wire         i_ALUSrc;
  input wire  [ 1:0] i_ALUop;
  input wire         i_jump, i_beq, i_bne; //condition control
  input wire         i_extOp; // extender control
  
  output wire [31:0] o_op2;
  output wire [31:0] o_ALUres;
  output wire [31:0] o_nextPC;
  output wire        o_pcsrc;
  
  wire               zerof; // zero flag - alures=0
  wire        [31:0] extended; //value after extender
  wire        [31:0] aluOp2; //second alu operand
  wire        [ 3:0] ALUCtrl; //aclu control code
  
  signExtend EXTENDER(i_imm[15:0], i_extOp, extended);
  mux2in1 ALUSOURCE(i_op2, extended, i_ALUSrc, aluOp2);
  alu ALU(i_op1, aluOp2, ALUCtrl, o_ALUres, zerof);
  aluControl ALUCONTROL(i_ALUop, i_imm[5:0], ALUCtrl);
  nextPC NEXTPC(i_pc, i_imm, i_jump, i_beq, i_bne, 
                zerof, o_nextPC, o_pcsrc);
                
  assign o_op2 = i_op2;
endmodule
