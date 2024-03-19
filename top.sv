module top;

bit CLK = '0;
bit RESET = 0;

initial
	begin
		Bus.MNMX = '1;
		Bus.TEST = '1;
		Bus.READY = '1;
		Bus.NMI = '0;
		Bus.INTR = '0;
		Bus.HOLD = '0;
	end

logic [19:0] Address;
wire logic [7:0]  Data;

bit [3:0] CS;

// Creating an instance for our interface
Intel8088Pins Bus(.CLK(CLK),.RESET(RESET));

Intel8088 P(Bus.Processor);

io_memory #(.addr_bits(20),.data_bits(8),.trace(9)) Mhigh(Bus.Peripheral, Address, Data, CS[0]);
io_memory #(.addr_bits(20),.data_bits(8),.trace(2)) Mlow(Bus.Peripheral, Address, Data, CS[1]);
io_memory #(.addr_bits(16),.data_bits(8),.trace(3)) IO1(Bus.Peripheral, Address, Data, CS[2]);
io_memory #(.addr_bits(16),.data_bits(8),.trace(4)) IO2(Bus.Peripheral, Address, Data, CS[3]);

// 8282 Latch to latch bus address
always_latch
begin
if (Bus.ALE)
	Address <= {Bus.A, Bus.AD};
end

// 8286 transceiver
assign Data =  (Bus.DTR & ~Bus.DEN) ? Bus.AD   : 'z;
assign Bus.AD   = (~Bus.DTR & ~Bus.DEN) ? Data : 'z;

//Chip Select logic
always_comb
begin
	if(!Bus.IOM && Address[19])
		CS = 4'b0001;
		
	else if(!Bus.IOM && !Address[19])
		CS = 4'b0010;
		
	else if(Bus.IOM && Address[15:4] == 12'hFF0)
		CS = 4'b0100;
		
	else if(Bus.IOM && Address[15:9] == 8'h0E)
		CS = 4'b1000;
	
	else
		CS = '0;
	
end

always #50 CLK = ~CLK;

initial
begin
$dumpfile("dump.vcd"); $dumpvars;

repeat (2) @(posedge CLK);
RESET = '1;
repeat (5) @(posedge CLK);
RESET = '0;

repeat(10000) @(posedge CLK);
$finish();
end

endmodule