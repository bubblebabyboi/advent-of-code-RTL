module safe_cracker #(
    parameter int START_POS    = 50,
    parameter int DIAL_SIZE    = 100,
    parameter int PASSCODE_LEN = 32,
    parameter int AXI_DWIDTH   = 8
)(
    input  logic                         clk,
    input  logic                         rst_n,

    input  logic                         s_axis_tvalid,
    input  logic [AXI_DWIDTH-1:0]        s_axis_tdata,     
    output logic                         s_axis_tready,
    input  logic                         s_axis_tlast, 

    output logic                         done,
    output logic [$clog2(DIAL_SIZE)-1:0] curr_pos, 
    output logic [PASSCODE_LEN-1:0]      passcode
);

    localparam int W  = $clog2(DIAL_SIZE);
    localparam int AW = W + 4;                                              // Accumulator width +4 for *10 intermediate value

    localparam logic [AW-1:0] C_TEN  = AW'(10);
    localparam logic [AW-1:0] C_ZERO = AW'("0");
    localparam logic [AW-1:0] C_DIAL = AW'(DIAL_SIZE);
    
    // Extended dial by 1 for wrap around 
    localparam logic [W:0]    C_DIAL_EXT = (W+1)'(DIAL_SIZE);

    logic          is_digit;
    logic [AW-1:0] accum_calc;
    logic [W-1:0]  accum_mod;
    logic [W-1:0]  accum;
    logic [W-1:0]  distance;

    assign s_axis_tready = !done;
    assign curr_pos      = pos;

    assign is_digit   = (s_axis_tdata >= "0" && s_axis_tdata <= "9");
    assign distance   = is_digit ? accum_mod : accum;

    assign accum_calc = (AW'(accum) * C_TEN) + AW'(s_axis_tdata) - C_ZERO;  // 10 * accum + (ASCII code - '0')
    assign accum_mod  = W'(accum_calc % C_DIAL);                            // % dial size to stay within dial size

    logic [W-1:0] pos;
    logic [W-1:0] pos_nxt;
    logic         is_right;
    logic         parsing;

    logic [W:0]  calc_right;
    logic [W:0]  calc_left_wrap;

    assign calc_right     = (W+1)'(pos) + (W+1)'(distance);
    assign calc_left_wrap = (W+1)'(pos) + C_DIAL_EXT - (W+1)'(distance);

    always_comb begin
        if (is_right) begin
            if (calc_right >= C_DIAL_EXT)
                pos_nxt = W'(calc_right - C_DIAL_EXT);
            else
                pos_nxt = W'(calc_right);
        end else begin
            if (pos >= distance)
                pos_nxt = W'(pos - distance);
            else
                pos_nxt = W'(calc_left_wrap);
        end
    end

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            pos      <= W'(START_POS);
            is_right <= 1'b0;
            parsing  <= 1'b0;
            done     <= 1'b0;
            accum    <= '0;
            passcode <= '0;

        end else if (s_axis_tvalid && s_axis_tready) begin
            if (s_axis_tdata == "L") begin
                is_right <= 1'b0;
                parsing  <= 1'b1;
                accum    <= '0;

            end else if (s_axis_tdata == "R") begin
                is_right <= 1'b1;
                parsing  <= 1'b1;
                accum    <= '0;

            end else if (is_digit && parsing) begin
                accum    <= accum_mod;

            end else if (s_axis_tdata == "\n") begin
                parsing  <= 1'b0;
                pos      <= pos_nxt;
                
                if (pos_nxt == '0) begin
                    passcode <= passcode + 1'b1;
                end
            end

            if (s_axis_tlast) begin
                // If stream ends on a # update position 
                if (parsing && s_axis_tdata != "\n") begin
                    pos <= pos_nxt;
                    
                    if (pos_nxt == '0) begin
                        passcode <= passcode + 1'b1;
                    end
                end
                
                done <= 1'b1;
            end
        end
    end

endmodule