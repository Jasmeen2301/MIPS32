`include "mips.v"

module mips_tb3;

  reg clk1, clk2;
  integer k;

  mips32 mips(clk1, clk2);   

  initial begin
    clk1 = 0; clk2 = 0;
    repeat(50) begin
      #5 clk1 = 1; #5 clk1 = 0;
      #5 clk2 = 1; #5 clk2 = 0;
    end
  end

  initial begin

    for (k = 0; k < 31; k = k + 1)
      mips.REG[k] = k;

    //Factorial of a N(7 here) stored in memory location 200. The result will be stored in memory location 198.
    mips.MEM[0] = 32'h280a00c8;    // ADDI  R10,R0,200
    mips.MEM[1] = 32'h28020001;    // ADDI  R2,R0,1
    mips.MEM[2] = 32'h21430000;    // LW    R3,0(R10)
    mips.MEM[3] = 32'h0e94a000;    // OR R20, R20, R20  ->  dummy
    mips.MEM[4] = 32'h14431000;    // LOOP: MUL  R2,R2,R3
    mips.MEM[5] = 32'h2c630001;    // SUBI  R3,R3,1
    mips.MEM[6] = 32'h0e94a000;    // OR R20, R20, R20   ->  dummy
    mips.MEM[7] = 32'h3460fffc;    // BNEQZ R3,Loop   -> offset = -4(4-8)
    mips.MEM[8] = 32'h2542fffe;    // SW    R2,-2(R10)
    mips.MEM[9] = 32'hfc000000;    // HLT
 

    mips.MEM[200] = 7;       
    mips.HALTED = 0;
    mips.TAKEN_BRANCH = 0;
    mips.PC = 0;

    #1000;

    $display("Mem[200] = %0d, Mem[198] = %0d", mips.MEM[200], mips.MEM[198]);

    $finish;
  end

  initial begin
    $dumpfile("mips3.vcd");
    $dumpvars(0, mips_tb3);
    $monitor("R2: %0d", mips.REG[2]);
  end

endmodule
