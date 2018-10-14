`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ZhangJingtang
// 
// Create Date: 2017/06/14 23:03:13
// Design Name: 
// Module Name: IF_ID_REG
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

module IF_ID_REG(

    input               clk,
    input               reset,
    input               cancel,
    
    input               IF_over,
    input               ID_allow_in,
    
    input       [63: 0] IF_OUT,
    output reg [63: 0]  ID_IN,
    
    input               PC_EXC_IF,
    output reg         PC_EXC_ID,
    output reg         DELAY,
    input              jbr
    
    );
    
    /*
        [31:0] IR@D     ����ָ��
        [31:0] PC4@D    �ӳٲ�ָ��
        ��64bit
    */
    
    // ��ʼ��
    initial
    begin
        ID_IN     <= 64'b0;
        PC_EXC_ID <= 1'b0;
        DELAY     <= 1'b0;
    end

    always @(posedge clk)
    begin
        if (cancel | reset)
        begin
            /*
                �Ĵ������㣺
                    1���쳣 cancel
                    2����λ reset
            */
            ID_IN     <= 64'b0;
            PC_EXC_ID <= 1'b0;
            DELAY     <= 1'b0;
        end
        else if (ID_allow_in & IF_over & ~PC_EXC_IF & jbr)
        begin
            /*
                ���¼Ĵ�����
                    ID�׶�������룬�Ĵ����е�ǰָ��ΪJ��ָ���Branch��ָ��
                    �ҵ�ǰָ��������ת����,������ӳٲ۱��
                    ������ָ��PC��Ч
            */
            ID_IN     <= IF_OUT;
            PC_EXC_ID <= PC_EXC_IF;
            DELAY     <= 1'b1;
        end
        else if (ID_allow_in & IF_over & ~PC_EXC_IF)
        begin
            /*
                ���¼Ĵ�����
                    ID�׶�������룬����һ��ָ����ӳٲ�ָ��
                    ������ָ��PC��Ч
            */
            ID_IN     <= IF_OUT;
            PC_EXC_ID <= PC_EXC_IF;
            DELAY     <= 1'b0;
        end
        else if (IF_over & ID_allow_in & PC_EXC_IF)
        begin
            /*
                ���¼Ĵ����е�PC��ָ����0��PC�쳣λ��1��
                    IF�׶�ȡָ������ID�׶��������
                    PC��ַ���������ֱ߽�
            */
            ID_IN     <= {32'b0, IF_OUT[31:0]};
            PC_EXC_ID <= PC_EXC_IF;
            DELAY     <= 1'b0;
        end
            /*
                ����������Ĵ����е�ֵ���ֲ���
            */
    end
    
endmodule
