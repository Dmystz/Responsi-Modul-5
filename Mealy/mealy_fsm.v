// ============================================================
// Mealy FSM - Traffic Light
// Board  : Nexys A7 100T
// States : Red=00, Yellow=01, Green=10, D=11(unused)
// Input  : w (toggle push button M17)
// Output : Zr (H17), Zy (K15), Zg (J13)
// Reset  : N17 (active high → kembali ke Red)
//
// Perbedaan dengan Moore:
//   Output dievaluasi bersamaan dengan transisi (f(state, w))
//   Di soal ini persamaan output identik karena z=1 semua kondisi,
//   tapi secara struktural output sudah dideklarasikan sebagai
//   fungsi kombinasional dari (state, w).
// ============================================================

module mealy_fsm (
    input  wire clk,        // 100 MHz system clock
    input  wire btn_reset,  // N17 - reset ke Red
    input  wire btn_w,      // M17 - toggle w
    output wire led_red,    // H17
    output wire led_yellow, // K15
    output wire led_green,  // J13
    // Seven segment
    output wire [7:0] seg,
    output wire [7:0] an
);

    // --------------------------------------------------------
    // Clock divider & debounce
    // --------------------------------------------------------
    wire clk_slow;
    wire clk_refresh;

    clk_divider #(.DIV(100_000_000)) u_slow (.clk(clk), .clk_out(clk_slow));
    clk_divider #(.DIV(100_000))     u_ref  (.clk(clk), .clk_out(clk_refresh));

    wire reset;
    wire btn_w_debounced;
    debounce u_rst (.clk(clk), .btn_in(btn_reset),  .btn_out(reset));
    debounce u_w   (.clk(clk), .btn_in(btn_w),      .btn_out(btn_w_debounced));

    // --------------------------------------------------------
    // Toggle flip-flop untuk w
    // --------------------------------------------------------
    reg w = 0;
    reg btn_w_prev = 0;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            w          <= 0;
            btn_w_prev <= 0;
        end else begin
            btn_w_prev <= btn_w_debounced;
            if (btn_w_debounced && !btn_w_prev)
                w <= ~w;
        end
    end

    // --------------------------------------------------------
    // Mealy FSM
    // --------------------------------------------------------
    reg [1:0] state = 2'b00;
    reg [1:0] next_state;

    // Next state logic (sama dengan Moore)
    always @(*) begin
        case (state)
            2'b00: next_state = w ? 2'b00 : 2'b01;
            2'b01: next_state = w ? 2'b01 : 2'b10;
            2'b10: next_state = w ? 2'b10 : 2'b00;
            default: next_state = 2'b00;
        endcase
    end

    always @(posedge clk_slow or posedge reset) begin
        if (reset) state <= 2'b00;
        else       state <= next_state;
    end

    // --------------------------------------------------------
    // Output logic (Mealy: fungsi state DAN w)
    // Karena z=1 di semua transisi, output tetap = fungsi state
    // tapi secara arsitektur sudah Mealy (combinational dengan w)
    //
    // Zr: aktif di state Red (00), baik w=0 maupun w=1
    // Zy: aktif di state Yellow (01), baik w=0 maupun w=1
    // Zg: aktif di state Green (10), baik w=0 maupun w=1
    // --------------------------------------------------------
    reg zr, zy, zg;
    always @(*) begin
        // default
        zr = 0; zy = 0; zg = 0;
        case (state)
            2'b00: begin // Red
                zr = 1; // w=0: transisi ke Yellow, z=1 | w=1: stay Red, z=1
                zy = 0;
                zg = 0;
            end
            2'b01: begin // Yellow
                zr = 0;
                zy = 1; // w=0: transisi ke Green, z=1 | w=1: stay Yellow, z=1
                zg = 0;
            end
            2'b10: begin // Green
                zr = 0;
                zy = 0;
                zg = 1; // w=0: transisi ke Red, z=1 | w=1: stay Green, z=1
            end
            default: begin zr = 0; zy = 0; zg = 0; end
        endcase
    end

    assign led_red    = zr;
    assign led_yellow = zy;
    assign led_green  = zg;

    // --------------------------------------------------------
    // Output y untuk seven segment
    // Di Mealy, y merepresentasikan output aktif saat ini
    // --------------------------------------------------------
    wire [1:0] y_out;
    assign y_out = {zg, zy}; // encode: Green=10, Yellow=01, Red=00

    // --------------------------------------------------------
    // Seven segment display
    // --------------------------------------------------------
    seven_segment u_seg (
        .clk_refresh (clk_refresh),
        .reset       (reset),
        .w           (w),
        .y           (y_out),
        .state       (state),
        .seg         (seg),
        .an          (an)
    );

endmodule
