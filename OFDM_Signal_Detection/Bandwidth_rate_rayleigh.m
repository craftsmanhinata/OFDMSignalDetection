function [ B_rate_welch,B_rate_ar ] = Bandwidth_rate_rayleigh(sig1_chnl,fc,fs, snr,itau,power,fmax,itn)
 %��ͬ�ŵ����´�����Ƶ�����
 %��ͬ�ŵ�����
 B_ideal = 8e6;  %OFDM�źŴ��������ֵ
 numb = 1; %���ؿ������Ĵ���
 LL = length(snr);
 for i = 1:LL
     for j = 1:numb
         [b_welch(i,j),b_ar(i,j)]=PSD_OFDM_rayleigh(sig1_chnl,fc,fs,snr(i),0,itau,power,fmax,itn);
     end
     B_welch(i) = sum(b_welch(i,:))/numb;
     B_ar(i) = sum(b_ar(i,:))/numb;
     B_rate_welch(i) = 1-abs((B_welch(i)-B_ideal))/B_ideal;
     B_rate_ar(i) = 1-abs((B_ar(i)-B_ideal))/B_ideal;
 end

