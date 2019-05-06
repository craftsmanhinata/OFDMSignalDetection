function [ B_rate_welch,B_rate_ar ] = Bandwidth_rate(sig1_chnl,fc,fs, snr)
%**************************************************************************
%���ܣ���ͬ�ŵ����´�����Ƶ�����
%sig1_chnl:�����ź�
%fc:�ز�Ƶ��
%fs:�ŵ�����Ƶ��
%snr:�����
%B_rate_welch:Welch�㷨�´������׼ȷ��
%B_rate_ar��ARģ���´�����Ƶ�׼ȷ��
%**************************************************************************
 
 B_ideal = 8e6;  %OFDM�źŴ��������ֵ
 numb = 10; %���ؿ������Ĵ���
 LL = length(snr);
 B_welch = zeros(1,LL);
 B_ar = zeros(1,LL);
 for i=1:LL
     for j=1:numb
         [b_welch(i,j),b_ar(i,j)]=PSD_OFDM(sig1_chnl,fc,fs,snr(i),0);
     end
     B_welch(i)=sum(b_welch(i,:))/numb;
     B_ar(i)=sum(b_ar(i,:))/numb;
     B_rate_welch(i)=1-abs((B_welch(i)-B_ideal))/B_ideal;
     B_rate_ar(i)=1-abs((B_ar(i)-B_ideal))/B_ideal;
 end
 
figure
plot(snr,B_rate_welch,'b-o');
hold on
plot(snr,B_rate_ar,'k-*');
legend('welch','AR');
grid on;
xlabel('snr/db')
ylabel('percentage/%');
title('�����������');
