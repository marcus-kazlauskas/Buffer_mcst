`timescale 1 ns / 1 ns

`include "buffer.v"

module buffer_tb;

parameter WIDTH_ADDR    = 8;
parameter WIDTH_ROW     = 8 * 64;
parameter DEPTH         = 8;

function integer clogb2;
    input integer value;
    begin
        value = value - 1;
        
        for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) begin
            value = value >> 1;
        end
    end
endfunction

parameter DEPTH_PTR = clogb2(DEPTH);

reg     clk = 1'h1;
reg     rst = 1'h0;

reg                             wr_val;
reg     [WIDTH_ADDR - 1 : 0]    wr_addr;
reg     [WIDTH_ROW  - 1 : 0]    wr_data;
reg     [DEPTH_PTR  - 1 : 0]    wr_cell;

reg                             rd_val;
reg     [WIDTH_ADDR - 1 : 0]    rd_addr;
reg     [WIDTH_ROW  - 1 : 0]    rd_data;
reg                             rd_hit;
reg     [DEPTH_PTR  - 1 : 0]    rd_cell;

reg                             rls_val;
reg     [DEPTH_PTR  - 1 : 0]    rls_cell;
reg                             wrb_val;
reg     [WIDTH_ADDR - 1 : 0]    wrb_addr;
reg     [WIDTH_ROW  - 1 : 0]    wrb_data;

buffer #( 
    .WIDTH_ADDR(WIDTH_ADDR),
    .WIDTH_ROW(WIDTH_ROW),
    .DEPTH(DEPTH),
    .DEPTH_PTR(DEPTH_PTR)
)
buffer0 (
    .clk(clk),
    .rst(rst),
    
    .wr_val(wr_val),
    .wr_addr(wr_addr),
    .wr_data(wr_data),
    .wr_cell(wr_cell),
    
    .rd_val(rd_val),
    .rd_addr(rd_addr),
    .rd_data(rd_data),
    .rd_hit(rd_hit),
    .rd_cell(rd_cell),
    
    .rls_val(rls_val),
    .rls_cell(rls_cell),
    .wrb_val(wrb_val),
    .wrb_addr(wrb_addr),
    .wrb_data(wrb_data)
);
    
always
    #1  clk = ~clk;
    
initial begin
    @(posedge clk) begin
        rst     <= 1'h1;
        
        wr_val  <= 1'h0;
        
        rd_val  <= 1'h0;
        
        rls_val <= 1'h0;
    end
        
    @(posedge clk)
        rst     <= 1'h0;
        
    @(posedge clk) begin
        wr_val  <= 1'h1;
        wr_addr <= 8'h13;
        wr_data <= 8'haa;
        wr_cell <= 4'h3;
    end
        
    @(posedge clk) begin
        wr_addr <= 1'h1;
        wr_data <= 8'hbb;
        wr_cell <= 4'h1;
        
        rd_val  <= 1'h1;
        rd_addr <= 'h13;
    end
    
    @(posedge clk) begin
        wr_val  <= 1'h0;
        
        rd_addr <= 'h10;
    end
    
    @(posedge clk) begin      
        rd_addr <= 1'h1;
    end
    
    @(posedge clk) begin
        rd_val  <= 1'h0;
        
        rls_val         <= 1'h1;
        rls_cell        <= 4'h1;
    end
    
    @(posedge clk)
        rls_cell        <= 4'h1;
    
    @(posedge clk)
        rls_cell        <= 4'h2;
        
    @(posedge clk)
        rls_cell        <= 4'h3;
        
    @(posedge clk)
        rls_val         <= 1'h0;
    
    @(posedge clk) begin
        $stop();
    end
end
endmodule
