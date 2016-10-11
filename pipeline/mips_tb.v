module mips_tb();

	reg        i_clk, i_rst_n;
  	reg        i_external_interrupt;

  	integer    i, error;

	mips MIPS( .i_clk(i_clk), 
			   .i_rst_n(i_rst_n), 
			   .i_external_interrupt(i_external_interrupt)
			 );

	task reset_core();
		begin
			i_rst_n = 1'b0;
    		#3;
    		i_rst_n = 1'b1;
    	end
	endtask
	task reset_memory();
		begin
			for (i=0; i<129; i=i+1) begin
				MIPS.FETCH.ROM.memory[i] = 32'bx;	
				MIPS.MEMORY.RAM.mem[i]   = 32'bx;
			end
			for (i=0; i<32; i=i+1) begin
				MIPS.DECODE.REGISTERS.memory[i] = 32'bx; 
			end
		end
	endtask

	initial begin //clock set up
    	i_external_interrupt = 0;
    	i_clk = 1'b0;
    	forever #1 i_clk = ~i_clk;
  	end
  	initial begin //initial reset
    	reset_core();
  	end 
  	initial begin
  		error = 0;
  		$display("-------------TEST #1-------------");
  		$display("Start time: \t %t", $time);
  		$readmemh("test1.dat", MIPS.FETCH.ROM.memory);
  		@(posedge MIPS.MEMORY.RAM.mem[0][0]);
  		$display("End time: \t %t", $time);
  		if (MIPS.MEMORY.RAM.mem[4] !== 32'h15) begin
  			$display("ERROR");
  			error = error + 1;
  		end else begin
  			$display("SUCCESS");
  		end
  		$display("-----------END TEST #1-----------\n");

  		$display("-------------TEST #2-------------");
  		$display("Start time: \t %t", $time);
  		reset_memory();
  		$readmemh("test2.dat", MIPS.FETCH.ROM.memory);
  		@(posedge i_clk);
  		reset_core();      	
	    @(posedge MIPS.MEMORY.RAM.mem[0][0]);
	    $display("End time: \t %t", $time);
	    if (MIPS.MEMORY.RAM.mem[4] !== 32'h7) begin
	      $display("ERROR");
	      error = error + 1;
	    end else begin
	      $display("SUCCESS");
	    end
	    $display("-----------END TEST #2-----------\n");

	    $display("-------------TEST #3-------------");
  		$display("Start time: \t %t", $time);
	    reset_memory();
	    $readmemh("test3.dat", MIPS.FETCH.ROM.memory);
	    @(posedge i_clk);
  		reset_core();      	
	    @(posedge MIPS.MEMORY.RAM.mem[0][0]);
	    $display("End time: \t %t", $time);
	    if (MIPS.MEMORY.RAM.mem[4] !== 32'h14) begin
	      $display("ERROR");
	      error = error + 1;
	    end else begin
	      $display("SUCCESS");
	    end
		$display("-----------END TEST #3-----------\n");

	    $display("-------------TEST #4-------------");
  		$display("Start time: \t %t", $time);
	    reset_memory();
	    $readmemh("test4.dat", MIPS.FETCH.ROM.memory);
	    @(posedge i_clk);
  		reset_core();      	
	    @(posedge MIPS.MEMORY.RAM.mem[0][0]);
	    $display("End time: \t %t", $time);
	    if (MIPS.MEMORY.RAM.mem[4] !== 32'h8f0ff00b) begin
	      $display("ERROR");
	      error = error + 1;
	    end else begin
	      $display("SUCCESS");
	    end
	    $display("-----------END TEST #4-----------\n");

	    $display("-------------TEST #5-------------");
  		$display("Start time: \t %t", $time);
	    reset_memory();
	    $readmemh("test5.dat", MIPS.FETCH.ROM.memory);
	    @(posedge i_clk);
  		reset_core();      	
	    @(posedge MIPS.MEMORY.RAM.mem[0][0]);
	    $display("End time: \t %t", $time);
	    if (MIPS.MEMORY.RAM.mem[4] !== 32'h0ffffffc) begin
	      $display("ERROR");
	      error = error + 1;
	    end else begin
	      $display("SUCCESS");
	    end
	    $display("-----------END TEST #5-----------\n");

	    $display("-------------TEST #6-------------");
  		$display("Start time: \t %t", $time);
	    reset_memory();
	    $readmemh("test6.dat", MIPS.FETCH.ROM.memory);
	    @(posedge i_clk);
  		reset_core(); 
  		MIPS.COPROCESSOR0.handler_address = 32'h24;     	
	    @(posedge MIPS.MEMORY.RAM.mem[0][0]);
	    $display("End time: \t %t", $time);
	    if (MIPS.MEMORY.RAM.mem[4] !== 32'h01) begin
	      $display("ERROR");
	      error = error + 1;
	    end else begin
	      $display("SUCCESS");
	    end
	    $display("-----------END TEST #6-----------\n");

	    $display("-------------TEST #7-------------");
  		$display("Start time: \t %t", $time);
	    reset_memory();
	    $readmemh("test7.dat", MIPS.FETCH.ROM.memory);
	    @(posedge i_clk);
  		reset_core(); 
  		MIPS.COPROCESSOR0.handler_address = 32'h2c; 
  		MIPS.COPROCESSOR0.status = 32'b0111_0000_0001;    	
	    @(posedge MIPS.MEMORY.RAM.mem[0][0]);
	    $display("End time: \t %t", $time);
	    if (MIPS.MEMORY.RAM.mem[4] !== 32'h01) begin
	      $display("ERROR");
	      error = error + 1;
	    end else begin
	      $display("SUCCESS");
	    end
	    MIPS.COPROCESSOR0.status = 32'b0001_0000_0001; 
	    $display("-----------END TEST #7-----------\n");

	    $display("-------------TEST #8-------------");
  		$display("Start time: \t %t", $time);
	    reset_memory();
	    $readmemh("test8.dat", MIPS.FETCH.ROM.memory);
	    @(posedge i_clk);
  		reset_core(); 
  		repeat(5) @(posedge i_clk);
  		i_external_interrupt = 1'b1;
  		MIPS.COPROCESSOR0.handler_address = 32'h48; 
  		MIPS.COPROCESSOR0.status = 32'b0111_0000_0001;  
  		@(posedge i_clk);  
  		i_external_interrupt = 1'b0;	
	    @(posedge MIPS.MEMORY.RAM.mem[0][0]);
	    $display("End time: \t %t", $time);
	    if (MIPS.MEMORY.RAM.mem[4] !== 32'h01) begin
	      $display("ERROR");
	      error = error + 1;
	    end else begin
	      $display("SUCCESS");
	    end
	    MIPS.COPROCESSOR0.status = 32'b0001_0000_0001;
	    $display("-----------END TEST #8-----------\n");

	    $display("-------------TEST #9-------------");
  		$display("Start time: \t %t", $time);
	    reset_memory();
	    $readmemh("test9.dat", MIPS.FETCH.ROM.memory);
	    @(posedge i_clk);
  		reset_core(); 
  		MIPS.COPROCESSOR0.handler_address = 32'h64;   
	    @(posedge MIPS.MEMORY.RAM.mem[0][0]);
	    $display("End time: \t %t", $time);
	    if (MIPS.MEMORY.RAM.mem[4] !== 32'h06) begin
	      $display("ERROR");
	      error = error + 1;
	    end else begin
	      $display("SUCCESS");
	    end
	    $display("-----------END TEST #9-----------\n");

	    $display("-------------TEST #10------------");
  		$display("Start time: \t %t", $time);
	    reset_memory();
	    $readmemh("test10.dat", MIPS.FETCH.ROM.memory);
	    @(posedge i_clk);
  		reset_core();  
	    @(posedge MIPS.MEMORY.RAM.mem[0][0]);
	    $display("End time: \t %t", $time);
	    if (MIPS.MEMORY.RAM.mem[4] !== 32'h06) begin
	      $display("ERROR");
	      error = error + 1;
	    end else begin
	      $display("SUCCESS");
	    end
	    $display("-----------END TEST #10----------\n");

	    if (error == 0) begin
	    	$display("All tests complete successful!!!!!!");
	    end else begin
	    	$display("There are some errors in design.\n # of errors: %d",error);
	    end

	$finish;
  	end
	

endmodule