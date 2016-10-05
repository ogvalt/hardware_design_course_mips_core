module fetch( i_clk, i_rst_n, 
              i_execute, i_pcsrc, 
              i_epc_to_pc, i_error_handler,
              o_fetch_pc, o_fetch_instr);
  
  input       i_clk;
  input       i_rst_n; //active zero level
  input [1:0] i_pcsrc; //mux control
  
  input  [31:0] i_execute; // out of nextPC
  input  [31:0] i_epc_to_pc, // address from epc to pc
                i_error_handler; // address of error handler
  
  output [31:0] o_fetch_pc; //input for nextPC and PC
  output [31:0] o_fetch_instr; //instraction fetch
  
  reg [31:0] i_pc; //input previously addr
  
  pc PC  ( .i_clk   (i_clk), 
           .i_rst_n (i_rst_n), 
           .i_pc    (i_pc), 
           .o_pc    (o_fetch_pc)
          );

  // mux2in1 PCSOURCE ( .i_dat0    (o_fetch_pc), 
  //                    .i_dat1    (i_execute), 
  //                    .i_control (i_pcsrc), 
  //                    .o_dat     (i_pc)
  //                   );// mux source of addr of pc

  rom ROM   ( .i_addr(o_fetch_pc), 
              .o_data(o_fetch_instr)
            );

  always @(*) begin : mux4in1_block
    case(i_pcsrc)
        2'b01:  i_pc = i_execute;
        2'b10:  i_pc = i_epc_to_pc; 
        2'b11:  i_pc = i_error_handler;
      default:  i_pc = o_fetch_pc;
    endcase // i_pcsrc
  end
  

endmodule
