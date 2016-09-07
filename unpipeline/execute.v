module execute(i_pc, i_imm, i_op1, i_op2,
               i_ALUSrc, i_ALUop, i_jump, i_extOp,
               i_beq, i_bne, o_op2, 
               o_ALUres, o_nextPC, o_pcsrc);
  
  input  [31:0] i_pc; //address from pc
  input  [25:0] i_imm; //immidiate constant input
  input  [31:0] i_op1, i_op2; //operandrs input
  input         i_ALUSrc;
  input  [ 1:0] i_ALUop;
  input         i_jump, i_beq, i_bne; //condition control
  input         i_extOp; // extender control
  
  output [31:0] o_op2;
  output [31:0] o_ALUres;
  output [31:0] o_nextPC;
  output        o_pcsrc;
  
  wire               zerof; // zero flag - alures=0
  wire        [31:0] extended; //value after extender
  wire        [31:0] aluOp2; //second alu operand
  wire        [ 3:0] ALUCtrl; //aclu control code
  
  signExtend EXTENDER( .i_data    (i_imm[15:0]), 
                       .i_control (i_extOp), 
                       .o_data    (extended)
                      );

  mux2in1 ALUSOURCE ( .i_data0    (i_op2), 
                      .i_data0    (extended), 
                      .i_control  (i_ALUSrc), 
                      .o_dat      (aluOp2)
                    );

  alu ALU ( 
            .i_op1  (i_op1), 
            .i_op2  (aluOp2), 
            .i_control(ALUCtrl), 
            .o_result(o_ALUres), 
            .o_zf(zerof)
          );

  aluControl ALUCONTROL(
                        .i_aluOp(i_ALUop), 
                        .i_func(i_imm[5:0]), 
                        .o_aluControl(ALUCtrl)
                        );
  nextPC NEXTPC (
                  .i_pc(i_pc), 
                  .i_imm(i_imm), 
                  .i_jump(i_jump), 
                  .i_beq(i_beq), 
                  .i_bne(i_bne), 
                  .i_zerof(zerof), 
                  .o_nextPC(o_nextPC), 
                  .o_pcsrc(o_pcsrc)
                );
                
  assign o_op2 = i_op2;
  
endmodule
