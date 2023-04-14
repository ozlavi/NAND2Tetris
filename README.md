# NAND2Tetris
NAND2Tetris project - Created by Oz Lavi and Aviad Akiva

Final Project: Building a Modern Computer System from the Ground Up with NAND2Tetris

In this project, we implemented the NAND2Tetris program, a self-contained educational program aimed at teaching students how to build a modern computer system from the ground up. The program provides a hands-on, project-based approach to learning computer science and electronics engineering, starting with basic logic gates and building up to a complete computer system that can run software programs.

Throughout the project, we designed and implemented various components such as logic gates, arithmetic and logic units (ALUs), memory modules, and a CPU. We also created a low-level programming language and a compiler to translate higher-level code into machine language that can be executed on my custom-built computer system (Assembler).

By completing the project, we gained a deep understanding of how computers work and how the various components of a computer system work together to perform complex tasks. We also gained hands-on experience with software tools and hardware simulations, as well as skills in digital logic design, computer architecture, machine language programming, and operating systems.

In this repository, we have included all the necessary files and documentation for our custom-built computer system, including schematics, verilog codes, python codes and a detailed README file that outlines the project's goals, requirements, and implementation details. Overall, this project was a significant achievement and a valuable learning experience in the field of computer science and electronics engineering.


# Design
The project consists of a top level module named top. It instantiates these major submodules:

* VGA
* VGA RAM
* VGA ROM
* CPU
* CPU ROM
* CPU RAM

### VGA
VGA Block Diagram I/F with FPGA:

![FPGA VGA Interface](https://user-images.githubusercontent.com/121945902/232077166-b9ecc95d-fe5f-4052-a610-df3717411618.png)

### VGA RAM
VGA RAM is synchronous Dual Port RAM with 4096 addresses. Every address contains 8 bits that represent ASCII character. 

### VGA ROM
VGA ROM is synchronous ROM that inculdes the 8x8 pixelmap for each ASCII character.

The VGA logic block diagram:

![VGA Logic](https://user-images.githubusercontent.com/121945902/232080550-f5755750-82e5-4eb1-a407-1d0e7c8b6215.png)


### CPU  
The CPU's functionality is exactly as described in the nand2tetris course book. But as we decided to use synchronous RAM, input data from it will lag until the next clock cycle. To workaround this issue, the CPU stalls every second clock cycle. By stalling we mean the A, D, and PC registers are not updated. This way, when the CPU is not stalled, the input data is up to date. The CPU also including the ALU.

The CPU block diagram, as described in the course book:

![cpu_arch](https://user-images.githubusercontent.com/121945902/232078820-9ca0705b-a392-49e8-b793-81d4858fa25f.png)

# Assembler

The assembler converts .asm file to .mif file following the course book instructions. The .mif file is loaded by the different memories in the system.
