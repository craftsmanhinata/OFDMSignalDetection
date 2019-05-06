function [rate_ofdm_R]=OFDM_rate_xiaobo_Ray(snr,N,para,ratio,itau,power,itn,fmax,fs)
%���ܣ�С���任����ȷʶ����
Me_R=0.0172;  %����ʶ���źŵ�����
num=2;     %100�����ؿ������
ofdm_R=zeros(1,length(snr));
rate_ofdm_R=zeros(1,length(snr));

for i=1:num
    [VAR_FSK8_R,VAR_QAM16_R,VAR_QAM64_R,VAR_QPSK_R,VAR_OFDM_R] = sc_ofdm_wavelet_Ray(N,snr,para,ratio,0,itau,power,itn,fmax,fs);
    
    for j=1:length(snr)
          if ((VAR_OFDM_R(j)>Me_R)&&(VAR_FSK8_R(j)<Me_R)&&(VAR_QAM16_R(j)<Me_R)&&(VAR_QAM64_R(j)<Me_R)...
                  &&(VAR_QPSK_R(j)<Me_R))
            ofdm_R(j)=ofdm_R(j)+1;
          end
    end
end

for j=1:length(snr)
   rate_ofdm_R(j)=ofdm_R(j)/num;
end
figure;
plot(snr,rate_ofdm_R,'k-x');
axis([snr(1) snr(end) 0.95 1.1]);
xlabel('snr/db');
ylabel('percentage/%');
title('128�����ز���OFDM�ź�ʶ����ȷ��(С���任����˥���ŵ�)');