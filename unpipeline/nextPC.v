module nextPC(  i_pc, i_imm, i_jump, 
                i_beq, i_bne, i_zerof, 
                i_jr, i_Rs, i_eret,
                i_exception,
                o_nextpc, o_pcsrc);

  input   [31:0]  i_pc;
  input   [25:0]  i_imm;
  input           i_jump;
  input           i_beq;
  input			      i_bne;
  input           i_zerof;
  input           i_jr;
  input   [31:0]  i_Rs;
  input           i_eret;
  input           i_exception;

  output      [31:0]  o_nextpc;
  output  reg [ 1:0]  o_pcsrc;

  wire    [31:0]  add_out;
  wire    [31:0]  imm_concat;
  wire    [31:0]  extend;
  
  assign imm_concat = i_jr ? i_Rs : {i_pc[31:28],i_imm[25:0],2'b0};
  // assign o_pcsrc = i_jump | (i_zerof&i_beq) | (~i_zerof&i_bne) | i_jr;

  always @(*) begin 
    case(1'b1)
      i_eret:
        begin
          o_pcsrc = 2'b10;
        end
      i_exception:
        begin
          o_pcsrc = 2'b11;
        end
      i_jump | (i_zerof&i_beq) | (~i_zerof&i_bne) | i_jr:
        begin
          o_pcsrc = 2'b01;
        end
      default: 
        begin
          o_pcsrc = 2'b00;
        end
      endcase 
  end
  
  signExtend EXT( .i_data(i_imm[15:0]), 
                  .i_control(1'b1), 
                  .o_data(extend)
                );

  adder ADD (.i_op1(i_pc), 
             .i_op2(extend), 
             .o_result(add_out)
            );

  mux2in1 MUX ( .i_dat0(add_out), 
                .i_dat1(imm_concat), 
                .i_control(i_jump | i_jr), 
                .o_dat(o_nextpc)
              );
  
endmodule
