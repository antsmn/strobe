module tb_strobe;
  parameter WIDTH = 8;
  logic             clk;
  logic             resetn;
  logic             s_i;
  logic [WIDTH-1:0] k_i = 0;
  logic             v_i;
  logic             v_o;

  assign v_i = 1;

  initial begin
    clk = 1'b0;
    forever clk = #1 ~clk;
  end
  initial begin
    resetn <= 1'b0;
    @(posedge clk);
    resetn <= 1'b1;
  end

  initial begin
    $dumpfile("tb_strobe");
    $dumpvars(0, tb_strobe);

    @(negedge resetn);
    s_i <= 0;
    @(posedge resetn);
    @(posedge clk);
    s_i <= 1'b1;
    @(posedge clk);
    s_i <= 1'b0;

    repeat (1<<10) begin
      @(posedge clk);
    end

    $finish(0);

  end

  always @(posedge clk) begin

    if (v_o) k_i <= k_i + 1;
  end
  strobe #(.W(WIDTH)) DUT (.*);


endmodule
