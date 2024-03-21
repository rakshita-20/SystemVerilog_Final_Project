// ECE 571: SystemVerilog Project, Team 7 //
// Authors: Inti Rohith Sri Krishna, Mohammeed Abbas Shaik, Rakshita Joshi, Srikar Varma Datla
// IO/Memory module, acts as either based on how it is instantiated//

module io_memory #(parameter trace = 6, parameter addr_bits, parameter data_bits = 8)
					(Intel8088Pins.Peripheral pins, input logic [19:0] Address, inout logic [data_bits-1:0] Data, input logic CS);


logic LOAD, OE, WE; //FSM signals
logic [addr_bits-1:0] addr;
logic [data_bits-1:0] register [(2**addr_bits)-1:0];

//One-hot encoding for the states
typedef enum logic [4:0]{

IDLE	        = 5'b00001,
VALID	        = 5'b00010,
READ	        = 5'b00100,
WRITE	        = 5'b01000,
INTERMEDIATE	= 5'b10000

} statetype;

statetype State, NextState;


//using $readmemh to initialize the memory array
initial 
begin
	case(trace)
	
	1: $readmemh("trace1.txt", register);
		
	2: $readmemh("trace2.txt", register);
	
	3: $readmemh("trace3.txt", register);
	
	4: $readmemh("trace4.txt", register);
	
	default: $readmemh("trace1.txt", register);
	
	endcase
end

//Sequential State transition logic
always_ff @(posedge pins.CLK)
	begin
		if(pins.RESET)
			State <= IDLE;
		else 
			State <= NextState;
	end

//Loading the address
always_latch
begin
    if(LOAD)
        addr <= Address;
end
	
//Write function
always_ff@(posedge pins.CLK)
begin
	if(WE)
		register[addr] <= Data;
		
end

//Read function
assign Data = OE ? register[addr] : 'z;

// State Transition Combinational Logic 
always_comb
begin
	NextState = State;
	unique0 case(State)
	
	IDLE:	        if(CS && pins.ALE)
				        NextState = VALID;
		
	VALID:          begin
                    if(!pins.RD)
                        NextState = READ;
                    else if(!pins.WR)
                        NextState = WRITE;
                    end
		
	READ:	        NextState = INTERMEDIATE;
		
	WRITE:	        NextState = INTERMEDIATE;
		
	INTERMEDIATE:	NextState = IDLE;
	
	endcase
end
	
//Combinational Output logic 
always_comb
begin
	{LOAD,OE,WE} = 3'b000;
	unique0 case(State)
	
	IDLE:           {LOAD,OE,WE} = 3'b000;
		
	VALID:          LOAD = '1;
		
	READ:           OE = '1;
		
	WRITE:          WE = '1;
		
	INTERMEDIATE:   {LOAD,OE,WE} = 3'b000;
		
	endcase
end

endmodule