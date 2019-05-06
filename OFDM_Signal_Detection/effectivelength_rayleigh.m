function [Tu,Ts,Tg ] = effectivelength_rayleigh(x,fs,snr,N,K,itau,power,fmax,itn)
%**************************************************************************
%���ܣ����źŵ���Ч���ݳ��Ⱥ��ܵ����ݳ���
%x:������ź�
%fc:�źŵ�Ƶ��
%fs:�źŵĲ���Ƶ��
%snr:�����
%N:�ź�ÿ֡�ķ�����
%**************************************************************************
 %sig_1= RayFade(itau,power,fmax,fs,x,snr);
 sig_1 = MUL_RAYLEIGH(x,itau,power,itn,length(itau),length(x),1/fs,fmax,0);
 sig_1 = awgn(sig_1,snr,'measured');
 L=length(sig_1);
 t=1/fs;
 P=(L/N);
 xcorr_len=1;    %����س���,��OFDM����Ϊ��λ
 [Tu,Ts]=auto_xcorr(sig_1,P, xcorr_len, N,t,K);           %�����ź������������
 Tg=Ts-Tu;   %ʹ�ù̶�ʱ�ӵ�fft���CP����
