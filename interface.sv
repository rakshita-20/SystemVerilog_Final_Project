interface Intel8088Pins;
    bit CLK = '0;
    bit MNMX = '1;        
    bit TEST = '1;
    bit RESET = '0;
    bit READY = '1;
    bit NMI = '0;
    bit INTR = '0;
    bit HOLD = '0;

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
    logic [19:0] Address;
    wire [7:0]  Data;
    
  
    modport Processor(input MNMX,TEST,READY,NMI,INTR,HOLD,HLDA,inout AD,output A,IOM,WR,RD,SSO,INTA,ALE,DTR,DEN);
    modport Pheripheral(input ALE,RD,WR,Address,inout Data);

endinterface
