module clk_div #(parameter WIDTH = 10,// Максимальное значение счетчика: (2 ^ WIDTH) -1. Должен встретить N = <(2 ^ WIDTH)
                parameter N     = 1024)// Частота принятия решения)  (
  (input  clk,
  input  rst_n,
  output o_clk
);



reg [WIDTH-1:0] cnt_p;
reg [WIDTH-1:0] cnt_n;
reg             clk_p;
reg             clk_n;

assign o_clk = (N == 1) ? clk :
               (N[0])   ? (clk_p | clk_n) : (clk_p);
        
always@(posedge clk or negedge rst_n) begin
  if (!rst_n)
    cnt_p <= 0;
  else if (cnt_p == (N-1))
    cnt_p <= 0;
  else
    cnt_p <= cnt_p + 1;
end

always@(posedge clk or negedge rst_n) begin
  if (!rst_n) 
    clk_p <= 1;
  else if (cnt_p < (N>>1))//N >> 1 означает N / 2, то есть значение N смещено вправо на 1 бит
    clk_p = 1;
  else
    clk_p = 0;    
end

always@(negedge clk or negedge rst_n) begin
  if (!rst_n)
    cnt_n <= 0;
  else if (cnt_n == (N-1))
    cnt_n <= 0;
  else
    cnt_n <= cnt_n + 1;
end

always@(negedge clk or negedge rst_n) begin
  if (!rst_n)
    clk_n <= 1;
  else if (cnt_n < (N>>1))
    clk_n = 1;
  else
    clk_n = 0;
end

endmodule