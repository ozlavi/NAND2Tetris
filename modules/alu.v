module alu(
input [15:0] x,
input [15:0] y,
input zx, // 1 means (x=0)
input nx, // 1 means (x=~x)
input zy, // 1 means (xy=0)
input ny, // 1 means (y=~y)
input f, // 1 means (f=x+y), 0 means (f=x&y)
input no, // 1 means bitwise not to output

output zr, // zero flag
output ng, // negative flag
output [15:0] out
);

wire [15:0] x0; // x after zx
wire [15:0] x1; // x after nx
wire [15:0] y0; // y after zy
wire [15:0] y1; // y after ny

wire [15:0] f0; // out after f

assign x0 = zx ? 16'b0 : x  ;
assign x1 = nx ? ~x0   : x0 ;
assign y0 = zy ? 16'b0 : y  ;
assign y1 = ny ? ~y0   : y0 ;

assign f0 = f ? (x1 + y1) : (x1 & y1);
assign out = no ? ~f0 : f0; 

assign zr = (~|out); // NOR to output to raise zero flag
assign ng = out[15]; // negative flag on MSB


endmodule  