`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ZhangJingtang
// 
// Create Date: 2017/06/18 19:01:00
// Design Name: 
// Module Name: MEM_WB_REG
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


module MEM_WB_REG(
    input  clk,
    input  reset,
    input  cancel,
    
    input  MEM_over,
    input  WB_allow_in,
    
    input      [127:  0] MEM_OUT,
    output reg [127:  0] WB_IN,
    
    input      [6  :  0] MEM_OUT_EXC,
    /*
        [6] PCȡָ��
        [5] Load��ַ��
        [4] Store��ַ��
        [3] syscall
        [2] break
        [1] ����ָ������
        [0] overflow
    */
    output reg [7  :  0] WB_IN_EXC,
    /*
        [7] BD default : 0
        [6] PCȡָ��
        [5] Load��ַ��
        [4] Store��ַ��
        [3] syscall
        [2] break
        [1] ����ָ������
        [0] overflow
    */
    input MEM_OUT_DELAY,
    
    input if_addr_ok
    );
    
    /*
        [31:0] IR@W
        [31:0] PC4@W
        [31:0] AO@W
        [31:0] lo_result@W
        ��128bit
    */
    
    initial
    begin
        WB_IN     <= 128'b0;
        WB_IN_EXC <= 8'b0;
    end
    
    always @(posedge clk)
    begin
        if ( (cancel & if_addr_ok) | reset )
        begin
            /*
                �Ĵ������㣺
                    1����λ reset
                    2���쳣 cancel
            */
            WB_IN     <= 128'b0;
            WB_IN_EXC <= 8'b0;
        end
        else if ( MEM_over & WB_allow_in )
        begin
            /*
                ���¼Ĵ�����
                    MEM�׶�����ɣ�WB�׶��������
                    ����WB�׶�һֱ������룬���ֻҪMEM�׶���ɼ��ɸ���
            */
            WB_IN     <=   MEM_OUT;
            WB_IN_EXC <= { MEM_OUT_DELAY, MEM_OUT_EXC };
        end
            /*
                ����WB�׶�һ��������һ�������
                ��MEM�׶λ�δ��ɣ���Ĵ��������㣨���ֲ��䣩
                ����Ϊ֮ǰ�׶��ṩ��Ҫ��ת��
                ��������㣬��֮ǰ�׶ε�ָ��޷��õ����º��ֵ��
                
                ����������Ĵ����е�ֵ���ֲ���
            */
    end
    
endmodule
