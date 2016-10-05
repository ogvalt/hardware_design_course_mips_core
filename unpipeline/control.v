module control(i_instrCode, 
               o_regDst,
               o_jump, 
               o_beq,
			         o_bne,
               o_memToReg,
               o_aluOp,
               o_memWrite,
               o_aluSrc_op2,
               o_regWrite,
               o_extOp,
               o_unknown_command
               );

localparam OP_RTYPE = 6'h0, OP_ADDI = 6'h8, OP_ADDIU = 6'h9;
localparam OP_LUI = 6'b001111, OP_ORI = 6'b001101, OP_XORI = 6'b001110;
localparam OP_ANDI = 6'b001100;
localparam OP_LW = 6'h23, OP_SW = 6'h2B;
localparam OP_BEQ = 6'h4, OP_J = 6'h2, OP_BNE = 6'h5;  
localparam OP_COP0 = 6'b010000;
  
input         [5:0]  i_instrCode; // there was[15:0] 
output    reg        o_regDst;
output    reg        o_jump; 
output    reg        o_beq;
output	  reg        o_bne;
output    reg        o_memToReg;
output    reg [5:0]  o_aluOp;
output    reg        o_memWrite;
output    reg        o_aluSrc_op2;
output    reg        o_regWrite;
output    reg        o_extOp;
output    reg        o_unknown_command;

always @(i_instrCode) begin
  o_regDst          = 1'b0;
  o_regWrite        = 1'b0;
  o_aluSrc_op2      = 1'b0;
  o_bne             = 1'b0;
  o_beq             = 1'b0;
  o_jump            = 1'b0;
  o_memWrite        = 1'b0;
  o_memToReg        = 1'b0;
  o_aluOp           = i_instrCode;
  o_extOp           = 1'b0;
  o_unknown_command = 1'b0;

    case(i_instrCode)
      OP_RTYPE: 
        begin
          o_regDst       = 1'b1;
		      o_regWrite     = 1'b1;
      	end
      OP_ADDI:
      	begin
		      o_regWrite    = 1'b1;
      		o_aluSrc_op2  = 1'b1;
      		o_extOp       = 1'b1;
      	end
      OP_ADDIU:
        begin
          o_regWrite    = 1'b1;
          o_aluSrc_op2  = 1'b1;
          o_extOp       = 1'b1;
        end
      OP_LUI:
        begin
          o_regWrite    = 1'b1;
          o_aluSrc_op2  = 1'b1;
        end
      OP_ORI:
        begin
          o_regWrite    = 1'b1;
          o_aluSrc_op2  = 1'b1;
        end
      OP_XORI:
        begin
          o_regWrite    = 1'b1;
          o_aluSrc_op2  = 1'b1;
        end
      OP_ANDI:
        begin
          o_regWrite    = 1'b1;
          o_aluSrc_op2  = 1'b1;
        end
  	  OP_LW:
	      begin
      		o_regWrite    = 1'b1;
      		o_aluSrc_op2  = 1'b1;
      		o_memToReg    = 1'b1;
      		o_extOp       = 1'b1;
      	end
  	  OP_SW:
	      begin
      		o_aluSrc_op2  = 1'b1;
      		o_memWrite    = 1'b1;
      		o_extOp       = 1'b1;
      	end
  	  OP_J:
	     	begin
      		o_jump	      = 1'b1;
      	end
  	  OP_BEQ:
      	begin
      		o_beq         = 1'b1;
      	end
      OP_BNE:
      	begin
			    o_bne	        = 1'b1;
      	end
      OP_COP0:
        begin
        end
      default:
        begin
          o_unknown_command = 1'b1;
        end
  	endcase
  end	
endmodule
        
        