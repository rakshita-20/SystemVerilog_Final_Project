// Creating a .txt file with hexadecimal values to be used by $readmemh //

module createTextfile;

string filename = "values.txt";

bit [7:0] fileValues[2**20];

task writeValues();
    automatic int fd; //automatic file descriptor for efficient memory usage
    fd = $fopen(filename, "w"); // Open file (values.txt) in write mode
    if (!fd) begin
        $error("Error opening file for writing");
        $finish;
    end

    foreach(fileValues[i])
    begin
        $fdisplay(fd, "%h", fileValues[i]);
    end
$fclose(fd); //Close values.txt
endtask

initial
begin
    $randomize;
    foreach (fileValues[i])
    begin
        fileValues[i] = $urandom_range(8'h0, 8'hFF);
    end

    writeValues();
    $display("------Successfully written in file------\n");
    $finish;
end

endmodule
