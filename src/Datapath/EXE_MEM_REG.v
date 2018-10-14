`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ZhangJingtang
// 
// Create Date: 2017/06/18 18:33:28
// Design Name: 
// Module Name: EXE_MEM_REG
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


module EXE_MEM_REG(
    input  clk,
    input  reset,
    input  cancel,
    
    input  EXE_over,
    input  MEM_allow_in,
    
    input      [127:  0] EXE_OUT,
    output reg [127:  0] MEM_IN,
    
    input      [4  :  0] EXE_OUT_EXC,
    output reg [4  :  0] MEM_IN_EXC,
    /*
        [4] overflow
        [3] ����ָ��
        [2] break
        [1] syscall
        [0] PCȡָ��
    */
    input      EXE_OUT_DELAY,
    output reg MEM_IN_DELAY
    );
    
    /*
        [31:0] IR@M     ����ָ��
        [31:0] PC4@M    �ӳٲ�ָ��
        [31:0] AO@M     ALU��������˳�����32bit
        [31:0] RT@M     д��DM�����ݻ�˳�����32bit
        ��128bit
    */
    
    initial
    begin
        MEM_IN       <= 128'b0;
        MEM_IN_EXC   <= 5'b0;
        MEM_IN_DELAY <= 1'b0;
    end
    
    always @(posedge clk)
    begin
        if ( cancel | reset | (~EXE_over & MEM_allow_in) )
        begin
            /*
                �Ĵ������㣺
                    1����λ reset
                    2���쳣 cancel
                    3��EXE�׶�δ������MEM�׶��Ѿ��������
            */
            MEM_IN       <= 128'b0;
            MEM_IN_EXC   <= 5'b0;
            MEM_IN_DELAY <= 1'b0;
        end
        else if ( EXE_over & MEM_allow_in )
        begin
            /*
                ���¼Ĵ�����
                    EXE�׶��Ѿ���ɣ�MEM�׶��������
                    ���½׶������Լ������쳣��ʶλ
            */
            MEM_IN       <= EXE_OUT;
            MEM_IN_EXC   <= EXE_OUT_EXC;
            MEM_IN_DELAY <= EXE_OUT_DELAY;
        end
            /*
                ����������Ĵ����е�ֵ���ֲ���
            */
    end
    
endmodule
