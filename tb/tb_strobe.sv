module tb_strobe;
  parameter WIDTH = 8;
  logic             clk;
  logic             rstn;
  logic             s_i;
  logic             v_i;
  logic             v_o;

  logic [WIDTH-1:0] k_i = 3;
  assign v_i = 1;

  initial begin
    clk = 1'b0;
    forever clk = #1 ~clk;
  end
  initial begin
    rstn <= 1'b0;
    @(posedge clk);
    rstn <= 1'b1;
  end

  initial begin
    $dumpfile("tb_strobe");
    $dumpvars(0, tb_strobe);

    @(negedge rstn);
    s_i <= 0;
    @(posedge rstn);
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
