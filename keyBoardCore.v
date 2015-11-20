module keyBoardCore(clk, rst, rx_done_tick, rx_data, sevenOut 
    );
input clk, rst;
input rx_done_tick;
input [7:0] rx_data;
output reg [19:0] sevenOut;

wire [4:0] binary_data;
reg [4:0] binary_input, binary_inputNext;

reg [19:0] sevenOut_Next;
reg [2:0]state, stateNext;
reg [2:0]cnt, cntNext;

key2Binary key2Binary(.key_code(rx_data), .binary(binary_data));
////  write your code here

always @(posedge clk) begin
	state <= stateNext;
	sevenOut <= sevenOut_Next;
	cnt <= cntNext;
	binary_input <= binary_inputNext;
end
always @(*) begin
	stateNext = state;
	cntNext = cnt;
	binary_inputNext = binary_input;
	sevenOut_Next = sevenOut;
	if(rst) begin
		stateNext = 0;
		sevenOut_Next = 0;
		cntNext = 0;
	end 
	else begin
		case (state)
			0: begin 
				if(~(rx_done_tick)) begin
					stateNext = 0;
				end
				else begin
					if(rx_data == 8'hF0)begin
						stateNext=1;
						cntNext = 1;
					end else begin
						stateNext = 0;
					end
				end
			end
			1:begin
				if(rx_done_tick) begin
					stateNext = 0;
					binary_inputNext = binary_data;
					cntNext = 2;
				end
				else begin
					stateNext = 1;
				end
			end
		endcase
		if (cnt == 2)begin
			sevenOut_Next = {binary_input, sevenOut[19:5]};
			//stateNext = 0;
			cntNext = 0;
		end
	end
end

endmodule
