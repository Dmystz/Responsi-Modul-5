// ============================================================
// Clock Divider
// Menghasilkan clk_out dengan frekuensi = clk / (2*DIV)
// Default: 100MHz / 200_000_000 = 0.5 Hz (terlalu lambat)
// Gunakan DIV=100_000_000 → ~0.5 Hz  (tiap 2 detik toggle)
//         DIV=50_000_000  → ~1 Hz
//         DIV=100_000     → ~500 Hz (untuk 7-seg refresh)
// ============================================================
module clk_divider #(
    parameter DIV = 50_000_000
)(
    input  wire clk,
    output reg  clk_out = 0
);
    integer count = 0;
    always @(posedge clk) begin
        if (count >= DIV - 1) begin
            count   <= 0;
            clk_out <= ~clk_out;
        end else begin
            count <= count + 1;
        end
    end
endmodule

// ============================================================
// Debounce
// Menggunakan counter 20-bit (~10ms pada 100MHz)
// ============================================================
module debounce (
    input  wire clk,
    input  wire btn_in,
    output reg  btn_out = 0
);
    reg [19:0] count = 0;
    reg btn_sync = 0;

    always @(posedge clk) begin
        btn_sync <= btn_in;
        if (btn_sync == btn_out)
            count <= 0;
        else begin
            count <= count + 1;
            if (count == 20'hFFFFF)
                btn_out <= btn_sync;
        end
    end
endmodule
