/* Module: ppfifo_data_sink
 *
 * Description: Whenever data is available within the FIFO activate it and read it all
 */

module ppfifo_sink #(
  parameter                       DATA_WIDTH    = 8
)(
  input                           clk,
  input                           rst,

  //Ping Pong FIFO Interface
  input                           i_rd_rdy,
  output  reg                     o_rd_act,
  input       [23:0]              i_rd_size,
  output  reg                     o_rd_stb,
  input       [DATA_WIDTH - 1:0]  i_rd_data
);

//Local Parameters
//Registers/Wires
reg   [23:0]          r_count;
//Submodules
//Asynchronous Logic
//Synchronous Logic
always @ (posedge clk) begin
  //De-Assert Strobes
  o_rd_stb            <=  0;

  if (rst) begin
    o_rd_act          <=  0;
    r_count           <=  0;
    o_rd_stb          <=  0;
  end
  else begin
    if (i_rd_rdy && !o_rd_act) begin
      r_count         <=  0;
      o_rd_act        <=  1;
    end
    else if (o_rd_act) begin
      if (r_count < i_rd_size) begin
        o_rd_stb      <=  1;
        r_count       <=  r_count + 1;
      end
      else begin
        o_rd_act      <=  0;
      end
    end
  end
end


endmodule
