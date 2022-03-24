module ddpohjs(clk,c,reset,directopen,out,led,led2,led3,ct,h,m,min,hour,ok,am,bcd,sec,cnt,si,pwmc,pwm,pwmout,wifi,wifi1,quality,full);
input clk,reset,directopen,ct,h,m,ok,wifi,wifi1,quality; //��J�ɯ߸���s�٦��}�� wifi K16 wifi1 L15: quakity h16;
output reg out,full;   //Pin:m11 
output reg [25:0] c=0; //���W
output reg led=0,led2=0,led3=0;   //Pin:c10 and e10 and c11
output reg [5:0] min=0,hour=0,sec=0; //�ɤ���]�w
output reg [3:0] am;	 //�C�q��ܾ�
output reg [7:0] bcd; //�C�q��ܾ�
output reg [15:0] pwmc,pwm;
output reg pwmout;
//�x����]�w begin
output reg [14:0] cnt; //����W
output reg si;         //��XPin:d11 ����:si
reg [14:0] Q2;		
//�x�����]�w end

// �ӧ����M�D Tsai Cheng-Hong.

//�D�{�� begin
always@(posedge clk)
c=c+1;
always@(posedge c[25])  //c25���ɭ� �C����44�� �~�t��+1��
begin
		if (reset || directopen==0 && ct==0 && wifi==0 && wifi1==0)  //���s�q���������q��
			begin
			out=0; //�q������
			led=0; //��O����
			led2=0;//���O����
			led3=0;//���O���� 
			min=0; //��
			hour=0;//��
			sec=0; //��

			end

 	if (directopen==0 && ct==0)
		begin
			min=0; //��
			hour=0;//��
			sec=0; //��
		end
		
	 if (wifi==1)
		begin
			out=1; //�q��}��
			led=1; //��O�}��
			led2=0;//��O����
			led3=0;//���O��
		end
		
	if (wifi1==1)
		begin
			out=0; //�q��}��
			led=0; //��O�}��
			led2=0;//���O����
			led3=0;//���O��
		end
		
	if (wifi1==1 && directopen==1)
		begin
			out=0; //�q��}��
			led=0; //��O�}��
			led2=0;//���O����
			led3=0;//���O��
		end
		
 else if (directopen) //�����Ұ�
			begin
			out=1; //�q��}��
			led=1; //��O�}��
			led2=0;//���O����
			led3=0;//���O��
			end
 else if (ct)   //�p��
			begin
				if (m)    //��
					begin
						if (min==59) 
							begin
							min=0; 	  	//����59���k�s 
							led=0;		//�]�w�ɺ�O�t
							led2=1;    	//�]�w�ɶ��O�G
							led3=0;		//]�w�ɬ��O�t
							out=0;		//�]�w�ɹq������
							end
						else
							begin
							min=min+1; 	//�p��59�ɫ����s���|+1����
							led=0;		//�]�w�ɺ�O�t
							led2=1;	  	//�]�w�ɶ��O�G
							led3=0;		//�]�w�ɬ��O�t
							out=0;		//�]�w�ɹq������
							end
					end
		 else if (h)    //��
					begin
						if (hour==23)
							begin
							hour=0;	  	//�ɨ�23���ks
							led=0;		//�]�w�ɺ�O�t
							led2=1;	  	//�]�w�ɶ��O�G
							led3=0;		//�]�w�ɬ��O�t
							out=0;		//�]�w�ɹq������
							end
						else
							begin
							hour=hour+1;//�p23�ɫ����s�|+1�p��
							led=0;		//�]�w�ɺ�O�t
							led2=1;		//�]�w�ɶ��O�G
							led3=0;		//�]�w�ɬ��Ot
							out=0;		//�]�w�ɹq������
							end
					end
		 else if (ok)   //�ɶ��]�w����
					begin
					
						if (sec==1 && hour==0 && min==0)  //�x���]�w �u���b�˼�1��ɥs
							begin
							cnt=19120;
							end
				 else 
							begin
							cnt=0;								 //��L�ɭԤ��s
							end
							
						if (min==0 && hour==0 && sec==0) //�ɤ���P��0���ɭ�
							begin
							led=0;		//��O�@�����O����
							led2=0;		//���O�@�����O����
							led3=0;		//�˼Ƨ�����O����
							out=0;		//�˼�q��
							min=0;		//���˼Ƨ�0
							hour=0;		//�ɭ˼Ƨ������0
							sec=0;		//��˼Ƨ������0
							end
							

				 else if (sec==0 && min==0 && hour!=0)	//��0 ���ɤ���0���ɭ�
							begin
							sec=44;		//��V���ɦ�
							min=59;		//���V�ɭɦ�
							hour=hour-1;//�ɦ]���ɦ�-1
							led=0;		//��O�@�����O����
							led2=0;		//���O�@�����O����
							led3=1;		//�˼Ʈɬ��OO�}�Ҫ�
							out=1;		//�˼Ʈɹq�����O�}�Ҫ�
							end
				else if (sec==0 && min!=0)	//��0 ������0���ɭ�
							begin
							sec=44;
							min=min-1;	//���V�ɭɦ�
							hour=hour;  //�ɦ]���ɦ�-1
							led=0;		//��O@�����O����
							led2=0;		//���O�@�����O����
							led3=1;		//�˼Ʈɬ��O���O�}�Ҫ�
							out=1;		//�˼Ʈ�q�����O�}�Ҫ�
							end		
				 else
							begin
							sec=sec-1;	//���������򰵤U��
							led=0;		//��O�@�����O����
							led2=0;		//���O�@�����O����
							led3=1;		//�˼Ʈɬ��O���O�}�Ҫ�
							out=1;		//�˼Ʈɹq�����O�}�Ҫ�
							end
						
					end
			end


