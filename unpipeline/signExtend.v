module signExtend(i_data, i_control, o_data);
	
	input   [15:0]  i_data;
	input           i_control;
	output  [31:0]  o_data;

assign o_data = (i_control)?({{16{i_data[15]}},i_data[15:0]}):({16'b0,i_data[15:0]});

endmodule