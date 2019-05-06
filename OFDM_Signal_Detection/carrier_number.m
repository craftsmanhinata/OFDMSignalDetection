function [carry_num] = carrier_number(yc,N,snr,K)
%**************************************************************************
%����:���������������ز���Ŀ
%yc:�����ź�
%N:���Ÿ���
%snr:�����
%carry_num:���ز���Ŀ
%**************************************************************************

yd = awgn(yc,snr,'measured');
fff = 3; % ��������,���źŽ��й�����
y1 = yd(ones(fff,1),:); % ��Ԫ����
sig_2 = reshape(y1, 1, fff*length(y1));
%P=length(sig_2)/N;
P = length(yc)/N;
fft_num = 6000;       %fft����
Rx_c = zeros(length(sig_2),P);
data1 = [sig_2,zeros(1,P)];
 for i = 1 : length(sig_2)
    for tao = 1 :P
         Rx_c(i,tao) = Rx_c(i,tao) + data1(i)*conj(data1(tao+i));
    end
 end
RRR_c=ifft(Rx_c(:,1),fft_num);
if K==1
    figure
    stem(abs(RRR_c));
    xlabel('FFT����')
    ylabel('����')
    title('Rxx(n,1)��FFT');
end

Ln = fft_num/fff-100;   %��������������
ab1 = sort( abs(RRR_c(Ln+1:2*Ln)));    %����������
Z = length(ab1);
[a1 ,a2] = find(abs(RRR_c(Ln+1:2*Ln))==ab1(Z,1));%ȡ��ֵ�߶�Ϊ�ڶ��ߵķ�ֵ��Ӧ����

ab2 = sort( abs(RRR_c(2*Ln+1:3*Ln)));    %����������
Z = length(ab2);
[a3 ,a4] = find(abs(RRR_c(2*Ln+1:3*Ln))==ab2(Z,1));%ȡ��ֵ�߶�Ϊ�ڶ��ߵķ�ֵ��Ӧ����
interval = a3+Ln-a1;         %��ֵ���
q = fft_num/interval;     %��������

 Lp = length(sig_2)/N;   %����ر�������
[Tu_over] = overfind_num(sig_2,Lp,N,fff);
carry_num = Tu_over/q;