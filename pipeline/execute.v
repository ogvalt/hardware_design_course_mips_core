module execute(i_imm, i_op1, i_op2,
               i_ALUSrc_op2, i_ALUop, i_extOp, 
               o_op2, o_ALUres);
  
  input wire  [25:0] i_imm; //immidiate constant input
  input wire  [31:0] i_op1, i_op2; //operandrs input
  input wire         i_ALUSrc_op2;
  input wire  [ 5:0] i_ALUop;
  input wire         i_extOp; // extender control
  
  output wire [31:0] o_op2;
  output wire [31:0] o_ALUres;
  
  wire               zerof; // zero flag - alures=0
  wire        [31:0] extended; //value after extender
  wire        [31:0] aluOp2, aluOp1; //second alu operand
  wire        [ 5:0] ALUCtrl; //aclu control code
  wire               arithmetic_overflow;
  
  signExtend EXTENDER ( .i_data(i_imm[15:0]), 
                        .i_control(i_extOp), 
                        .o_data(extended)
                      );

  mux2in1 ALUSOURCE_OP2 ( .i_dat0(i_op2), 
                          .i_dat1(extended), 
                          .i_control(i_ALUSrc_op2), 
                          .o_dat(aluOp2)
                        );

  mux2in1 ALUSOURCE_OP1 ( .i_dat0   (i_op1),
                          .i_dat1   ({27'b0,i_imm[10:6]}),
                          .i_control(ALUSrc_op1),
                          .o_dat    (aluOp1)
                        );

  alu ALU ( .i_op1  (aluOp1), 
            .i_op2  (aluOp2), 
            .i_control(ALUCtrl), 
            .o_result(o_ALUres), 
            .o_overflow(arithmetic_overflow),
            .o_zf(zerof)
          );

  aluControl ALUCONTROL(
                        .i_aluOp(i_ALUop), 
                        .i_func(i_imm[5:0]), 
                        .i_r_field(i_imm[10:6]|i_imm[25:21]),
                        .o_aluControl(ALUCtrl),
                        .o_ALUSrc_op1(ALUSrc_op1),
                        .o_jr(),
                        .o_nop(),
                        .o_unknown_func(),
                        .o_eret(),
                        .o_mfc0(), 
                        .o_mtc0()
                        );
                
  assign o_op2 = i_op2;
endmodule
