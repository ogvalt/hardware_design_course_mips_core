module nextPC(i_pc, i_imm, i_jump, i_beq, i_bne, i_busA, i_busB, o_nextpc, o_pcsrc);
  input   [31:0]  i_pc;
  input   [25:0]  i_imm;
  input           i_jump;
  input           i_beq;
  input			        i_bne;
  input   [31:0]  i_busA;
  input   [31:0]  i_busB;
  output  [31:0]  o_nextpc;
  output          o_pcsrc;

  wire    [31:0]  o_add;
  wire    [31:0]  imm_conc;
  wire    [31:0]  o_ext;
  wire    [31:0]  o_shift;
  wire            i_zerof;
  
  assign imm_conc = {i_pc[31:28],i_imm[25:0],{2{i_zerof}}};
  assign o_pcsrc = i_jump|(i_zerof&i_beq)|(~i_zerof&i_bne);
  assign i_zerof = (i_busA==i_busB);
  
  signExtend EXT ( .i_data(i_imm[15:0]), 
                   .i_control(1'b1), 
                   .o_data(o_ext)
                  );

  adder ADD ( .i_op1(i_pc),
              .i_op2(o_ext),
              .o_result(o_add)
            ); //adder ADD(i_pc,o_shift,o_add);
  
  mux2in1 MUX ( .i_dat0(o_add), 
                .i_dat1(imm_conc), 
                .i_control(i_zerof), 
                .o_dat(o_nextpc)
              );
  
endmodule
