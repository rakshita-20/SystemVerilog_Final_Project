// Creating an interface between the Processor and the Peripheral modules

interface Intel8088Pins (input logic CLK , RESET);
logic MNMX;
logic TEST;

logic READY;
logic NMI;
logic INTR;
logic HOLD;

logic HLDA;
tri [7:0] AD;
tri [19:8] A;

logic IOM;
logic WR;
logic RD;
logic SSO;
logic INTA;
logic ALE;
logic DTR;
logic DEN;

// Modport declared for the processor 
modport Processor(output HLDA,A,IOM,WR,RD,SSO,INTA,ALE,DTR,DEN,
		inout AD,
		input CLK,RESET,HOLD,READY,INTR,NMI,MNMX,TEST);

// Modport declared for our IOM module
modport Peripheral(input CLK,RESET,WR,RD,ALE);			


endinterface