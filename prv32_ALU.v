module prv32_ALU(
	input   wire [31:0] a, b,
	input [6:0] opcode,
	input   wire [4:0]  shamt,
	output  reg  [31:0] r,
	output  wire        cf, zf, vf, sf,
	input   wire [4:0]  alufn
);

    wire [31:0] add, sub, op_b;
    wire cfa, cfs;
    reg signed [63:0] r_mul; 
    reg signed [31:0] sA;
    reg signed [31:0] sB;
    
    assign op_b = (~b);
    
    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b);
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);
    
     reg [4:0] shift;
 
 always@(*) begin
 if(opcode == 7'b0110011) shift = b[4:0];
 else if(opcode == 7'b0010011) shift = shamt;
 end
 
    
//  wire signed [31:0] sh;
//   shifter shifter0(.a(a), .shamt(shamt), .type(alufn[1:0]),  .r(sh));
    
    always @ * begin
        r = 0;
        (* parallel_case *)
        case (alufn)
            // arithmetic
            5'b00_000 : r = add; //add   
            5'b00_010 : r = a - b; //sub   
            5'b00_110 : r = b; //unknown  
            // logic
            5'b01_000:  r = a | b; 
            5'b01_010:  r = a & b; 
            5'b01_110:  r = a ^ b; 
            // shift
            5'b10_000:  r= a << shift; 
            5'b10_010:  r = a >> shift; 
            5'b10_100: begin r = a >>> shift; end
            
            //mul - signed x signed - lower bits
            5'b10_110: begin 
//                        r_mul = ((~a)+32'd1)*((~b)+32'd1); 
                        sA = a;
                        sB = b;
                        r_mul = sA*sB; 
                        r = r_mul[31:0]; 
                       end
            
            //mulh signed x signed - upper bits
            5'b10_111: begin 
            // r_mul = ((~a)+32'd1)*((~b)+32'd1);
                        sA = a;
                        sB = b;
                        r_mul = sA*sB;
                        r = r_mul [63:32];
                       end 
           
            //mulhsu  signed x usigned - upper bits
            5'b00_001: begin
                        sA = a;
                        r_mul = sA*b; 
                        r = r_mul[63:32]; 
                      end
            
            //mulhu unsigned x unsigned - upper bits
            5'b00_011: begin  
                        r_mul = a*b; 
                        r = r_mul[63:32]; 
                        end
            //div
            5'b11_100: begin   sA = a; sB = b; r = sA/sB;   end
            //divu
            5'b01_100: r = a/b;
            //rem
            5'b00_100: begin  sA = a; sB = b; r = sA % sB;   end
            //remu
            5'b11_000: r = a%b;                       
            
            // slt & sltu
            5'b11_010:  r = {31'b0,(sf != vf)}; 
            5'b11_110:  r = {31'b0,(~cf)};
        endcase
    end
endmodule