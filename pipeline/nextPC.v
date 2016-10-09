module nextPC ( i_pc, 
                i_imm, 
                i_jump, 
                i_beq, 
                i_bne, 
                i_jr,
                i_busA, 
                i_busB, 
                o_nextpc, 
                o_pcsrc
              );
  
  input   [31:0]  i_pc;
  input   [25:0]  i_imm;
  input           i_jump;
  input           i_beq;
  input			      i_bne;
  input           i_jr;
  input   [31:0]  i_busA;
  input   [31:0]  i_busB;
  output  [31:0]  o_nextpc;
  output          o_pcsrc;

  wire    [31:0]  add_o;
  wire    [31:0]  nextAddr;
  wire    [31:0]  ext_o;
  wire            zerof;
  
  assign nextAddr = i_jr ? i_busA : {i_pc[31:28], i_imm[25:0], 2'b0};
  assign zerof = (i_busA == i_busB);
  assign o_pcsrc = i_jump | ( zerof & i_beq ) | ( ~zerof & i_bne ) | i_jr;

  
  signExtend EXT ( .i_data(i_imm[15:0]), 
                   .i_control(1'b1), 
                   .o_data(ext_o)
                  );

  adder ADD ( .i_op1(i_pc),
              .i_op2(ext_o),
              .o_result(add_o)
            ); 
  
  mux2in1 MUX ( .i_dat0(add_o), 
                .i_dat1(nextAddr), 
                .i_control(i_jump | i_jr), 
                .o_dat(o_nextpc)
              );
  
endmodule
