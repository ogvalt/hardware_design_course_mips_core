module adder(i_op1, i_op2, o_result);

	input  [31:0] i_op1, i_op2;
	output [31:0] o_result;

	assign o_result = i_op1 + i_op2;
  
endmodule

//`timescale 1ps/1ps;

module testbench_adder();
  integer i,j;
  reg [31:0] i_op1 = 32'b0;
  reg [31:0] i_op2 = 32'b0;
  
  wire  [31:0] o_result;
  
  adder a1(i_op1,i_op2,o_result);
  
  initial begin
    for (i=0; i<33; i=i+1) begin
      for (j=0; j<33; j=j+1) begin
        #1;
        i_op2 = i_op2 + 32'hffff000;
        $display("%d", o_result);
    end
    i_op1 = i_op1 + 32'hffecfd0;
    end
  end
endmodule
  