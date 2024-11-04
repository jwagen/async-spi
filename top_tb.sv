module tb;



  integer cnt = 0;

  logic clk_sys;
  logic spi_clk;
  logic spi_miso;
  logic spi_mosi;

  parameter CLK_SYS_PERIOD = 10;
  parameter TIMEOUT = 100;

  // Clk generator
  always begin
    clk_sys = 0;
    #(CLK_SYS_PERIOD / 2);
    clk_sys = 1;
    #(CLK_SYS_PERIOD / 2);

    cnt = cnt + 1;
    if (cnt == TIMEOUT) $finish();
  end

  spi_slave DUT (
    .spi_clk(spi_clk),
    .spi_miso(spi_miso),
    .spi_mosi(spi_mosi),
    .clk_sys(clk_sys),
    .data_sync()
  );






  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end
endmodule
