function qpsk= QPSK()
%------------------ ��ʼ�� --------------------
chip=randi([0,1],1,32);
fc = 10e6;          %�ز�Ƶ��
fs = 40e6;          %����Ƶ��
L=200;             % ÿ��Ԫ�Ĳ�������,����ʱ����
M=length(chip);    % ��Ԫ��
N=M*L;             % ��������
Rb=200000;            % ������Ԫ����Ϣ����:2Mbps
Tb=1/Rb;           % ��Ԫ���:0.5us
dt=Tb/L;           % ������� 
T=N*dt;            % �ض�ʱ��
N_samples=T*fs;    %ÿ�����ڵĲ�������
dt = 1/fs;
t = 0:dt:T-dt;

for n=1:length(chip)
    if chip(n)==1
        ak(n)=+1;
    elseif chip(n)==0;
        ak(n)=-1;
    end
end
            
% �����仯����reshape��������
IQ=reshape(ak,2,length(ak)/2);
I=IQ(1,:);   
Q=IQ(2,:);

Isig=[];
Qsig=[];
for ii=1:length(IQ)
    if I(ii)==1;
        if Q(ii)==1;
           Isig(ii)=1;
           Qsig(ii)=-1;
        else Isig(ii)=-1;
             Qsig(ii)=-1;
        end
    else
        if Q(ii)==1;
           Isig(ii)=-1;
           Qsig(ii)=1;
        else Isig(ii)=1;
             Qsig(ii)=1;
        end
    end
end


I=Isig;
Q=Qsig;          
I=[I;I];
I=reshape(I,1,2*length(I));
% I=[1,I];   %��ʱһ��ʱ�䵥λ��ͼ���Ƕ�Q·��ʱ��ӦI�ĵ�һ����Q�ĵڶ���ӣ����ڱ���з�ӳ�ľ�������

Q=[Q;Q];
Q=reshape(Q,1,2*length(Q));

%����Ԫת����Ԫʱ����������p;
It=[];Qt=[];                 %Q,I��·�źŵ�ʱ�����У�
%��Ԫ�����һ����ֱ���ӵ���ʹ��I,Q��·�ź���Ԫ��һ����
m=min(length(I),length(Q));
for i=1:L
    It=[It;I];
    Qt=[Qt;Q];
end

It1=It(:);
It2=It1';
It=It2(1:m*L);
Qt1=Qt(:);
Qt2=Qt1';
Qt=Qt2(1:m*L);
c1=1;
s1=1;
c2=cos(2*pi*fc*t);
s2=sin(2*pi*fc*t);
%����·�źŽ��м�Ȩ����
Q_out1=Qt.*s1;      %��Ȩsin(pi*t/2Ts)����ź�
I_out1=It.*c1;      %��Ȩcos(pi*t/2Ts)����ź�
Q_out=Q_out1.*s2;%���I·�����ź�  
I_out=I_out1.*c2;%���Q·�����ź�
qpsk=I_out-1i*(Q_out);
