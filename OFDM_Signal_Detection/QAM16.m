function y = QAM16()
N=64; % ��Ԫ��
df=50; % Ƶ�ʷֱ���
M=16; % 16QAM����
x=randi([0,M-1],1,N);% ����������� (�ź�Դ)
%============= Use 16-QAM modulation=====================% QAM ����
% fc=10e6; % �ز�Ƶ��
% fs=40e6; % ����Ƶ��
% ts=1/fs; % �������

% t=[0:ts:N*df*ts]; % ʱ������

h = modem.qammod(M);
y = modulate(h,x);
y = repmat(y,df,1);
y = reshape(y,1,df*N);
P=std(y);           %��y�ı�׼��ÿ⺯������������mean��abs��������ͬ����׼���Ƿ���Ŀ���
y=y/P;              %P1��P��Ȼ��ͬ����һ���ǳ��Ա�׼����ǳ���ģ�ľ�ֵ,���ǳ���ƽ���͵Ŀ���

% c=exp(j*2*pi*fc.*t); % �ز��ź�
% y=y.*c(1:length(y));
