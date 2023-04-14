module cpu(
input clk, // clock
input rst_n, // reset
input [15:0] inst, // instruction from ROM
input [15:0] inM, // input from RAM
 
 
 output [15:0] outM, // output for RAM
 output writeM, // write to meomry (write enable)
 output [14:0] addressM, // address to RAM
 output reg [14:0] pc  // Program counter
);

reg pc_w;

always@(posedge clk or negedge rst_n)
begin
	if (~rst_n)
		pc_w <= 1'b0;
	else pc_w <= ~pc_w;
end

wire zr; // zero flag from ALU
wire ng; // negative flag from ALU
wire [15:0] alu_out; // output of ALU
wire [15:0] am_reg; // A or M register input for ALU (y)
wire jump; // indicates when to jump
reg [15:0] d_reg; // D register input for ALU (x)
reg [15:0] a_reg; // A register 
wire load_a;

assign load_a = ~inst[15] | (inst[15] & inst[5]);
assign load_d = inst[15] & inst[4];
assign jump = inst[15] & ((~ng & inst[0]) | (ng & inst[2]) | (zr & inst[1]));
assign am_reg = inst[12] ? inM : a_reg;
assign writeM = inst[15] & inst [3] & pc_w;
assign outM = alu_out;
assign addressM = a_reg[14:0];

// D register
// D register is loaded only when inst[15] is 1 and inst[4] (dest2) is 1
always@(posedge clk)
begin
	if (load_d) d_reg <= pc_w ? alu_out : d_reg;
end

// A register
// A register is loaded only when inst[15] is 1 and inst[5] (dest1) is 1
always@(posedge clk)
begin
	if (load_a) a_reg <= pc_w ? (inst[15] ? alu_out : inst) : a_reg;
end

always@(posedge clk or negedge rst_n)
begin
	if (~rst_n) pc <= 15'd0;
	else if (jump & pc_w) pc <= a_reg[14:0];
	else if (pc_w) pc <= pc + 15'd1;
end

// ALU
alu u_alu(
.x (d_reg),
.y (am_reg),
.zx (inst[11]),
.nx (inst[10]),
.zy (inst[9]),
.ny (inst[8]),
.f  (inst[7]),
.no (inst[6]),
.zr (zr),
.ng (ng),
.out (alu_out)
);

endmodule