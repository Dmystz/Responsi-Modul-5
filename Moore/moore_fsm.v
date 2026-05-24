// ============================================================
// Moore FSM - Traffic Light
// Board  : Nexys A7 100T
// States : Red=00, Yellow=01, Green=10, D=11(unused)
// Input  : w (toggle push button M17)
// Output : Zr (H17), Zy (K15), Zg (J13)
// Reset  : N17 (active high → kembali ke Red)
// ============================================================

module moore_fsm (
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
    // Debounce & clock divider
    // --------------------------------------------------------
    wire clk_slow;      // ~1 Hz untuk state transition
    wire clk_refresh;   // ~1 kHz untuk 7-seg multiplexing

    clk_divider #(.DIV(100_000_000)) u_slow  (.clk(clk), .clk_out(clk_slow));
    clk_divider #(.DIV(100_000))     u_ref   (.clk(clk), .clk_out(clk_refresh));

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
            if (btn_w_debounced && !btn_w_prev)  // rising edge
                w <= ~w;
        end
    end

    // --------------------------------------------------------
    // Moore FSM
    // State encoding: Red=00, Yellow=01, Green=10
    // --------------------------------------------------------
    reg [1:0] state = 2'b00;
    reg [1:0] next_state;

    // Next state logic (N1 = W'Q0 + WQ1 ; N0 = Q1'Q0'W' + Q1'Q0W)
    always @(*) begin
        case (state)
            2'b00: next_state = w ? 2'b00 : 2'b01; // Red  : w=1 stay, w=0 → Yellow
            2'b01: next_state = w ? 2'b01 : 2'b10; // Yellow: w=1 stay, w=0 → Green
            2'b10: next_state = w ? 2'b10 : 2'b00; // Green: w=1 stay, w=0 → Red
            default: next_state = 2'b00;
        endcase
    end

    // State register (update on slow clock)
    always @(posedge clk_slow or posedge reset) begin
        if (reset) state <= 2'b00;
        else       state <= next_state;
    end

    // --------------------------------------------------------
    // Output logic (Moore: hanya fungsi state)
    // Zr = Q1'Q0'  |  Zy = Q0  |  Zg = Q1
    // LED Nexys A7 aktif HIGH
    // --------------------------------------------------------
    assign led_red    = ~state[1] & ~state[0]; // Zr
    assign led_yellow =              state[0];  // Zy
    assign led_green  =  state[1];              // Zg

    // --------------------------------------------------------
    // Output y untuk seven segment (Moore: output = state)
    // --------------------------------------------------------
    wire [1:0] y_out;
    assign y_out = state; // Red=00, Yellow=01, Green=10

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
