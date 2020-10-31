module buffer
#(
    parameter       WIDTH_ADDR  = 8,
                    WIDTH_ROW   = 8 * 64,
                    DEPTH       = 8,
                    DEPTH_PTR   = 3
)
(
    input       wire    clk,
    input       wire    rst,

    input       wire                            wr_val,
    input       wire    [WIDTH_ADDR - 1 : 0]    wr_addr,
    input       wire    [WIDTH_ROW  - 1 : 0]    wr_data,
    input       wire    [DEPTH_PTR  - 1 : 0]    wr_cell,

    input       wire                            rd_val,
    input       wire    [WIDTH_ADDR - 1 : 0]    rd_addr,
    output      reg     [WIDTH_ROW  - 1 : 0]    rd_data,
    output      reg                             rd_hit,
    output      reg     [DEPTH_PTR  - 1 : 0]    rd_cell,
    
    input       wire                            rls_val,
    input       wire    [DEPTH_PTR  - 1 : 0]    rls_cell,
    output      reg                             wrb_val,
    output      reg     [WIDTH_ADDR - 1 : 0]    wrb_addr,
    output      reg     [WIDTH_ROW  - 1 : 0]    wrb_data
);

genvar  i;

integer j;

reg     [WIDTH_ADDR - 1 : 0]    addr    [DEPTH - 1 : 0];
reg     [WIDTH_ROW  - 1 : 0]    row     [DEPTH - 1 : 0];
reg     [DEPTH      - 1 : 0]    val;

wire    [DEPTH      - 1 : 0]    hit;
wire    [DEPTH      - 1 : 0]    rls_hit;


generate
    for (i = 0; i < DEPTH; i = i + 1) begin: wr_row
        assign  hit[i]          = (addr[i] == rd_addr) & val[i] & rd_val;
        assign  rls_hit[i]      = (i == rls_cell) & val[i] & rls_val;
        
        always @(posedge clk)
            if (rst | rls_hit[i])  
                val[i]  <= 1'b0;
            else        
                val[i]  <= ((i == wr_cell) & wr_val) ? 1'b1 : val[i];
            
        always @(posedge clk) begin
            addr[i]     <= ((i == wr_cell) & wr_val) ? wr_addr : addr[i];
            row[i]      <= ((i == wr_cell) & wr_val) ? wr_data : row[i];
        end
    end
endgenerate

always @(posedge clk)
    rd_hit      <= |(hit);
    
always @(posedge clk)
    for (j = 0; j < DEPTH;  j = j + 1) 
        if (hit[j]) begin
            rd_cell     <= j[DEPTH_PTR - 1 : 0];
            rd_data     <= row[j];
        end

always @(posedge clk)
    wrb_val     <= |(rls_hit);
        
always @(posedge clk)
    for (j = 0; j < DEPTH; j = j + 1)
        if (rls_hit[j]) begin
            wrb_addr    <= addr[j];
            wrb_data    <= row[j];
        end
endmodule
