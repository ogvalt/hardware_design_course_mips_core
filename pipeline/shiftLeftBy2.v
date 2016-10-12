module shiftLeftBy2(i_data, o_data);
	
	input   [31:0]   i_data;
	output  [31:0]   o_data;

	assign o_data = i_data << 2;
  
endmodule