module memory (i_clk, i_alu, i_data, i_memWrite, i_memToReg, o_data);
  
  input         i_clk;
  
  input  [31:0] i_alu;
  input  [31:0] i_data;
  
  input         i_memWrite, i_memToReg;
  
  output [31:0] o_data;
  
  wire        [31:0] data;
  
  ram RAM (.i_clk(i_clk), 
  		   .i_addr(i_alu[5:0]), 
  		   .i_data(i_data), 
  		   .i_we(i_memWrite), 
  		   .o_data(data)
  		   );

  mux2in1 MEMTOREG( .i_dat0(i_alu), 
  					.i_dat1(data), 
  					.i_control(i_memToReg), 
  					.o_dat(o_data)
  				 	);
  
endmodule
