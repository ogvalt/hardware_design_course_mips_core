module mips_tb();

	reg        i_clk, i_rst_n;
  reg        i_external_interrupt;
  integer    i;

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
      $readmemh("test1.dat", MIPS.FETCH.ROM.memory);
      @(posedge MIPS.MEMORY.RAM.mem[0][0]);
      if (MIPS.MEMORY.RAM.mem[4] !== 32'h15) begin
        $display("ERROR");
      end else begin
        $display("SUCCESS");
      end

      reset_memory();
      $readmemh("test2.dat", MIPS.FETCH.ROM.memory);
      @(posedge i_clk);
      reset_core();       
      @(posedge MIPS.MEMORY.RAM.mem[0][0]);
      if (MIPS.MEMORY.RAM.mem[4] !== 32'h7) begin
        $display("ERROR");
      end else begin
        $display("SUCCESS");
      end

      reset_memory();
      $readmemh("test3.dat", MIPS.FETCH.ROM.memory);
      @(posedge i_clk);
      reset_core();       
      @(posedge MIPS.MEMORY.RAM.mem[0][0]);
      if (MIPS.MEMORY.RAM.mem[4] !== 32'h14) begin
        $display("ERROR");
      end else begin
        $display("SUCCESS");
      end

      reset_memory();
      $readmemh("test4.dat", MIPS.FETCH.ROM.memory);
      @(posedge i_clk);
      reset_core();       
      @(posedge MIPS.MEMORY.RAM.mem[0][0]);
      if (MIPS.MEMORY.RAM.mem[4] !== 32'h8f0ff00b) begin
        $display("ERROR");
      end else begin
        $display("SUCCESS");
      end

      reset_memory();
      $readmemh("test5.dat", MIPS.FETCH.ROM.memory);
      @(posedge i_clk);
      reset_core();       
      @(posedge MIPS.MEMORY.RAM.mem[0][0]);
      if (MIPS.MEMORY.RAM.mem[4] !== 32'h0ffffffc) begin
        $display("ERROR");
      end else begin
        $display("SUCCESS");
      end

      reset_memory();
      $readmemh("test6.dat", MIPS.FETCH.ROM.memory);
      @(posedge i_clk);
      reset_core(); 
      MIPS.COPROCESSOR0.handler_address = 32'h24;       
      @(posedge MIPS.MEMORY.RAM.mem[0][0]);
      if (MIPS.MEMORY.RAM.mem[4] !== 32'h01) begin
        $display("ERROR");
      end else begin
        $display("SUCCESS");
      end

      reset_memory();
      $readmemh("test7.dat", MIPS.FETCH.ROM.memory);
      @(posedge i_clk);
      reset_core(); 
      MIPS.COPROCESSOR0.handler_address = 32'h2c; 
      MIPS.COPROCESSOR0.status = 32'b0111_0000_0001;      
      @(posedge MIPS.MEMORY.RAM.mem[0][0]);
      if (MIPS.MEMORY.RAM.mem[4] !== 32'h01) begin
        $display("ERROR");
      end else begin
        $display("SUCCESS");
      end


  $finish;
    end
	

endmodule