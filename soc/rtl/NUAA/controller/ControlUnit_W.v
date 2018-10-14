`timescale 1ns / 1ps
`define rd 15 : 11
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: �ڻ�
// 
// Create Date: 2017/06/19 23:21:00
// Design Name: 
// Module Name: ControlUnit_W
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


module ControlUnit_W(
    input [31:0] inst_W ,
    //����W�׶�ָ��
/*����Ĵ���*/
    input [7:0] exception_reg ,    
/*ת����������*/
    output [2:0] forward_bus_W ,
/*WB�׶εĿ�������*/
    output [29:0] WB_control_bus ,
/*cancel�ź�*/
    output cancel
    );
    //ȡָ�������
        wire [5:0] op ;
        wire [4:0] sa ;
        wire [5:0] funct ;
        wire [4:0] rs ;
        wire [4:0] rt ;
        wire [4:0] rd ;
        assign op = inst_W[31:26] ;
        assign sa = inst_W[10:6] ;
        assign funct = inst_W[5:0] ;
        assign rs = inst_W[25:21] ;
        assign rt = inst_W[20:16] ;
        assign rd = inst_W[15:11] ;
        //ʵ��ָ���б�
        wire inst_ADD , inst_ADDI , inst_ADDU , inst_ADDIU , inst_SUB , inst_SUBU ;
        wire inst_SLT , inst_SLTI , inst_SLTU , inst_SLTIU ;
        wire inst_DIV , inst_DIVU , inst_MULT , inst_MULTU ;
        wire inst_AND , inst_ANDI , inst_LUI , inst_NOR , inst_OR , inst_ORI , inst_XOR , inst_XORI ;
        wire inst_SLLV ,inst_SLL , inst_SRAV , inst_SRA , inst_SRLV , inst_SRL ;
        wire inst_BEQ , inst_BNE , inst_BGEZ , inst_BGTZ , inst_BLEZ , inst_BLTZ , inst_BGEZAL , inst_BLTZAL ;
        wire inst_J , inst_JAL , inst_JR , inst_JALR ;
        wire inst_MFHI , inst_MFLO , inst_MTHI , inst_MTLO ;
        wire inst_BREAK , inst_SYSCALL ;
        wire inst_LB , inst_LBU , inst_LH , inst_LHU , inst_LW , inst_SB , inst_SH ,inst_SW ;
        wire inst_ERET , inst_MFC0 , inst_MTC0 ;
        wire op_zero; // ������ȫ 0
        wire sa_zero; // sa ��ȫ 0
        assign op_zero = ~(|op);
        assign sa_zero = ~(|sa); 
        assign inst_ADD = op_zero & sa_zero & (funct == 6'b100000);//�з��żӷ�������������⣩
        assign inst_ADDI = (op == 6'b001000);//�з����������ӷ�������������⣩
        assign inst_ADDU = op_zero & sa_zero & (funct == 6'b100001);//�޷��żӷ�
        assign inst_ADDIU = (op == 6'b001001);//�޷����������ӷ�
        assign inst_SUB = op_zero & sa_zero & (funct == 6'b100010);//�з��ż���������������⣩
        assign inst_SUBU = op_zero & sa_zero & (funct == 6'b100011);//�޷��ż���
        assign inst_SLT = op_zero & sa_zero & (funct == 6'b101010);//С������λ
        assign inst_SLTI = (op == 6'b001010);//������С����λ
        assign inst_SLTU = op_zero & sa_zero & (funct == 6'b101011);//�޷���С����
        assign inst_SLTIU = (op == 6'b001011);//�������޷���С����λ
        assign inst_DIV = op_zero & sa_zero & (funct == 6'b011010) & (rd == 5'b0);//�з��ų���
        assign inst_DIVU = op_zero & sa_zero & (funct == 6'b011011) & (rd == 5'b0);//�޷��ų���
        assign inst_MULT = op_zero & sa_zero & (funct == 6'b011000) & (rd == 5'b0);//�з��ų˷�
        assign inst_MULTU = op_zero & sa_zero & (funct == 6'b011001) & (rd == 5'b0);//�޷��ų˷�
        assign inst_AND = op_zero & sa_zero & (funct == 6'b100100);//������
        assign inst_ANDI = (op == 6'b001100);//�������߼���
        assign inst_LUI = (op == 6'b001111) & (rs==5'd0);//������װ�ظ߰��ֽ� 
        assign inst_NOR = op_zero & sa_zero & (funct == 6'b100111);//�������
        assign inst_OR = op_zero & sa_zero & (funct == 6'b100101);//������
        assign inst_ORI = (op == 6'b001101);//�������߼���
        assign inst_XOR = op_zero & sa_zero & (funct == 6'b100110);//�������
        assign inst_XORI = (op == 6'b001110);//���������߼����
        assign inst_SLL = op_zero & (rs==5'd0) & (funct == 6'b000000);//�߼�����
        assign inst_SLLV = op_zero & sa_zero & (funct == 6'b000100);//�����߼�����
        assign inst_SRA = op_zero & (rs==5'd0) & (funct == 6'b000011);//��������
        assign inst_SRAV = op_zero & sa_zero & (funct == 6'b000111);//������������
        assign inst_SRL = op_zero & (rs==5'd0) & (funct == 6'b000010);//�߼�����
        assign inst_SRLV = op_zero & sa_zero & (funct == 6'b000110);//�����߼�����
        assign inst_BEQ = (op == 6'b000100); //�ж������ת
        assign inst_BNE = (op == 6'b000101); //�жϲ�����ת
        assign inst_BGEZ = (op == 6'b000001) & (rt==5'd1);//���ڵ��� 0 ��ת
        assign inst_BGTZ = (op == 6'b000111) & (rt==5'd0);//���� 0 ��ת
        assign inst_BLEZ = (op == 6'b000110) & (rt==5'd0);//С�ڵ��� 0 ��ת
        assign inst_BLTZ = (op == 6'b000001) & (rt==5'd0);//С�� 0 ��ת
        assign inst_BGEZAL = (op == 6'b000001) & (rt == 5'b10001);//���ڵ���0��ת�����ұ���PC+8
        assign inst_BLTZAL = (op == 6'b000001) & (rt == 5'b10000);//С��0��ת�����ұ���PC+8
        assign inst_J = (op == 6'b000010);//��������ת
        assign inst_JAL = (op == 6'b000011);//��������ת��������PC+8
        assign inst_JALR = op_zero & (rt==5'd0) & (rd==5'd31)
         & sa_zero & (funct == 6'b001001); //��ת�Ĵ���������
        assign inst_JR = op_zero & (rt==5'd0) & (rd==5'd0 )
         & sa_zero & (funct == 6'b001000); //��ת�Ĵ���
        assign inst_MFLO = op_zero & (rs==5'd0) & (rt==5'd0)
         & sa_zero & (funct == 6'b010010); //�� LO ��ȡ
        assign inst_MFHI = op_zero & (rs==5'd0) & (rt==5'd0)
         & sa_zero & (funct == 6'b010000); //�� HI ��ȡ
        assign inst_MTLO = op_zero & (rt==5'd0) & (rd==5'd0)
         & sa_zero & (funct == 6'b010011); //�� LO д����
        assign inst_MTHI = op_zero & (rt==5'd0) & (rd==5'd0)
         & sa_zero & (funct == 6'b010001); //�� HI д����
        assign inst_BREAK = (op == 6'b000000) & (funct == 6'b001101);//ϵͳ���ݣ��ϵ����⣩
        assign inst_SYSCALL = (op == 6'b000000) & (funct == 6'b001100);//SYSCALL��ϵͳ�������⣩
        assign inst_LB = (op == 6'b100000); //load �ֽڣ�������չ��
        assign inst_LBU = (op == 6'b100100); //load �ֽڣ��޷�����չ��
        assign inst_LH = (op == 6'b100001);//load���֣���ַ�����⣩
        assign inst_LHU = (op == 6'b100101);//load���֣�0��չ������ַ�����⣩
        assign inst_LW = (op == 6'b100011); //���ڴ�װ���֣���ַ�����⣩
        assign inst_SB = (op == 6'b101000); //���ڴ�洢�ֽ�
        assign inst_SH = (op == 6'b101001);//���ڴ�洢���֣���ַ�����⣩
        assign inst_SW = (op == 6'b101011); //���ڴ�洢�֣���ַ�����⣩
        assign inst_ERET = (op == 6'b010000) & (rs == 5'b10000) & (rt == 5'b0) & (rd == 5'b0) & sa_zero & (funct == 6'b011000);//ERET
        assign inst_MFC0 = (op == 6'b010000) & (rs == 5'b0) & sa_zero & (funct[5:3] == 3'b0);//��CP0ȡֵ
        assign inst_MTC0 = (op == 6'b010000) & (rs == 5'b00100) & sa_zero & (funct[5:3] == 3'b0);//��CP0��ֵ 
        //ָ�����
        wire cal_r ;//R��������ָ��
        wire cal_i ;//I��������ָ�
        wire br_rs_al ;//��ת�����ӣ�rs 31��
        wire jal_al ;//��������ת������(31)
        wire jalr_rs_al ;//��������ת������(rs 31)
        wire mfhi , mflo , mfc0  ;//����ת��ָ��
        wire load , store ;  //�ô�ָ��
        assign cal_r = inst_ADD | inst_ADDU | inst_SUB | inst_SUBU | inst_SLT | inst_SLTU | inst_AND | inst_NOR | inst_OR | inst_XOR | inst_SLLV
                     | inst_SLL | inst_SRAV | inst_SRA | inst_SRLV | inst_SRL ;
        assign cal_i = inst_ADDI | inst_ADDIU | inst_SLTI | inst_SLTIU | inst_ANDI | inst_ANDI | inst_LUI | inst_ORI | inst_XORI ;
        assign br_rs_al = inst_BGEZAL | inst_BLTZAL ;
        assign jal_al = inst_JAL ;
        assign jalr_rs_al = inst_JALR ;
        assign mfhi = inst_MFHI ;
        assign mflo = inst_MFLO ;
        assign mfc0 = inst_MFC0 ;
        assign load = inst_LB | inst_LBU | inst_LH | inst_LHU | inst_LW ;
        assign store = inst_SB | inst_SH | inst_SW ;    
               
/*������begin*/ 
        //���������ź�
        wire BD ;//��֧�ӳٲ�ָ�������ź�
        wire  AdEL_PC ,AdEL_LD  , AdES , Sys , Bp , Rl ,Ov ,Exception_All;
        assign BD = exception_reg[7] ;
        assign AdEL_PC = exception_reg[6] ; // ȡָ��ַ������߽�����
        assign AdEL_LD = exception_reg[5] ; // ȡָ��ַ������߽�����
        assign AdES = exception_reg[4] & (inst_SH | inst_SW);
        assign Sys = exception_reg[3] ;
        assign Bp = exception_reg[2] ;
        assign Rl = exception_reg[1] ;
        assign Ov = exception_reg[0] & (inst_ADD | inst_ADDI | inst_SUB ) ;
        assign Exception_All = AdEL_PC | AdEL_LD | AdES | Sys | Bp | Rl | Ov ;
/*������end*/   
/*cancel�ź�*/
        assign cancel = Exception_All | inst_ERET ;

/*ת������begin*/
        wire forward_rd_W , forward_rt_W , forward_31_W ;
        assign forward_rd_W = cal_r | mfhi | mflo ;
        assign forward_rt_W = cal_i | load | mfc0 ;
        assign forward_31_W = br_rs_al | jal_al | jalr_rs_al ;
        assign forward_bus_W = {forward_rd_W , forward_rt_W , forward_31_W };
/*ת������end*/

/*WB�׶ο�������begin*/
        //д�����ݵ���չ
        wire [2:0] func_choice_ext_W ;
        assign func_choice_ext_W = inst_LB ? 3'b000 :
                                   inst_LBU ? 3'b001 :
                                   inst_LH ? 3'b010 :
                                   inst_LHU ? 3'b011 : 3'b100 ;
        //HI LO �Ĵ���дʹ��                                   
        wire hi_wden , lo_wden ;
        assign hi_wden = inst_DIV | inst_DIVU | inst_MULT | inst_MULTU | inst_MTHI ? 1'b1 : 1'b0 ;
        assign lo_wden = inst_DIV | inst_DIVU | inst_MULT | inst_MULTU | inst_MTLO ? 1'b1 : 1'b0 ;
        //LO�Ĵ������ѡ���ź�
        wire LOSel ;
        assign LOSel = inst_DIV | inst_DIVU | inst_MULT | inst_MULTU ? 1'b1 : 1'b0 ;
        //д�ؼĴ���A3���ѡ���ź�
        wire [1:0] RFA3Sel ;
        assign RFA3Sel = inst_ADD | inst_ADDU | inst_SUB | inst_SUBU | inst_SLT | inst_SLTU | inst_AND | inst_NOR | inst_OR | inst_XOR 
                        | inst_SLLV | inst_SLL | inst_SRAV | inst_SRA | inst_SRLV | inst_SRL | inst_MFHI | inst_MFLO ? 2'b00 :
                        inst_BGEZAL | inst_BLTZAL | inst_JAL | inst_JALR ? 2'b10 : 2'b01 ;
        //д�ؼĴ���дʹ��
        wire WrRegWden ;
        assign WrRegWden = inst_DIV | inst_DIVU | inst_MULT | inst_MULTU | inst_BEQ | inst_BNE | inst_BGEZ | inst_BGTZ | inst_BLEZ | inst_BLTZ 
                           | inst_J | inst_JR | inst_MTHI | inst_MTLO | inst_BREAK | inst_SYSCALL | inst_SB | inst_SH | inst_SW 
                           | inst_ERET | inst_MTC0 ? 1'b0 : 1'b1 ;
        // д�ؼĴ�������ѡ���ź�
        wire [2:0] RFWDSel ;
        assign RFWDSel = inst_BGEZAL | inst_BLTZAL | inst_JAL | inst_JALR ? 3'b001 :
                         inst_MFHI ? 3'b010 :
                         inst_MFLO ? 3'b011 :
                         inst_LB | inst_LBU | inst_LH | inst_LHU | inst_LW ? 3'b100 :
                         inst_MFC0 ? 3'b101 : 3'b000 ;
        // CP0���ѡ���ź�
        wire CP0DSel ;
        assign CP0DSel = inst_MTC0 ? 1'b1 : 1'b0 ;
        //CP0����ѡ���ź�
        wire [1:0] CP0OSel ;
        assign CP0OSel =  inst_W[`rd] == 5'b01000 ? 2'b11 :
                          inst_W[`rd] == 5'b01100 ? 2'b01 :
                          inst_W[`rd] == 5'b01101 ? 2'b10 :
                          (inst_W[`rd] == 5'b01110 | inst_ERET) ? 2'b00 :
                          2'b11 ;
        //WB�׶�PCѡ���ź�                   
        wire pc_choice_W ;
        assign pc_choice_W = inst_ERET ? 1'b1 : 1'b0 ;
        //CP0ÿ���Ĵ�����ʹ���ź� 
        wire cp0_choice ;  
        wire badaddr_wden ;//���ַдʹ�ܣ�ֻ����
        wire badaddr_choice ;
        wire Status_wden ;//status�Ĵ���ȫ��дʹ�ܣ�����ɶ�д��
        wire Status_EXL_wden ;//status�Ĵ���EXLλӲ��дʹ��
        wire Status_EXL_choice ;
        //wire Status_IE_wden ;//status�Ĵ���IEλӲ��дʹ��
        wire Cause_BD_wden ;
        wire Cause_BD_choice ;
        wire Cause_IP_10_wden ;
        wire Cause_ExcCode_wden ;
        wire [2:0] Cause_ExcCode_choice ;
        wire Epc_wden ;
        
        assign cp0_choice = Exception_All ? 1'b1 : 1'b0 ;
        assign badaddr_wden = AdEL_PC | AdEL_LD | AdES ;
        assign badaddr_choice = AdEL_LD | AdES ? 1'b1 : 1'b0 ;
        assign Status_wden = inst_MTC0 & inst_W[`rd] == 5'b01100 ;
        assign Status_EXL_choice = Exception_All ? 1'b1 : 1'b0 ; //����ѡ��������⼶
        assign Status_EXL_wden = Exception_All | inst_ERET ;
        assign Cause_BD_wden = Exception_All ;
        //assign Status_IE_wden = interrupt ;//�ж�
        assign Cause_BD_choice = BD & Exception_All ? 1'b1 : 1'b0 ;
        assign Cause_IP_10_wden = inst_MTC0 & inst_W[`rd] == 5'b01101 ;
        assign Cause_ExcCode_wden = Exception_All ;
        assign Cause_ExcCode_choice = AdEL_PC | AdEL_LD ? 3'b001 :
                                      AdES ? 3'b010 :
                                      Sys ? 3'b011 :
                                      Bp ? 3'b100 :
                                      Rl ? 3'b101 :
                                      Ov ? 3'b110 : 3'b111 ;
        assign Epc_wden = inst_MTC0 & inst_W[`rd] == 5'b01110 | Exception_All ;
/*WB�׶�ͨ·��������*/       
        assign WB_control_bus = {pc_choice_W , cp0_choice , badaddr_wden ,badaddr_choice ,Status_wden , Status_EXL_choice ,Status_EXL_wden ,Cause_BD_wden ,
                                  Cause_BD_choice ,Cause_IP_10_wden ,Cause_ExcCode_wden , Cause_ExcCode_choice[2:0] , Epc_wden ,
                                  lo_wden ,hi_wden , RFWDSel[2:0] , CP0OSel[1:0] , CP0DSel , RFA3Sel[1:0] , LOSel ,func_choice_ext_W[2:0] ,
                                  WrRegWden };
/*WB�׶ο�������end*/

endmodule
