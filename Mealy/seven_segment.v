// ============================================================
// Seven Segment Display - Nexys A7 100T
// Format display (kiri ke kanan, digit 7..0):
//   [7] w  [6] 0/1  [5] y  [4] MSB_y  [3] spasi  [2] S  [1] t  [0] state
// Contoh: w 0  y 0  St 0  → w=0, output y=00 (Red), state=0
// ============================================================
module seven_segment (
    input  wire       clk_refresh,
    input  wire       reset,
    input  wire       w,
    input  wire [1:0] y,
    input  wire [1:0] state,
    output reg  [7:0] seg,
    output reg  [7:0] an
);
    reg [2:0] digit_sel = 0;
    always @(posedge clk_refresh or posedge reset) begin
        if (reset)
            digit_sel <= 0;
        else
            digit_sel <= digit_sel + 1;
    end

    always @(*) begin
        an = 8'b11111111;
        an[digit_sel] = 1'b0;
    end

    // Kode karakter:
    // 0-3  = angka 0-3
    // 10   = 'w'
    // 11   = 'y'
    // 12   = 'S'
    // 13   = 't'
    // 14   = blank
    reg [3:0] char_code;
    always @(*) begin
        case (digit_sel)
            3'd7: char_code = 4'd10;          // 'w'
            3'd6: char_code = {3'b0, w};      // 0 atau 1
            3'd5: char_code = 4'd11;          // 'y'
            3'd4: char_code = {3'b0, y[1]};   // MSB output y
            3'd3: char_code = 4'd14;          // spasi
            3'd2: char_code = 4'd12;          // 'S'
            3'd1: char_code = 4'd13;          // 't'
            3'd0: char_code = {2'b0, state};  // 0, 1, atau 2
            default: char_code = 4'd14;
        endcase
    end

    // Nexys A7: seg aktif LOW
    // seg[7]=CA=a, seg[6]=CB=b, seg[5]=CC=c, seg[4]=CD=d
    // seg[3]=CE=e, seg[2]=CF=f, seg[1]=CG=g, seg[0]=DP
    //    aaa
    //   f   b
    //    ggg
    //   e   c
    //    ddd
    always @(*) begin
        case (char_code)
            4'd0:  seg = 8'b00000011; // '0' abcdef
            4'd1:  seg = 8'b10011111; // '1' bc
            4'd2:  seg = 8'b00100101; // '2' abdeg
            4'd3:  seg = 8'b00001101; // '3' abcdg
            4'd10: seg = 8'b11000101; // 'w' bcde
            4'd11: seg = 8'b10001001; // 'y' bcfg
            4'd12: seg = 8'b01100001; // 'S' acdfg
            4'd13: seg = 8'b11100001; // 't' defg
            4'd14: seg = 8'b11111111; // blank
            default: seg = 8'b11111111;
        endcase
    end
endmodule
