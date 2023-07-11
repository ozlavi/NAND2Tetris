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

wire ram_wr_en;
wire ram_screen_wr_en;
wire [15:0] inst;
wire [15:0] inM;
wire writeM;
wire [15:0] addressM;
wire [14:0] pc;
wire [15:0] outM;

// VGA
wire pixel_clk; // 25MHz clk
wire [10:0] pixelmap_addr;
wire [7:0] pixelmap_out;
wire [7:0] ascii;
wire [11:0] rd_addr;

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
	.rd_addr(rd_addr[11:0]),
	
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
 
 .ram_wr_en(ram_wr_en),
 .ram_screen_wr_en(ram_screen_wr_en),
 
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
	.clock(clk),
	.q(pixelmap_out[7:0])
);


// address 15 bit, data 16 bit
RAM u_ram (
	.address(addressM[14:0]),
	.clock(clk),
	.data(outM),
	.wren(ram_wr_en),
	.q(inM)
);

// address 9 bit, data 8 bit
RAM_Screen u_ram_screen (
	.clock(clk),
	.data(outM[7:0]),
	.rdaddress(rd_addr),
	.wraddress(addressM[11:0]),
	.wren(ram_screen_wr_en),
	.q(ascii[7:0])
);


endmodule