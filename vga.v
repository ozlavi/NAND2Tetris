module vga(
	input clk,
	input rst_n,
	input [7:0] data_in,
	
	output [31:0] colomn_divided,
	output [31:0] row_divided
);



wire [31:0] column;
wire [31:0] row;

vga_controller u_vga_controller (
	.pixel_clk(clk), // clock
	.reset_n(rst_n), // reset
	.h_sync(h_sync),
	.v_sync(v_sync), 
	.disp_ena(disp_ena),
	.column(column),
	.row(row)
);


assign colomn_divided = column >> 3;
assign row_divided = row >> 3;