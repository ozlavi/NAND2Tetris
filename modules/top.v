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
wire [10:0] pixelmap_addr;
wire [7:0] pixelmap_out;
wire [7:0] ascii;

pll25 u_pll25 (
	.areset(1'b0),
	.inclk0(clk), // 50MHz clk
	.c0(pixel_clk), // 25MHz clk
	.locked()
	
);

vga u_vga (
	.pixel_clk(pixel_clk), // 25MHz clk
	.rst_n(rst_n),
	
	.pixelmap_out(pixelmap_out[7:0]),
	.ascii(ascii[7:0]),
	.pixelmap_addr(pixelmap_addr[10:0]),
	
	.VGA_R(VGA_R[3:0]), // Red 4 bit
	.VGA_G(VGA_G[3:0]), // Green 4 bit
	.VGA_B(VGA_B[3:0]), // Blue 4 bit to
	.VGA_HS(VGA_HS), // h_sync
	.VGA_VS(VGA_VS)  // v_sync


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

//reg [8:0] addr_ptr;

//always@(posedge pixel_clk or negedge rst_n)
//begin
//	if (~rst_n) addr_ptr <= 9'b0;
//	else if (addr_ptr == 9'h11) addr_ptr <= 9'h11;
//	else addr_ptr <= addr_ptr + 9'b1;
//end


RAM_Screen u_ram_screen (
	.clock(pixel_clk),
	.data(8'b0),
	.rdaddress(9'd4),
	.wraddress(9'b0),
	.wren(1'b0),
	.q(ascii[7:0])
);


endmodule