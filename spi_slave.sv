module spi_slave(
    input logic spi_clk,    // SPI clk pin
    output logic spi_miso,  // SPI miso pin
    input  logic spi_mosi,  // SPI mosi pin

    input logic clk_sys,    // System clk
    input logic rst,
    output logic [7:0] data_sync,   // Synchronized data
    output logic data_ready_sync    // Valid data in data_sync
);

logic [7:0] shift_reg;
logic [7:0] temp_reg;

logic [7:0] data_pre_sync;
logic data_ready_pre;

logic [2:0] bit_cnt;

logic shift_done;


always_ff @(posedge spi_clk) begin
    if(rst) begin
        shift_reg <= '0;
        bit_cnt <= '0;
        shift_done <= '0;
        temp_reg <= '0;
    end
    else begin
        shift_reg[7:1] <= shift_reg[6:0];
        shift_reg[0] <= spi_mosi;
        bit_cnt <= bit_cnt + 1;
        if (bit_cnt == 0 ) begin
            temp_reg <= shift_reg;
            shift_done <= 1;
        end
        else begin
            shift_done <= 0;
        end
    end
end

// Synchronize data with clk_sys domain
always_ff @(posedge clk_sys) begin
    if (rst) begin
        data_ready_pre <= 0;
        data_ready_sync <= 0;
    end
    else begin

        // Synchronize data ready signal with two registers
        data_ready_pre <= shift_done;
        data_ready_sync <= data_ready_pre;

    end
end

// Gate data_sync output. Only open gate when temp_reg is guarantied stable
// Holds as long as spi_clk is at most approx 2x clk_sys
assign data_sync = data_ready_sync ? temp_reg : 0;

endmodule