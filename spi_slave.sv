module spi_slave(
    input logic spi_clk,
    output logic spi_miso,
    input  logic spi_mosi,

    input logic clk_sys,
    input logic rst,
    output logic [7:0] data_sync,
    output logic data_ready_sync
);

logic [7:0] shift_reg;
logic [7:0] temp_reg;

logic [7:0] data_pre_sync;
logic data_ready_pre;

logic [2:0] bit_cnt;

logic shift_done;
logic shift_done_dl1;


always_ff @(posedge spi_clk) begin
    if(rst) begin
        shift_reg <= '0;
        bit_cnt <= '0;
        shift_done <= '0;
        shift_done_dl1 <= '0;
    end
    else begin
        shift_reg[7:1] <= shift_reg[6:0];
        shift_reg[0] <= spi_mosi;
        bit_cnt <= bit_cnt + 1;
        if (bit_cnt == 7 ) begin
            temp_reg <= shift_reg;
            shift_done <= 1;
        end
        else begin
            shift_done <= 0;
        end
        shift_done <= shift_done_dl1;


    end
end

// Synchronize data
always_ff @(posedge clk_sys) begin
    if (rst) begin
        data_sync <= 0;
        data_pre_sync <= 0;
        data_ready_pre <= 0;
        data_ready_sync <= 0;
    end
    else begin
        data_pre_sync <= temp_reg;
        data_sync <= temp_reg;

        data_ready_pre <= shift_done_dl1;
        data_ready_sync <= data_ready_pre;

    end
end

endmodule