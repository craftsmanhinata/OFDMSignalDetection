function [BB_AR, Carrynum_B ] = solve_carrynum_rate( signal,fc,fs,snr,N )
%**************************************************************************
%���ܣ����ô���ķ�ʽ�����ز���Ŀ
%signal�������ź�
%fc����Ƶ
%fs������Ƶ��
%snr�������
%N�����Ÿ���
%**************************************************************************
for i = 1:length(snr)
 [BB_W(i),BB_AR(i)] = PSD_OFDM(signal,fc,fs,snr(i),0);  %��⹦����(25db)
 sig_22 = awgn(signal,snr(i),'measured');
 [Txu(i)] = overfind_num(sig_22,length(sig_22)/N,N,5);
 Vu(i)= Txu(i)*(1/fs);
 Carrynum_B(i) =round(BB_AR(i)*Vu(i));
end
%carrynum_rate =abs(round(Carrynum_B)-128)/128;
figure
plot(snr,Carrynum_B,'b-o');
hold on
plot([snr(1) snr(end)],[128 128],'k');
 legend('����ֵ','����ֵ');
xlabel('snr/db');
ylabel('���ز���Ŀ');
title('���ز���Ŀ����ֵ');