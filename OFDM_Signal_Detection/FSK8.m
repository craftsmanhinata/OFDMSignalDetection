function [Sig_MFSK] = FSK8()
%�㶨          
M=8;
Symbolrate=100;    %��������
nsamp=100;    %ÿ�����ŵĲ�������
fs=Symbolrate*nsamp;
len=3200;
%x=randint(1,len,M);             %ȡֵ��0-(M-1) �����������Ϊ��Ϣ���У������źŻ�������randsrc�������⺯�������Զ���Ԫ�ص�ֵ
x=randi([0,M-1],1,len);             %ȡֵ��0-(M-1) �����������Ϊ��Ϣ���У������źŻ�������randsrc�������⺯�������Զ���Ԫ�ص�ֵ
y=fskmod(x,M,Symbolrate,nsamp,fs);   %8fsk�����ź�
% fc=10e6;
% fs=40e6;
% %y=real(y.*exp(j*2*pi*fc/fs*(0:length(y)-1)));
% y=(y.*exp(j*2*pi*fc/fs*(0:length(y)-1)));
Sig_MFSK=y(1:len);


