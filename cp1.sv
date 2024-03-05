module io_memory(clock,reset,CS,ALE,RD,WR,A,AD);

input logic clock,reset,CS,ALE,RD,WR;
input logic [19:8] A;
inout logic [7:0] AD;

parameter bit ON = 1;
localparam add_bits = 20;

logic LOAD,OE,WE;
logic [(add_bits-1):0] valid_addr;
logic [(2**add_bits)-1:0][7:0] register;

typedef enum logic [4:0]{

IDLE	= 5'b00001,
VALID	= 5'b00010,
READ	= 5'b00100,
WRITE	= 5'b01000,
UPDATE	= 5'b10000

} statetype;

statetype cs,ns;

always_ff@(posedge clock)
	begin
		if(reset)
			cs <= IDLE;
		else 
			cs <= ns;
	end
	
// Logic for Address Latch Enable
always_latch
	begin
		if(LOAD)
			valid_addr <= {A,AD};
	end

	
always_ff@(posedge clock)
	begin
		register[valid_addr] = WE ? AD : 'z;
	end

assign AD = OE ? register[valid_addr] : 'z;

// Next State Logic 
always_comb
	begin
		ns = cs;
		case(cs)
		
		IDLE: begin
				if(ALE)
					ns = VALID;
			end
			
		VALID: begin
				if(!RD)
					ns = READ;
				else if(!WR)
					ns = WRITE;
			end
			
		READ: begin
				if(RD)
					ns = UPDATE;
			end
			
		WRITE: begin
				if(WR)
					ns = UPDATE;
			end
			
		UPDATE: ns = IDLE;
		
		endcase
	end
	
// Output logic 
always_comb
	begin
		{LOAD,OE,WE} = 3'b000;
		case(cs)
		
		IDLE: begin
				{LOAD,OE,WE} = 3'b000;
			end
			
		VALID: begin
				LOAD = '1;
			end
			
		READ: begin
				OE = '1;
			end
			
		WRITE: begin
				WE = '1;
			end
			
		UPDATE: begin
				{LOAD,OE,WE} = 3'b000;
			end
			
		endcase
	end
	
endmodule