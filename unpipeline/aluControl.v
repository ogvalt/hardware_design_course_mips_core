module aluControl(i_aluOp, i_func, o_aluControl);

localparam OP_LS = 2'b00, OP_BQ = 2'b01, OP_RTYPE = 2'b10;
localparam F_AND = 6'b100100, F_OR = 6'b100101,   F_ADD = 6'b100000;
localparam F_SUB = 6'b100010, F_SOLT = 6'b101010, F_NOR = 6'b100111;
localparam F_ADDU = 6'b100001, F_SUBU = 6'b100011;

localparam AND = 4'b0000, OR = 4'b0001, ADD = 4'b0010;
localparam SUB = 4'b0110, SOLT = 4'b0111, NOR = 4'b1100; 
   
input       [1:0]   i_aluOp;
input       [5:0]   i_func;
output  reg [3:0]   o_aluControl;

always @(i_aluOp or i_func) begin
  case(i_aluOp)
       OP_LS: o_aluControl <= ADD;
       OP_BQ: o_aluControl <= SUB;
    OP_RTYPE: 
      begin
        case(i_func)
           F_AND: o_aluControl <= AND; 
            F_OR: o_aluControl <= OR;
           F_ADD: o_aluControl <= ADD;
           F_SUB: o_aluControl <= SUB;
          F_SOLT: o_aluControl <= SOLT;
           F_NOR: o_aluControl <= NOR;
          F_ADDU: o_aluControl <= ADD;
          F_SUBU: o_aluControl <= SUB;
         endcase
       end
  endcase
end
endmodule

module testbench_alucontrol();

localparam F_AND = 6'b100100, F_OR = 6'b100101,   F_ADD = 6'b100000;
localparam F_SUB = 6'b100010, F_SOLT = 6'b101010, F_NOR = 6'b100111;

reg  [1:0]   i_aluOp;
reg  [5:0]   i_func;
wire [3:0]   o_aluControl;



aluControl a(i_aluOp, i_func, o_aluControl);

initial begin
  i_aluOp <= 2'b0;
  i_func  <= 6'b0;
  for (i_aluOp=2'b0; i_aluOp<2'b11; i_aluOp = i_aluOp + 2'b1) begin
    #2;
    i_func <= F_AND;
    #2;
    i_func <= F_OR;
    #2;
    i_func <= F_ADD;
    #2;
    i_func <= F_SUB;
    #2;
    i_func <= F_SOLT;
    #2;
    i_func <= F_NOR;
  end
end
endmodule 