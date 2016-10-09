module fetch(i_clk, i_rst_n, i_execute, i_pcsrc, 
             i_pcWrite, o_fetch_pc, o_fetch_instr);
  
  input i_clk;
  input i_rst_n; //active zero level
  input i_pcsrc; //mux control
  input i_pcWrite;
  
  input  [31:0] i_execute; // out of nextPC
  
  output [31:0] o_fetch_pc; //input for nextPC and PC
  output [31:0] o_fetch_instr; //instraction fetch
  
  reg  [31:0] i_pc; //input previously addr
  wire [31:0] fetch_pc;
  wire [31:0] fetch_instr;
  
  pc PC ( .i_clk(i_clk), 
          .i_rst_n(i_rst_n), 
          .i_pc(i_pc),  
          .o_pc(o_fetch_pc)
        );

  rom ROM ( .i_addr(o_fetch_pc), 
            .o_data(o_fetch_instr)
          );

  always @(*) begin 
    case(i_pcsrc)
      2'b01:  i_pc = i_execute;
      2'b10:  begin end
      2'b11:  begin end
    default: 
      begin
        if(i_pcWrite)
          i_pc = o_fetch_pc + 1'b1;
        else 
          i_pc = o_fetch_pc;
      end
    endcase // i_pcsrc
  end

endmodule
