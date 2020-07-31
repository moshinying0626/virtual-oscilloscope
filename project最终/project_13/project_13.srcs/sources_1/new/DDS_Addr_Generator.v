`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/27 20:09:28
// Design Name: 
// Module Name: DDS_Addr_Generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DDS_Addr_Generator(
    input clk_DDS,              //系统时钟
    input Rst,                  //低电平复位
    input [13:0]Freq,           //频率
    input [8:0]Phase,           //相位
    output [7:0]Addr_Out        //输出地址，对应ROM中的数据
    );
    parameter NWORD=256;                 //源数据采样精度
    wire clk_out;                         //时钟        
    reg [7:0]Addr_Cnt=0;                  //地址计数    
    wire [7:0]PWORD = (Phase*NWORD)/360;  //相位控制字 (x/360)*256
    wire [30:0]FWORD = 100000000/(Freq*NWORD);//频率控制字
    //分频器
    Clk_Division_0 Clk_Division_01 (
      .clk_100MHz(clk_DDS),  // input wire clk_100MHz
      .clk_mode(FWORD),      // input wire [30 : 0] clk_mode
      .clk_out(clk_out)      // output wire clk_out
    );
    //计数
    always @ (posedge clk_out or negedge Rst)
        begin
            if (!Rst)
                Addr_Cnt <= 0;  
            else
                Addr_Cnt <= Addr_Cnt + 1;   
        end 
    //将累加器的地址的高八位赋值给输出的地址（ROM的地址
    assign Addr_Out = Addr_Cnt + PWORD;
endmodule
