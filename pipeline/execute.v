module execute(i_imm, i_op1, i_op2, i_ALUSrc_op1,
               i_ALUSrc_op2, i_ALUCtrl, i_extOp, 
               o_op2, o_ALUres,
               o_arithmetic_overflow
               );
  
  input  [25:0] i_imm; //immidiate constant input
  input  [31:0] i_op1, i_op2; //operandrs input
  input         i_ALUSrc_op1, i_ALUSrc_op2;
  input  [ 5:0] i_ALUCtrl;
  input         i_extOp; // extender control
  
  output [31:0] o_op2;
  output [31:0] o_ALUres;
  output        o_arithmetic_overflow;
  
  wire               zerof; // zero flag - alures=0
  wire        [31:0] extended; //value after extender
  wire        [31:0] aluOp2, aluOp1; //second alu operand
  wire        [ 5:0] ALUCtrl; //aclu control code
  
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
                          .i_control(i_ALUSrc_op1),
                          .o_dat    (aluOp1)
                        );

  alu ALU ( .i_op1  (aluOp1), 
            .i_op2  (aluOp2), 
            .i_control(i_ALUCtrl), 
            .o_result(o_ALUres), 
            .o_overflow(o_arithmetic_overflow),
            .o_zf(zerof)
          );
                
  assign o_op2 = i_op2;
endmodule
