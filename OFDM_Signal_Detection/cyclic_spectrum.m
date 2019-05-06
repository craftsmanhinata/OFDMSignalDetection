function [ff] = cyclic_spectrum(x, N, fs, M,K)
%*******************************************************************
% ���ܣ�ƽ������ͼ����ѭ����
% x ���ź�
% N �� ѭ���׼��������ȣ�����С�ڵ����ź����г���
% fs �� ����Ƶ��, ������Ϊ-fs/2��fs/2
% M ��ƽ������, ʱ��ֱ���*Ƶ�ʷֱ���=M
%*******************************************************************
win = 'hamming'; % ƽ��������

d_alpha = fs/(N); % 1/ʱ��ֱ���=ѭ��Ƶ�ʷֱ���
alpha = -fs:d_alpha:fs; % ѭ��Ƶ��, �ֱ���=1/ʱ��ֱ���
a_len = length(alpha); % ѭ��Ƶ��ȡ������

f_len = floor(N/M-1)+1; % ���ƽ��������, ��Ƶ�ʲ�������
f = -(fs/2-d_alpha*floor(M/2)) + d_alpha*M*(0:f_len-1); % Ƶ�ʲ�����λ��

S = zeros(a_len, f_len); % ��ʼ��ع�����
i = 1; 

%%% �ź�fft�任 %%%
X = fftshift(fft(x(1:N))); 
X = X';

%%% ����ѭ��Ƶ��ȡֵ %%%
for alfa = alpha

    interval_f_N = round(abs(alfa)/d_alpha); % ѭ��Ƶ������Ӧ��Ƶ���������
    f_N = floor((N-interval_f_N-M)/M)+1; % ƽ�����ĸ���
    
    %%% ����ƽ�������� %%%
    %g = feval(win, M); 
    %window_M = g(:, ones(f_N,1));
    
    %%% Ƶ������ƽ��ģ�� %%%
    t = 1:M*f_N;
    t = reshape(t, M, f_N);
    
    %%% ����X1,X2 %%%
    %X1 = X(t).*window_M;
    %X2 = X(t+interval_f_N).*window_M; 
    X1 = X(t);
    X2 = X(t+interval_f_N); 
    %%% ��������� %%%
    St = conj(X1).*X2;
    St = mean(St, 1); % ƽ��ƽ��
    S(i, floor((f_len-f_N)/2)+(1:f_N)) = St/N; % �����ƽ�������������Ա���ͼ
    i = i+1;
    
end
%%% ����ѭ��Ƶ��ȡֵ���� %%%
 
%%% ѭ������ͼ %%%
if K==1
    figure;
    mesh(f, alpha, abs(S)); 
    axis tight;
    title('QAM-OFDM ѭ����');
    xlabel('f'); 
    ylabel('a');
end

normal_data=S(floor(length(S(:,1))/2)+1,:);
if K==1
    figure;
    plot(f,abs(normal_data))
    xlabel('Ƶ�� [Hz]');
    ylabel('S0(f)');
    title('OFDM����غ���a=0�Ķ�ά����');
    grid;
end
normal_data =interp(normal_data,100);
ff = interp(f,100);
%***********************************************
%��Ƶ����
%***********************************************
for i=1:length(normal_data)/2
  if(abs(normal_data(i)) ==max(abs(normal_data(1,1:length(normal_data)/2))))
      f1=abs(ff(i));
  end
end
for ii=length(normal_data)/2:length(normal_data)
  if(abs(normal_data(ii)) ==max(abs(normal_data(1,length(normal_data)/2:end))))
      f2=abs(ff(ii));
  end
end

ff=(f1+f2)/2;

[as2, as22]=Proximate(10e6,f);
data3=S(:,as2);
normal_data3=data3/max(data3);
 if K==1
    figure;
    plot(alpha,abs(normal_data3))
    xlabel('Ƶ�� [Hz]');
    ylabel('S0(f)');
    title('OFDM����غ���f=fc�Ķ�ά����');
    grid;
 end