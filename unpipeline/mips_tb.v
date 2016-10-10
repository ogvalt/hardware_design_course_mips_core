module mips_tb();

	reg        i_clk, i_rst_n;
  	reg        i_external_interrupt;

	mips MIPS( .i_clk(i_clk), 
			   .i_rst_n(i_rst_n), 
			   .i_external_interrupt(i_external_interrupt)
			 );

	initial begin //clock set up
    	i_external_interrupt = 0;
    	i_clk = 1'b0;
    	forever #1 i_clk = ~i_clk;
  	end
  	initial begin //initial reset
    	i_rst_n = 1'b0;
    	#3;
    	i_rst_n = 1'b1;
  	end 
  	initial begin
  		$readmemh("test1.dat", MIPS.FETCH.ROM.memory);
  		@(posedge MIPS.MEMORY.RAM.mem[0][0]);
  		if (MIPS.MEMORY.RAM.mem[4] !== 32'h15) begin
  			$display("ERROR");
  		end else begin
  			$display("SUCCESS");
  		end
  	$finish;
  	end
	

endmodule