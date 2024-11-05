module tb;



  integer cnt = 0;

  logic clk_sys;
  logic clk_spi;

  logic spi_clk_input;
  logic spi_miso;
  logic spi_mosi;

  logic rst;

  parameter CLK_SYS_PERIOD = 10;
  parameter CLK_SPI_PERIOD = 12;
  parameter TIMEOUT = 100;

  //logic [31:0] DATA = 32'hbadcafee;
  logic [31:0] DATA = 32'h10ff00aa;

  // Clk generator
  always begin
    clk_sys = 0;
    #(CLK_SYS_PERIOD / 2);
    clk_sys = 1;
    #(CLK_SYS_PERIOD / 2);

    cnt = cnt + 1;
    if (cnt == TIMEOUT) $finish();
  end
  assign rst = cnt == 1;

  // spi clk generator
  always begin
    #4;
    forever begin
    clk_spi = 0;
    #(CLK_SPI_PERIOD / 2);
    clk_spi = 1;
    #(CLK_SPI_PERIOD / 2);
    end

  end


  integer bit_cnt = 0;


  always @(negedge clk_spi) begin
    if (rst) begin
      bit_cnt  <= 0;
      spi_mosi <= 0;
    end
    else begin
      bit_cnt  <= bit_cnt + 1;
      spi_mosi <= DATA[31-bit_cnt];
    end

  end

  assign spi_clk_input = clk_spi;


  logic [7:0] spi_data_out;
  logic spi_data_ready;
  spi_slave DUT (
    .spi_clk(spi_clk_input),
    .spi_miso(spi_miso),
    .spi_mosi(spi_mosi),
    .clk_sys(clk_sys),
    .rst(rst),
    .data_sync(spi_data_out),
    .data_ready_sync(spi_data_ready)
  );






  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end
endmodule
