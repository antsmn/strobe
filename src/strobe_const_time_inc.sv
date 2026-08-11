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
  logic         enable;
  logic         setup;

  assign enable = setup | v_i;
  assign setup = v_o | s_i;

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

  assign v_o = &s & v_i;

endmodule
