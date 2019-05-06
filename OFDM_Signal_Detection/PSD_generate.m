function [ sig_chnl ] = PSD_generate( N)
%���������׵�ofdm�ź�
%Nһ�����ṹ��OFDM�źŵĸ�����ÿ�η��͵�ofdm�źŵĸ���

para=128;%���ò��д�������ز�����,��Ч���ݳ���
M=16;
Signal=randi([0,M-1],1,para*N);
QAM_out=modulate(modem.qammod(16),Signal);
x=reshape(QAM_out,para,N);      %����ת��
L=length(x(:,1));
for i=1:N
      x1(:,i)  = [x( 1 : end / 2,i) ;zeros(4*L,1) ;x( end / 2 + 1 : end,i)];  %4��������
end

yy=ifft(x1);                         %�Ե��ƺ�����ݽ���ifft�任
yy1=[yy(end-round(length(yy)/4)+1:end,:);yy];%����ѭ��ǰ׺����1/4
yy1=[zeros(round(length(x1)/3),N);yy1; zeros(round(2*length(x1)/3),N)];  %ǰ�����
sig_chnl=reshape(yy1,1,(length(yy1))*N);
P0=std(sig_chnl);
sig_chnl=sig_chnl/P0;
