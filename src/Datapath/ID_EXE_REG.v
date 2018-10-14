`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ZhangJingtang
// 
// Create Date: 2017/06/18 13:59:10
// Design Name: 
// Module Name: ID_EXE_REG
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


module ID_EXE_REG(
    input  clk,
    input  reset,
    input  cancel,
    
    input  ID_over,
    input  EXE_allow_in,
    
    // ID�׶��������
    input      [159:  0] ID_OUT,
    // EXE�׶���������
    output reg [159:  0] EXE_IN,
    
    input      [3  :  0] ID_OUT_EXC,
    output reg [3  :  0] EXE_IN_EXC,
    /*
        [3] ����ָ��
        [2] break
        [1] syscall
        [0] PCȡָ��
    */
    input      ID_OUT_DELAY,
    output reg EXE_IN_DELAY,
    
    input IF_over,
    input ID_allow_in
    );
    
    /*
        [31:0] IR@E     ����ָ��
        [31:0] PC4@E    �ӳٲ�ָ��
        [31:0] RS@E     ������1
        [31:0] RT@E     ������2
        [31:0] EXT@E    ��������չ
        ��160bit
    */
    
    initial
    begin
        EXE_IN       <= 160'b0;
        EXE_IN_EXC   <= 4'b0;
        EXE_IN_DELAY <= 1'b0;
    end
    
    always @(posedge clk)
    begin
        if ( cancel | reset | (~ID_over & EXE_allow_in) )
        begin
            /*
                �Ĵ������㣺
                    1����λ reset
                    2���쳣 cancel
                    3��ID�׶�δ������EXE�׶��Ѿ��������
            */
            EXE_IN       <= 160'b0;
            EXE_IN_EXC   <= 4'b0;
            EXE_IN_DELAY <= 1'b0;
        end
        else if ( ID_over & EXE_allow_in & ID_allow_in & IF_over )
        begin
            /*
                ���¼Ĵ�����
                    ID�׶���ɣ�EXE�׶��������
                    ���½׶������Լ��쳣��ʶλ
            */
            EXE_IN       <= ID_OUT;
            EXE_IN_EXC   <= ID_OUT_EXC;
            EXE_IN_DELAY <= ID_OUT_DELAY;
        end
        else if ( ID_over & EXE_allow_in )
        begin
            EXE_IN       <= 160'b0;
            EXE_IN_EXC   <= 4'b0;
            EXE_IN_DELAY <= 1'b0;
        end
            /*
                ����������Ĵ����е�ֵ���ֲ���
            */
    end
    
endmodule
