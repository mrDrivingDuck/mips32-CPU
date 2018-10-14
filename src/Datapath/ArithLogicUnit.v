`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ZhangJingtang
// 
// Create Date: 2017/06/18 14:09:56
// Design Name: 
// Module Name: ArithLogicUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 4.0
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ArithLogicUnit(

    // RS@EԴ����������
    input  [31: 0] sourceA,
    
    // RT@EԴ����������
    input  [31: 0] sourceB,
    
    // ����ѡ��
    input  [3 : 0] func_choice,
    
    // ������
    output [31: 0] alu_out,
    
    // �����������
    output overflow
    );
    
    /*
        ����ѡ��
            func_choice == 0000 : �з��żӷ�
            func_choice == 0001 : �з��ż���
            func_choice == 0010 : �з���С������
            func_choice == 0011 : ������      A & B
            func_choice == 0100 : ƴ������    { B, A }
            func_choice == 0101 : �������    ~(A | B)
            func_choice == 0110 : ������      A | B
            func_choice == 0111 : �������    A ^ B
            func_choice == 1000 : �߼�����    B << A
            func_choice == 1001 : ��������    B >>> A
            func_choice == 1010 : �߼�����    B >> A
            func_choice == 1011 : �޷���С������
            func_choice == 1100 : �޷��żӷ�
            func_choice == 1101 : �޷��ż���
    */
    
    wire [31: 0] temp = sourceA - sourceB;
    wire [31: 0] sra_step_1;
    wire [31: 0] sra_step_2;
    wire [31: 0] ADD = sourceA + sourceB;
    wire [31: 0] SUB = sourceA - sourceB;
    wire [31: 0] SLT = ( sourceA[31] & (~sourceB[31]) )               ? 32'b1 :
                        ( sourceA[31] & sourceB[31] & temp[31] )       ? 32'b1 :
                        ( (~sourceA[31]) & (~sourceB[31]) & temp[31] ) ? 32'b1 :
                       32'b0;
    wire [31: 0] AND     = sourceA & sourceB;
    wire [31: 0] COMBINE = { sourceB[15:0], sourceA[15:0] };
    wire [31: 0] NOR     = ~(sourceA | sourceB);
    wire [31: 0] OR      = sourceA | sourceB;
    wire [31: 0] XOR     = sourceA ^ sourceB;
    wire [31: 0] SLL     = sourceB << sourceA;
    wire [31: 0] SRA; 
    wire [31: 0] SRL     = sourceB >> sourceA;
    wire [31: 0] SLTU    = ( sourceA < sourceB ) ? 32'b1 : 32'b0;
    
    assign sra_step_1 = { 32{ sourceA[1:0] == 2'b00 } } &   sourceB |
                        { 32{ sourceA[1:0] == 2'b01 } } & { sourceB[31]       , sourceB[31: 1] } |
                        { 32{ sourceA[1:0] == 2'b10 } } & { { 2{sourceB[31]} }, sourceB[31: 2] } |
                        { 32{ sourceA[1:0] == 2'b11 } } & { { 3{sourceB[31]} }, sourceB[31: 3] };
                        
    assign sra_step_2 = { 32{ sourceA[3:2] == 2'b00 } } &   sra_step_1 |
                        { 32{ sourceA[3:2] == 2'b01 } } & { { 4{sra_step_1[31]}  }, sra_step_1[31: 4] } |
                        { 32{ sourceA[3:2] == 2'b10 } } & { { 8{sra_step_1[31]}  }, sra_step_1[31: 8] } |
                        { 32{ sourceA[3:2] == 2'b11 } } & { { 12{sra_step_1[31]} }, sra_step_1[31:12] };
                        
    assign SRA = sourceA[4] ? { { 16{sra_step_2[31]} }, sra_step_2[31:16] } : sra_step_2;
    
    assign alu_out = ( func_choice == 4'b0000 ) ? ADD     :
                     ( func_choice == 4'b0001 ) ? SUB     :
                     ( func_choice == 4'b0010 ) ? SLT     :
                     ( func_choice == 4'b0011 ) ? AND     :
                     ( func_choice == 4'b0100 ) ? COMBINE :
                     ( func_choice == 4'b0101 ) ? NOR     :
                     ( func_choice == 4'b0110 ) ? OR      :
                     ( func_choice == 4'b0111 ) ? XOR     :
                     ( func_choice == 4'b1000 ) ? SLL     :
                     ( func_choice == 4'b1001 ) ? SRA     :
                     ( func_choice == 4'b1010 ) ? SRL     :
                     ( func_choice == 4'b1011 ) ? SLTU    :
                     ( func_choice == 4'b1100 ) ? ADD     :
                     ( func_choice == 4'b1101 ) ? SUB     :
                     32'b0 ;
     
     assign overflow = ( (func_choice == 4'b0000)     & 
                         (sourceA[31] == sourceB[31]) &
                         (sourceA[31] != alu_out[31]) ) ? 1'b1 :
                       ( (func_choice == 4'b0001)     &
                         (sourceA[31] != sourceB[31]) &
                         (sourceA[31] != alu_out[31]) ) ? 1'b1 :
                        1'b0;
    
endmodule
