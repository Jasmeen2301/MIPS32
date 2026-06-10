`include "Srcs/mips.v"

module mips_tb2;

    reg clk1, clk2;
    integer k;

    mips32 mips(clk1, clk2);

    initial begin
        clk1=0; clk2=0;
        repeat(20) 
        begin 
            #5 clk1=1; #5 clk1=0;
            #5 clk2=1; #5 clk2=0;
        end
    end

    initial begin
      for(k=0; k<=31; k++) begin
        mips.REG[k] = k;
      end

      // Load a word stored in memory location 120, add 45 to it, and store the result in memory location 121.
      mips.MEM[0] = 32'h28010078;   // ADDI R1, R0, 120  -> R1 = 120
      mips.MEM[1] = 32'h0c631800;   // dummy
      mips.MEM[2] = 32'h20220000;   // LW R2, 0(R1)  ->  R2 = MEM[120] = 85
      mips.MEM[3] = 32'h0c631800;   // dummy
      mips.MEM[4] = 32'h2842002d;   // ADDI R2, R2, 45   -> R2 = 85 + 45 = 130
      mips.MEM[5] = 32'h0c631800;   // dummy
      mips.MEM[6] = 32'h24220001;   // SW R2, 1(R1)   ->  MEM[121] = 130 
      mips.MEM[7] = 32'hfc000000;   // HLT  


      mips.MEM[120] = 85;
      mips.HALTED = 0;
      mips.TAKEN_BRANCH = 0;
      mips.PC = 0;

      #500;
        $display("Mem[120]: %0d \nMem[121] : %0d", mips.MEM[120], mips.MEM[121]);
    end


    initial begin
      $dumpfile("outputs/mips2.vcd");
      $dumpvars(0, mips_tb2);
      #600 $finish;
    end


endmodule


