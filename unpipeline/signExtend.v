module signExtend(i_data, i_control, o_data);
input   [15:0]  i_data;
input           i_control;
output  [31:0]  o_data;

//reg [31:0] o_data;

/*casex (i_control)
  1'b0: o_data <= {{16{i_control}},i_data[15:0]}; 
  1'b1: o_data <= {{16{i_data[15]}},i_data[15:0]};
  default: o_data <= {32{1'bx}};
endcase*/

assign o_data = (i_control)?({{16{i_data[15]}},i_data[15:0]}):({{16{i_control}},i_data[15:0]});

endmodule