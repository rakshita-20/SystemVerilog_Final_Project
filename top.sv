module top_cp2;

bit CLK = '0;
bit MNMX = '1;
bit TEST = '1;
bit RESET = '0;
bit READY = '1;
bit NMI = '0;
bit INTR = '0;
bit HOLD = '0;

wire logic [7:0] AD;
logic [19:8] A;
logic HLDA;
logic IOM;
logic WR;
logic RD;
logic SSO;
logic INTA;
logic ALE;
logic DTR;
logic DEN;

logic [19:0] Address;
wire logic [7:0]  Data;

bit [3:0] CS;

Intel8088 P(CLK, MNMX, TEST, RESET, READY, NMI, INTR, HOLD, AD, A, HLDA, IOM, WR, RD, SSO, INTA, ALE, DTR, DEN);

io_memory DUT1(.CLK(CLK),.RESET(RESET),.CS(CS[0]),.ALE(ALE),.RD(RD),.WR(WR),.Address(Address),.Data(Data));
io_memory DUT2(.CLK(CLK),.RESET(RESET),.CS(CS[1]),.ALE(ALE),.RD(RD),.WR(WR),.Address(Address),.Data(Data));
io_memory DUT3(.CLK(CLK),.RESET(RESET),.CS(CS[2]),.ALE(ALE),.RD(RD),.WR(WR),.Address(Address),.Data(Data));
io_memory DUT4(.CLK(CLK),.RESET(RESET),.CS(CS[3]),.ALE(ALE),.RD(RD),.WR(WR),.Address(Address),.Data(Data));

// 8282 Latch to latch bus address
always_latch
begin
if (ALE)
	Address <= {A, AD};
end

// 8286 transceiver
assign Data =  (DTR & ~DEN) ? AD   : 'z;
assign AD   = (~DTR & ~DEN) ? Data : 'z;

//Chip Select logic
always_comb
begin
	if(!IOM && Address[19])
		CS = 4'b0001;
		
	else if(!IOM && !Address[19])
		CS = 4'b0010;
		
	else if(IOM && Address[15:4] == 12'hFF0)
		CS = 4'b0100;
		
	else if(IOM && Address[15:9] == 8'h0E)
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