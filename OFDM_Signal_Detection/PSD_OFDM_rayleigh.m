function [B_welch,B_ar] =PSD_OFDM_rayleigh(sig1_chnl,fc,fs,snr,k,itau,power,fmax,itn)
%k=1��ʱ�����PSD
%B�ı�׼ֵ8Mhz
sig3_chnl = (sig1_chnl.*exp(1j*2*pi*fc/fs*(0:length(sig1_chnl)-1)));
sig3_chnl = real(MUL_RAYLEIGH(sig3_chnl,itau,power,itn,length(itau),length(sig3_chnl),1/fs,fmax,0));
sig3_chnl = awgn(sig3_chnl,snr,'measured');
%q= Burg(sig1_chnl,'AIC');
%P=mean(abs(sig1_chnl));           %��y�ı�׼��ÿ⺯������������mean��abs��������ͬ����׼���Ƿ���Ŀ���
%sig1_chnl=sig1_chnl/P;            %P1��P��Ȼ��ͬ����һ���ǳ��Ա�׼����ǳ���ģ�ľ�ֵ,���ǳ���ƽ���͵Ŀ���
% [Pxx1,f]=pburg(sig3_chnl,100,4096*2,fs);  %��ARģ�ͷ����й����׹���
[Pxx1, f, p] = Burg(sig3_chnl,fs, 'AIC');   %��ARģ�ͷ����й����׹���
[Pxx2,f1]=pwelch(sig3_chnl,hanning(100),55,4096*2,fs);  %��welch�㷨���й����׹���

Frc=0:fs/(length(sig3_chnl)):fs/2-1;
OfdmSymComput = 20 * log10(abs(fft(sig3_chnl)));
OfdmSymPSDy = fftshift(OfdmSymComput) - max(OfdmSymComput);

Pxx22 = Pxx2;
Pxx22=Pxx22/min(Pxx22);%�ҳ����ܶ��е���Сֵ������һ������ 
Pxx22=10*log10(Pxx22);%�������ܶȵ�dB����
Pxx22=Pxx22-max(Pxx22);
if k==1
  figure
  plot(f,Pxx1);
  grid on;
  xlabel('Ƶ��f'); 
  ylabel('PSD/db');
  title('ARģ�ͷ����Ĺ������ܶ�����'); 
  
  figure
  plot(f1,Pxx22);
  grid on;
  xlabel('Ƶ��f');
  ylabel('PSD/db');
  title('Welch�㷨���ƹ������ܶ�����'); 
  
  figure
  %plot(Frc,OfdmSymPSDy(1,1:end/2));
  plot(Frc,OfdmSymPSDy(1,1:end/2));
  xlabel('Ƶ��f');
  ylabel('PSD/db');
  title('OFDM�ź�Ƶ��'); 
end
%****************************
%���źŵĴ���
%****************************

L1=ceil(length(Pxx22)/2);
P1=Pxx22(1:L1,1);
P2=Pxx22(L1:end,1);
[as1, as11]=Proximate(-3,P1);  %ȡ��ӽ�-3db���źŵ�f��ֵ
band1=f1(as1);
[as2, as22]=Proximate(-3,P2);
band2=f1(as2+L1-1);
B_welch =abs(band1-band2);

L2=ceil(length(Pxx1)/2);
P3=Pxx1(1:L2,1);
P4=Pxx1(L2:end,1);
if snr>4
    [as3, as33]=Proximate(-6,P3);  %ȡ��ӽ�-3db���źŵ�f��ֵ
    band3=f(as3);
    [as4, as44]=Proximate(-6,P4);
    band4=f(as4+L2-1);
    B_ar =abs(band4-band3);
elseif (snr>0&&snr<=4)
    [as3, as33]=Proximate(-5,P3);  %ȡ��ӽ�-3db���źŵ�f��ֵ
    band3=f(as3);
    [as4, as44]=Proximate(-5,P4);
    band4=f(as4+L2-1);
    B_ar =abs(band4-band3);
else
    [as3, as33]=Proximate(-3,P3);  %ȡ��ӽ�-3db���źŵ�f��ֵ
    band3=f(as3);
    [as4, as44]=Proximate(-3,P4);
    band4=f(as4+L2-1);
    B_ar =abs(band4-band3);
end
end