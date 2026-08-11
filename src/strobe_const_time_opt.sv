module strobe #(
  parameter W = 8
) (
  input  logic         clk,
  input  logic         rstn,
  input  logic         s_i,
  input  logic [W-1:0] k_i,
  input  logic         v_i,
  output logic         v_o
);

  // NOTE not really constant time logic because of setup muxes

  logic         enable;
  logic         setup;

  assign enable = setup | v_i;
  assign setup  = v_o | s_i;

  logic [W-1:0] s;
  logic [W-1:0] c;

  logic [W-1:0] s_q;
  logic [W-1:0] c_q;
  logic [W-1:0] s_d;
  logic [W-1:0] c_d;

  assign s = s_q ^ c_q;
  assign c = s_q & c_q;

  always_ff @(posedge clk, negedge rstn) begin
    if (!rstn) s_q <= 0;
    else if (enable) s_q <= s_d;
  end

  assign s_d = setup ? ~k_i : s;

  always_ff @(posedge clk, negedge rstn) begin
    if (!rstn) c_q <= 0;
    else if (enable) c_q <= c_d;
  end
  assign c_d = setup ? 0 : (c << 1) | 1'b1;

  // prefix-and of sum for detecting terminating condition in constant time

  // pad S to even size
  localparam P = W + (W % 2);

  logic [P-1:0] s_x;
  logic         v_x;

  if (P > W) begin
    assign s_x[P-1] = 1'b1;
  end

  assign s_x[W-1:0] = s[W-1:0];

  // even bits of prefix-and of S

  localparam K = P / 2;

  logic [K-1:0] p_d;
  logic [K-1:0] p_q;

  for (genvar i = 0; i < K - 1; i += 1) begin

    assign p_d[i] = &s_x[2*i+:2] & p_q[i+1];

  end

  assign p_d[K-1] = &s_x[P-1-:2];

  always_ff @(posedge clk, negedge rstn) begin

    if (!rstn) p_q <= 0;

    // In practice, initialization of A can be simplified except when counting to very small numbers. For example, if k_n >= W / 2, then we can safely initialize A to 0. By the time W / 2 cycles have passed, A will contain the correct prefix-and of S.

    else if (enable) p_q <= setup ? 0 : p_d;

  end
  assign v_o = p_d[0] & v_i;

`ifndef SYNTHESIS
  always @(posedge clk) assert (!v_i || v_o === (&s & v_i)) else $fatal(1);
`endif

endmodule
