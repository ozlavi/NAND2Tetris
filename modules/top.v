module top(
input clk, // 50MHz clk
input rst_n,

output [3:0] VGA_R, // Red 4 bit
output [3:0] VGA_G, // Green 4 bit
output [3:0] VGA_B, // Blue 4 bit to
output VGA_HS, // h_sync
output VGA_VS  // v_sync

);

// CPU
wire [15:0] inst;
wire [15:0] inM;
wire writeM;
wire [14:0] addressM;
wire [14:0] pc;
wire [15:0] outM;

// VGA
wire pixel_clk; // 25MHz clk
wire [31:0] x_pos;
wire [31:0] y_pos;
wire disp_ena;
wire [3:0] curr_pixel;

wire [10:0] pixelmap_addr;
wire [7:0] pixelmap_out;
wire [7:0] ascii;

// Combine every 64 pixels (8x8) to 1 character
wire [6:0] x_char;
wire [6:0] y_char;
assign x_char = x_pos[9:3];
assign y_char = y_pos[9:3];

// Current pixel. Can be only 0000 - Black, 1111 - White
assign curr_pixel[3:0] = {4{pixelmap_out[x_pos_d2[2:0]]}};

// When display enable is 0, all screen shall be black 
assign VGA_R = disp_ena ? curr_pixel : 4'b0;
assign VGA_G = disp_ena ? curr_pixel : 4'b0;
assign VGA_B = disp_ena ? curr_pixel : 4'b0;

// VGA Pixelmap - ROM address input
assign pixelmap_addr = {ascii[7:0],y_pos_d1[2:0]};


// Delaying 1 clk for y_pos (RAM delay)
// Delaying 2 clks for x_pos (RAM+ROM delay)
reg [2:0] x_pos_d1;
reg [2:0] x_pos_d2;
reg [2:0] y_pos_d1;

always@(posedge pixel_clk or negedge rst_n)
begin
	if (~rst_n)
	begin
		x_pos_d1 <= 3'b0;
		x_pos_d2 <= 3'b0;
		y_pos_d1 <= 3'b0;
	end
	else
	begin
		x_pos_d1 <= x_pos[2:0];
		x_pos_d2 <= x_pos_d1[2:0];
		y_pos_d1 <= y_pos[2:0];
	end
end


// Mathematical algoritgm to detect what cube the screen is looking.
// 80 * (y/8) + (x/8)
reg [11:0] cube;

always @(*) 
begin
	cube = (80*y_pos[10:3]) + x_pos[10:3];
end

pll25 u_pll25 (
	.areset(1'b0),
	.inclk0(clk), // 50MHz clk
	.c0(pixel_clk), // 25MHz clk
	.locked()
	
);

 cpu u_cpu (
.clk(clk), // clock
.rst_n(rst_n), // reset
.inst(inst), // instruction from ROM
.inM(inM), // input from RAM
 
 
 .outM(outM), // output for RAM
 .writeM(writeM), // write to meomry (write enable)
 .addressM(addressM), // address to RAM
 .pc(pc)  // Program counter
);

vga_controller u_vga_controller (
	.pixel_clk(pixel_clk), // clock
	.reset_n(rst_n), // reset
	
	.h_sync(VGA_HS),
	.v_sync(VGA_VS), 
	.disp_ena(disp_ena), // display enable
	.column(x_pos[31:0]),
	.row(y_pos[31:0])
);

ROM u_rom (
	.address(pc),
	.clock(clk),
	.q(inst)
);


ROM_Screen u_rom_screen (
	.address(pixelmap_addr[10:0]),
	.clock(pixel_clk),
	.q(pixelmap_out[7:0])
);

RAM u_ram (
	.address(addressM),
	.clock(clk),
	.data(outM),
	.wren(writeM),
	.q(inM)
);

reg [8:0] addr_ptr;

always@(posedge pixel_clk or negedge rst_n)
begin
	if (~rst_n) addr_ptr <= 9'b0;
	else if (addr_ptr == 9'h11) addr_ptr <= 9'h11;
	else addr_ptr <= addr_ptr + 9'b1;
end


RAM_Screen u_ram_screen (
	.clock(pixel_clk),
	.data(8'b0),
	.rdaddress(addr_ptr),
	.wraddress(9'b0),
	.wren(1'b0),
	.q(ascii[7:0])
);


endmodule