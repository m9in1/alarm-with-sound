module tact_data(
input [31:0] A,
input clk,
output logic [31:0] RD
    );
    

    logic [31:0] RAM [0:90000]; 
    initial begin
        $readmemb("mus.bin", RAM);
    end

    always@(posedge clk) begin
        RD[31:0] = RAM[A];

    end
    
    //assign RD[31:0] = RAM[A];
    
endmodule