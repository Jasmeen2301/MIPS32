`include "mips.v"

module mips_tb1;

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


      // Add three numbers 10, 20 and 30 stored in processor registers.
      mips.MEM[0] = 32'h2801000a;   // ADDI R1, R0, 10;
      mips.MEM[1] = 32'h28020014;   // ADDI R2, R0, 20;
      mips.MEM[2] = 32'h28030019;   // ADDI R3, R0, 25;
      mips.MEM[3] = 32'h00222000;   // ADD   R4,R1,R2
      mips.MEM[4] = 32'h0ce77800;   // OR    R7,R7,R7  ->  dummy 
      mips.MEM[5] = 32'h00832800;   // ADD   R5,R4,R3
      mips.MEM[6] = 32'hfc000000;   // HLT

      mips.HALTED = 0;
      mips.TAKEN_BRANCH = 0;
      mips.PC = 0;

      #280;
      for(k=0; k<6; k++) begin
        $display("R%0d - %0d", k, mips.REG[k]);
      end
    end


    initial begin
      $dumpfile("mips1.vcd");
      $dumpvars(0, mips_tb1);
      #300 $finish;
    end


endmodule

   