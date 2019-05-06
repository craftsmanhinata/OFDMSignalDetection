function [Sig_8ASK] = ASK8()
%��������������
M=8;       %���� 8ASK
N=30;       %��Դ����������,Ϊ��֤����,ѡ����log2(M)��������
bit=randint(1,N,2); 
symbol=zeros(1,N/log2(M));
S = [0,1,2,3,4,5,6,7];
for i=1:length(symbol)
    symbol(i)=S(bit(i)*4+bit(i+1)*2+bit(i+2)+1);
end
%�����ز�
fc = 10e6;          %�ز�Ƶ��
fs = 40e6;          %����Ƶ��
L=20;               % ÿ��Ԫ�Ĳ�������,����ʱ����
M=length(symbol);     % ��Ԫ��
N=M*L;              % ��������
Rb=2e6;             % ������Ԫ����Ϣ����:2Mbps
Tb=1/Rb;            % ��Ԫ���:0.5us
dt=Tb/L;            % ������� 
T=N*dt;             % �ض�ʱ��
N_samples=T*fs;  %ÿ�����ڵĲ�������
dt = 1/fs;
t = 0:dt:T-dt;
carrier = cos(2*pi*fc.*t);
%���ɵ����ź�S(t)
r=zeros(1,length(carrier)*length(symbol));
for n1=1:length(symbol)
    r((N_samples*(n1-1)+1):(N_samples*(n1-1)+N_samples))=symbol(n1)*carrier;
end
% plot(r)
Sig_8ASK = awgn(r,SNR,'measured');
% end