module aluControl(i_aluOp, i_func, i_r_field, o_aluControl, o_ALUSrc_op1, o_jr, o_nop);

localparam OP_RTYPE = 6'h0, OP_ADDI = 6'h8, OP_ADDIU = 6'h9;
localparam OP_LUI = 6'b001111, OP_ORI = 6'b001101, OP_XORI = 6'b001110;
localparam OP_ANDI = 6'b001100;
localparam OP_LW = 6'h23, OP_SW = 6'h2B;
localparam OP_BEQ = 6'h4, OP_J = 6'h2, OP_BNE = 6'h5;  

localparam F_AND = 6'b100100, F_OR = 6'b100101, F_ADD = 6'b100000;
localparam F_SUB = 6'b100010, F_SLT = 6'b101010, F_NOR = 6'b100111;
localparam F_ADDU = 6'b100001, F_SUBU = 6'b100011, F_XOR = 6'b100110;
localparam F_SLTU = 6'b101011, F_SLLV = 6'b000100, F_LUI = 6'b111100;
localparam F_SRLV = 6'b000110, F_SRAV = 6'b000111, F_SLL = 6'b000000;
localparam F_SRL = 6'b000010, F_SRA = 6'b000011, F_JR = 6'b001000;
localparam F_ROTR = 6'b111110, F_ROTRV = 6'b111111, F_NOP = 6'b0;

input       [5:0]   i_aluOp;
input       [5:0]   i_func;
input               i_r_field;
output  reg [5:0]   o_aluControl;
output  reg         o_ALUSrc_op1;
output  reg         o_jr;
output  reg         o_nop;

always @(i_aluOp or i_func) begin
  o_ALUSrc_op1 = 1'b0;
  o_jr         = 1'b0;
  o_nop        = 1'b0;
  case(i_aluOp)
      OP_ADDI,
      OP_ADDIU,
      OP_LW,
      OP_SW:        o_aluControl = F_ADD;
      OP_BEQ,
      OP_BNE :      o_aluControl = F_SUB;
      OP_RTYPE: 
        begin
          case(i_func)
            F_ADD, F_ADDU, F_AND,
            F_OR, F_SUB, F_SLT,
            F_SLTU, F_NOR, F_SUBU, 
            F_XOR, F_SLLV, F_SRAV: 
              begin
                o_aluControl = i_func;
              end
            F_SRLV:
              begin
                if(i_r_field) o_aluControl = F_ROTRV;
                else          o_aluControl = i_func;
              end
            F_SLL, F_SRA:
              begin
                o_aluControl = i_func;
                o_ALUSrc_op1 = 1'b1;
              end 
            F_SRL:
              begin
                if(i_r_field) o_aluControl = F_ROTR;
                else          o_aluControl = i_func;
                o_ALUSrc_op1 = 1'b1;
              end 
            F_JR:
              begin
                o_jr = 1'b1;
                o_aluControl = i_func;
              end
            F_NOP:
              begin
                o_nop = 1'b1;
              end
            // default: // predict unknown function wire
          endcase
          
        end
      OP_LUI:       o_aluControl = F_LUI;
      OP_ORI:       o_aluControl = F_OR;
      OP_XORI:      o_aluControl = F_XOR;
      OP_ANDI:      o_aluControl = F_AND;
      default:      o_aluControl = 0;
  endcase
end
endmodule
