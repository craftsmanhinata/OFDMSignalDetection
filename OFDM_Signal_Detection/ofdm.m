function y2=ofdm(N,para,ratio)
%**************************************************************************
%���ܣ�ofdm�źŲ�������
%N:���Ÿ���
%para:���ز���Ŀ
%**************************************************************************

M = 16;   %16QAM����
Signal = randi([0,M-1],1,para*N);
QAM_out = modulate(modem.qammod(16),Signal);
x = reshape(QAM_out,para,N);       %����ת��
y = ifft(x);                        %�Ե��ƺ�����ݽ���ifft�任
y1 = [y(end-round(length(y(:,1))*ratio)+1:end,:);y];%����ѭ��ǰ׺����1/4
y2 = reshape(y1,1,(length(y1(:,1)))*N);   %����ת��
P = std(y2);
y2 = y2/P;


