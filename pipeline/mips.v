module mips();
  
  reg          i_clk, i_rst_n;
  
  wire  [31:0] nextPC; //from nextPC to PC
  wire         PCsrc;  // PC source
  wire         PCwrite; // eneble PC to inc / insert bubble 
  wire  [31:0] fetch_pc; //PC out
  wire  [31:0] fetch_instr; //Instruction memory out
  wire         IFIDwrite; // IF/ID write enable
  wire  [31:0] instr; // instraction out of IF/ID register
  wire  [31:0] IFID_PC;
  wire         regDst;
  
  wire         IDEXwb;
  wire         EXMEMwb;
  wire         MEMWB;
  wire         regWrite;
  wire  [31:0] dataMemToReg;
  wire  [ 4:0] wrAddr;
  wire  [ 4:0] IDEXrw;
  wire  [ 4:0] EXMEMrw;
  wire  [ 4:0] MEMWBrw;
  wire         jump;  
  wire         bne;
  wire         beq;
  wire  [31:0] ALUres;
  wire  [31:0] MEMres;
  wire  [ 1:0] mux_ctrl1, mux_ctrl2;
  wire  [15:0] imm16;
  wire  [15:0] imm;
  wire  [31:0] decode_op1, decode_op2;
  wire  [ 1:0] ALUop;
  wire         ALUsrc;
  wire  [ 3:0] EX_i;
  wire  [ 3:0] EX;
  wire  [ 2:0] M1;
  wire         memToReg, memWrite, memRead;
  wire  [ 2:0] M2;
  wire  [ 1:0] M3;
  wire  [31:0] busA;
  wire  [31:0] busB;
  wire         extOp;
  wire  [31:0] op2;
  wire  [31:0] dataAddr;
  wire  [31:0] dataToMem;
  wire         bubble;
  
  assign EX_i = {extOp,ALUop,ALUsrc};
  assign M1   = {memToReg, memWrite, memRead};
  
  fetch FETCH(  .i_clk  (i_clk), 
                .i_rst_n(i_rst_n), 
                .i_execute(nextPC), 
                .i_pcsrc(PCsrc), 
                .i_pcWrite(PCwrite), 
                .o_fetch_pc(fetch_pc), 
                .o_fetch_instr(fetch_instr)
                ); //fetch block
              
  fetch_decode IF_ID( .i_clk  (i_clk), 
                      .i_rst_n(i_rst_n), 
                      .i_rst_nextPC(PCsrc),
                      .i_we(IFIDwrite), 
                      .i_instr(fetch_instr), 
                      .i_pc(fetch_pc), 
                      .o_instr(instr), 
                      .o_pc(IFID_PC)
                    );   //fetch_decoce register
              
  decode DECODE(  .i_clk(i_clk), 
                  .i_rst_n(i_rst_n), 
                  .i_c_regDst(regDst), 
                  .i_c_regWrite(regWrite), 
                  .i_Rs(instr[25:21]), 
                  .i_Rt(instr[20:16]), 
                  .i_Rd(instr[15:11]), 
                  .i_wrDataToReg(dataMemToReg), 
                  .i_wrAddr(wrAddr),
                  .i_pc(IFID_PC), 
                  .i_imm(instr[25:0]), 
                  .i_jump(jump), 
                  .i_bne(bne), 
                  .i_beq(beq),
                  .i_ALUres(ALUres), 
                  .i_mem(MEMres), 
                  .i_mux_ctrl1(mux_ctrl1), 
                  .i_mux_ctrl2(mux_ctrl2),
                  .o_nextPC(nextPC), 
                  .o_pcsrc(PCsrc), 
                  .o_decode_op1(decode_op1), 
                  .o_decode_op2(decode_op2), 
                  .o_wrAddr(IDEXrw)
                ); // decode block
               
  decode_execute ID_EX( .i_clk(i_clk), 
                        .i_rst_n(i_rst_n),
                        .i_imm(instr[25:0]), 
                        .i_busA(decode_op1), 
                        .i_busB(decode_op2), 
                        .i_Rw(IDEXrw), 
                        .i_EX(EX_i), 
                        .i_M(M1), 
                        .i_WB(IDEXwb), 
                        .o_imm(imm), 
                        .o_busA(busA), 
                        .o_busB(busB), 
                        .o_Rw(EXMEMrw),
                        .o_EX(EX), 
                        .o_M(M2), 
                        .o_WB(EXMEMwb)
                      );
              
  execute EXECUTE(  .i_imm(imm), 
                    .i_op1(busA), 
                    .i_op2(busB),
                    .i_ALUSrc(EX[0]), 
                    .i_ALUop(EX[2:1]), 
                    .i_extOp(EX[3]), 
                    .o_op2(op2), 
                    .o_ALUres(ALUres)
                  );
               
  execute_memory EX_MEM(  .i_clk(i_clk), 
                          .i_rst_n(i_rst_n), 
                          .i_alures(ALUres), 
                          .i_busB(op2),
                          .i_Rw(EXMEMrw), 
                          .i_M(M2[2:1]), 
                          .i_WB(EXMEMwb),
                          .o_alures(dataAddr), 
                          .o_busB(dataToMem), 
                          .o_Rw(MEMWBrw),
                          .o_M(M3), 
                          .o_WB(MEMWB)
                        );
               
  memory MEMORY(  .i_clk(i_clk), 
                  .i_rst_n(i_rst_n), 
                  .i_alu(dataAddr), 
                  .i_data(dataToMem), 
                  .i_memWrite(M3[0]), 
                  .i_memToReg(M3[1]), 
                  .o_data(MEMres)
                );
                
  memory_writeback MEM_WB(  .i_clk(i_clk), 
                            .i_rst_n(i_rst_n), 
                            .i_WB(MEMWB), 
                            .i_data(MEMres), 
                            .i_Rw(MEMWBrw), 
                            .o_data(dataMemToReg), 
                            .o_Rw(wrAddr), 
                            .o_WB(regWrite)
                          );
                
  control CONTROL(  .i_instrCode(instr[31:26]), 
                    .i_bubble(bubble), 
                    .o_regDst(regDst),
                    .o_jump(jump), 
                    .o_beq(beq), 
                    .o_bne(bne), 
                    .o_memToReg(memToReg),
                    .o_aluOp(ALUop), 
                    .o_memWrite(memWrite), 
                    .o_memRead(memRead),
                    .o_aluSrc(ALUsrc), 
                    .o_regWrite(IDEXwb), 
                    .o_extOp(extOp)
                  );
              
  hazard HAZARD(  .i_idEx(EXMEMrw), 
                  .i_exMem(MEMWBrw), 
                  .i_memWb(wrAddr), 
                  .i_memRead(M2[0]), 
                  .i_idExregWrite(EXMEMwb), 
                  .i_exMemregWrite(MEMWB), 
                  .i_memWbregWrite(regWrite), 
                  .i_Rs(instr[25:21]), 
                  .i_Rt(instr[20:16]), 
                  .o_forwardA(mux_ctrl1), 
                  .o_forwardB(mux_ctrl2),
                  .o_bubble(bubble), 
                  .o_pcwrite(PCwrite), 
                  .o_idIfwrite(IFIDwrite)
                ); // Forwarding, hazard detection, Stall Unit
  
  initial begin //clock set up
    i_clk <= 1'b0;
    forever #1 i_clk <= ~i_clk;
  end
  initial begin //initial reset
    i_rst_n <= 1'b0;
    #3;
    i_rst_n <= 1'b1;
  end 
  initial $readmemh("rom_init.dat", FETCH.ROM.memory);
  
endmodule 