end
//�D�{�� end

//pwm begin
always@(posedge clk)
	begin
	if (out==1)
		begin
		pwmc=pwmc+1;
			if (pwmc[15]==1)
				begin
				pwmc=0;
					if (pwmc<pwm)
						pwmout=1;
					else
						pwmout=0;
				end
		 if (reset)
full=0;
else	if (quality==1)
full=1;
else
full=0;
		 
		end
	end
	
always@(posedge pwmc[5])
	begin
		if (out==1)
			begin
			pwm=pwm+1;
				if (pwm[15]==1)
					pwm=0;
			end
	end
//pwm	end

/*always@(posedge clk)
begin
	if (reset)
	full=0;
else	if (quality==1)
		full=1;
	else
		full=0;
end
*/

//��4�ӤC�q���P�Ʀr begin
always@(c) 
begin
if(c[15]==0) am=4'b1110;
if(c[16]==0) am=4'b1101;
if(c[17]==0) am=4'b1011;
if(c[18]==0) am=4'b0111;
end
//��4�ӤC�q���P�Ʀr end

//�C�q���Ʀr�]�w begin
always@(c) 
begin
	if (am==4'b1110)
	begin
		if (min==0)  bcd=8'b00000011;
else	if (min==1)  bcd=8'b10011111; 
else	if (min==2)  bcd=8'b00100101; 
else	if (min==3)  bcd=8'b00001101; 
else	if (min==4)  bcd=8'b10011001; 
else	if (min==5)  bcd=8'b01001001; 
else	if (min==6)  bcd=8'b11000001; 
else	if (min==7)  bcd=8'b00011011; 
else	if (min==8)  bcd=8'b00000001; 
else	if (min==9)  bcd=8'b00001001; 

else	if (min==10)  bcd=8'b00000011;
else	if (min==11)  bcd=8'b10011111; 
else	if (min==12)  bcd=8'b00100101; 
else	if (min==13)  bcd=8'b00001101; 
else	if (min==14)  bcd=8'b10011001; 
else	if (min==15)  bcd=8'b01001001; 
else	if (min==16)  bcd=8'b11000001; 
else	if (min==17)  bcd=8'b00011011; 
else	if (min==18)  bcd=8'b00000001; 
else	if (min==19)  bcd=8'b00001001; 

else	if (min==20)  bcd=8'b00000011;
else	if (min==21)  bcd=8'b10011111; 
else	if (min==22)  bcd=8'b00100101; 
else	if (min==23)  bcd=8'b00001101; 
else	if (min==24)  bcd=8'b10011001; 
else	if (min==25)  bcd=8'b01001001; 
else	if (min==26)  bcd=8'b11000001; 
else	if (min==27)  bcd=8'b00011011; 
else	if (min==28)  bcd=8'b00000001; 
else	if (min==29)  bcd=8'b00001001; 

else	if (min==30)  bcd=8'b00000011;
else	if (min==31)  bcd=8'b10011111; 
else	if (min==32)  bcd=8'b00100101; 
else	if (min==33)  bcd=8'b00001101; 
else	if (min==34)  bcd=8'b10011001; 
else	if (min==35)  bcd=8'b01001001; 
else	if (min==36)  bcd=8'b11000001; 
else	if (min==37)  bcd=8'b00011011; 
else	if (min==38)  bcd=8'b00000001; 
else	if (min==39)  bcd=8'b00001001; 

else	if (min==40)  bcd=8'b00000011;
else	if (min==41)  bcd=8'b10011111; 
else	if (min==42)  bcd=8'b00100101; 
else	if (min==43)  bcd=8'b00001101; 
else	if (min==44)  bcd=8'b10011001; 
else	if (min==45)  bcd=8'b01001001; 
else	if (min==46)  bcd=8'b11000001; 
else	if (min==47)  bcd=8'b00011011; 
else	if (min==48)  bcd=8'b00000001; 
else	if (min==49)  bcd=8'b00001001; 

else	if (min==50)  bcd=8'b00000011;
else	if (min==51)  bcd=8'b10011111; 
else	if (min==52)  bcd=8'b00100101; 
else	if (min==53)  bcd=8'b00001101; 
else	if (min==54)  bcd=8'b10011001; 
else	if (min==55)  bcd=8'b01001001; 
else	if (min==56)  bcd=8'b11000001; 
else	if (min==57)  bcd=8'b00011011; 
else	if (min==58)  bcd=8'b00000001; 
else	if (min==59)  bcd=8'b00001001; 
else	if (min==60)  bcd=8'b00000011;
end

else if  (am==4'b1101)
begin
		if (min==0)  bcd=8'b00000011;
else	if (min==1)  bcd=8'b00000011;
else	if (min==2)  bcd=8'b00000011;
else	if (min==3)  bcd=8'b00000011;
else	if (min==4)  bcd=8'b00000011;
else	if (min==5)  bcd=8'b00000011;
else	if (min==6)  bcd=8'b00000011;
else	if (min==7)  bcd=8'b00000011;
else	if (min==8)  bcd=8'b00000011;
else	if (min==9)  bcd=8'b00000011;

else	if (min==10)  bcd=8'b10011111; 
else	if (min==11)  bcd=8'b10011111; 
else	if (min==12)  bcd=8'b10011111; 
else	if (min==13)  bcd=8'b10011111; 
else	if (min==14)  bcd=8'b10011111; 
else	if (min==15)  bcd=8'b10011111; 
else	if (min==16)  bcd=8'b10011111; 
else	if (min==17)  bcd=8'b10011111; 
else	if (min==18)  bcd=8'b10011111; 
else	if (min==19)  bcd=8'b10011111; 

else	if (min==20)  bcd=8'b00100101;
else	if (min==21)  bcd=8'b00100101;
else	if (min==22)  bcd=8'b00100101;
else	if (min==23)  bcd=8'b00100101;
else	if (min==24)  bcd=8'b00100101;
else	if (min==25)  bcd=8'b00100101;
else	if (min==26)  bcd=8'b00100101;
else	if (min==27)  bcd=8'b00100101;
else	if (min==28)  bcd=8'b00100101;
else	if (min==29)  bcd=8'b00100101; 

else	if (min==30)  bcd=8'b00001101;
else	if (min==31)  bcd=8'b00001101; 
else	if (min==32)  bcd=8'b00001101; 
else	if (min==33)  bcd=8'b00001101; 
else	if (min==34)  bcd=8'b00001101; 
else	if (min==35)  bcd=8'b00001101; 
else	if (min==36)  bcd=8'b00001101; 
else	if (min==37)  bcd=8'b00001101; 
else	if (min==38)  bcd=8'b00001101; 
else	if (min==39)  bcd=8'b00001101;
 
else	if (min==40)  bcd=8'b10011001; 
else	if (min==41)  bcd=8'b10011001; 
else	if (min==42)  bcd=8'b10011001;
else	if (min==43)  bcd=8'b10011001; 
else	if (min==44)  bcd=8'b10011001; 
else	if (min==45)  bcd=8'b10011001; 
else	if (min==46)  bcd=8'b10011001; 
else	if (min==47)  bcd=8'b10011001; 
else	if (min==48)  bcd=8'b10011001; 
else	if (min==49)  bcd=8'b10011001;

else	if (min==50)  bcd=8'b01001001; 
else	if (min==51)  bcd=8'b01001001; 
else	if (min==52)  bcd=8'b01001001; 
else	if (min==53)  bcd=8'b01001001; 
else	if (min==54)  bcd=8'b01001001; 
else	if (min==55)  bcd=8'b01001001; 
else	if (min==56)  bcd=8'b01001001; 
else	if (min==57)  bcd=8'b01001001; 
else	if (min==58)  bcd=8'b01001001; 
else	if (min==59)  bcd=8'b01001001;   
end
else	if (am==4'b1011)
	begin
		if (hour==0)  bcd=8'b00000011;
else	if (hour==1)  bcd=8'b10011111; 
else	if (hour==2)  bcd=8'b00100101; 
else	if (hour==3)  bcd=8'b00001101; 
else	if (hour==4)  bcd=8'b10011001; 
else	if (hour==5)  bcd=8'b01001001; 
else	if (hour==6)  bcd=8'b11000001; 
else	if (hour==7)  bcd=8'b00011011; 
else	if (hour==8)  bcd=8'b00000001; 
else	if (hour==9)  bcd=8'b00001001; 

else	if (hour==10)  bcd=8'b00000011;
else	if (hour==11)  bcd=8'b10011111; 
else	if (hour==12)  bcd=8'b00100101; 
else	if (hour==13)  bcd=8'b00001101; 
else	if (hour==14)  bcd=8'b10011001; 
else	if (hour==15)  bcd=8'b01001001; 
else	if (hour==16)  bcd=8'b11000001; 
else	if (hour==17)  bcd=8'b00011011; 
else	if (hour==18)  bcd=8'b00000001; 
else	if (hour==19)  bcd=8'b00001001; 

else	if (hour==20)  bcd=8'b00000011;
else	if (hour==21)  bcd=8'b10011111; 
else	if (hour==22)  bcd=8'b00100101; 
else	if (hour==23)  bcd=8'b00001101; 
else	if (hour==24)  bcd=8'b10011001; 

end

else if  (am==4'b0111)
begin
		if (hour==0)  bcd=8'b00000011;
else	if (hour==1)  bcd=8'b00000011;
else	if (hour==2)  bcd=8'b00000011;
else	if (hour==3)  bcd=8'b00000011;
else	if (hour==4)  bcd=8'b00000011;
else	if (hour==5)  bcd=8'b00000011;
else	if (hour==6)  bcd=8'b00000011;
else	if (hour==7)  bcd=8'b00000011;
else	if (hour==8)  bcd=8'b00000011;
else	if (hour==9)  bcd=8'b00000011;

else	if (hour==10)  bcd=8'b10011111; 
else	if (hour==11)  bcd=8'b10011111; 
else	if (hour==12)  bcd=8'b10011111; 
else	if (hour==13)  bcd=8'b10011111; 
else	if (hour==14)  bcd=8'b10011111; 
else	if (hour==15)  bcd=8'b10011111; 
else	if (hour==16)  bcd=8'b10011111; 
else	if (hour==17)  bcd=8'b10011111; 
else	if (hour==18)  bcd=8'b10011111; 
else	if (hour==19)  bcd=8'b10011111; 

else	if (hour==20)  bcd=8'b00100101;
else	if (hour==21)  bcd=8'b00100101;
else	if (hour==22)  bcd=8'b00100101;
else	if (hour==23)  bcd=8'b00100101;
else	if (hour==24)  bcd=8'b00100101;

end
end
//�C�q���Ʀr�]�wend

//�x�����n���]�w begin
always@(posedge clk)
if (reset||Q2==cnt)
	Q2=0;
else
Q2=Q2+1;

always@(sec)
if (cnt==19120 ||  cnt==17036)
si=Q2[14];
else
si=Q2[13];
//�x�����n���]�w end

endmodule


