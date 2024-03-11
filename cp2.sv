module io_memory(CLK, RESET, CS, ALE, RD, WR, Address, Data);

input logic CLK, RESET, CS, ALE, RD, WR;
input logic [19:0] Address;
inout wire logic [7:0] Data;

logic LOAD, OE, WE;
logic [19:0] addr;
logic [7:0] register [2**20-1 : 0];

typedef enum logic [4:0]{

IDLE	        = 5'b00001,
VALID	        = 5'b00010,
READ	        = 5'b00100,
WRITE	        = 5'b01000,
INTERMEDIATE	= 5'b10000

} statetype;

statetype State, NextState;

initial $readmemh("values.txt", register);

always_ff @(posedge CLK)
	begin
		if(RESET)
			State <= IDLE;
		else 
			State <= NextState;
	end


always_latch
begin
    if(LOAD)
        addr <= Address;
end
	

always_ff@(posedge CLK)
begin
	if(WE)
	register[addr] = Data;
	else
	register[addr] = register[addr];
end

assign Data = OE ? register[addr] : 'z;

// State Transition Combinational Logic 
always_comb
begin
	NextState = State;
	unique case(State)
	
	IDLE:	        if(CS && ALE)
				        NextState = VALID;
		
	VALID:          begin
                    if(!RD)
                        NextState = READ;
                    else if(!WR)
                        NextState = WRITE;
                    end
		
	READ:	        NextState = INTERMEDIATE;
		
	WRITE:	        NextState = INTERMEDIATE;
		
	INTERMEDIATE:	NextState = IDLE;
	
	endcase
end
	
// Output logic 
always_comb
begin
	{LOAD,OE,WE} = 3'b000;
	unique case(State)
	
	IDLE:           {LOAD,OE,WE} = 3'b000;
		
	VALID:          LOAD = '1;
		
	READ:           OE = '1;
		
	WRITE:          WE = '1;
		
	INTERMEDIATE:   {LOAD,OE,WE} = 3'b000;
		
	endcase
end

endmodule