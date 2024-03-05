//---------------- TEAM 7 -------------------//

module iom_module #(parameter IOorM = 1)
(ALE, IOM, RD, WR, CS, CLK, RESET, A, AD);

input logic ALE, IOM, RD, WR, CS;
input bit CLK, RESET;
inout logic [7:0] AD;
input logic [19:8] A;

logic [2**19 : 1][7:0] Mem;
logic [19:0] Address;
logic [7:0]  Data;
bit Activate = '1;
bit address_load, read, write, output_enable;

enum logic [4:0] {
	T1		= 5'b00001,
	T2		= 5'b00010,
	T3      = 5'b00100,
    T4      = 5'b01000,
    T5      = 5'b10000
} State, NextState;

//Sequential logic for states in the FSM
always_ff @ (posedge CLK)
begin
if(RESET)
    State <= T1;
else
    State <= NextState;
end

//Combinational block for changing states in the FSM
always_comb
begin
NextState = State;
case (State)
    T1: NextState = ALE ? T2 : T1;

    T2: NextState = RD  ? ( WR ? T2 : T4) : T3;

    T3: NextState = T5;

    T4: NextState = T5;

    T5: NextState = T1;
endcase
end

//Combinational block for FSM outputs
always_comb
begin
{idle, address_load, read, write, output_enable} = '{0, 0, 0, 0, 0};
case (State)
    T1: begin
        end
    T2: address_load = '1;
    T3: read = '1;
    T4: write = '1;
    T5: output_enable = '1;
endcase    
end

always_latch // Latching the address
begin
    if(address_load)
        Address <= {A, AD};
end

always_comb // Output function
begin
    if(read)
        Data = Mem[Address];
    else if(write)
        Mem[Address] = AD;            
end

assign AD = output_enable ? Data : 'z;

endmodule
