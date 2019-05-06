function [VAR_FSK8,VAR_QAM16,VAR_QAM64,VAR_QPSK,VAR_OFDM]=sc_ofdm_wavelet_Ray(N,snr,para,ratio,K,itau,power,itn,fmax,fs)
%**************************************************************************
%���ܣ�С���任�任������ֵ��С���任�ĳ߶����Ӻ���ֵ�˲��������й�
%N:������
%snr:�����
%VAR:С���任����ֵ
%**************************************************************************
scal =8;%С���任�ĳ߶�����
fc = 10e6;   %�źż��ز�Ƶ��
for i=1:length(snr)
    for m=1:10%ÿ���������1100�����ؿ�������

        %******************************************************************
        %8fsk��С���任�����VAR
        %******************************************************************
        data= FSK8();
        data=(data.*exp(1i*2*pi*fc/fs*(0:length(data)-1)));
        data = (MUL_RAYLEIGH(data,itau,power,itn,length(itau),length(data),1/fs,fmax,0));
        data1 = awgn(data,snr(i),'measured');%�Ӹ�˹������
        data1=hilbert(real(data1));%ϣ�����ر任
        data2 = data1/sqrt(sum(real(data1).*real(data1)+imag(data1).*imag(data1))/length(data1));%���ʹ�һ��
        coef= cwt(data2,scal,'haar');%��һ��С���任
        coef= cwt(abs(coef),scal,'haar');%�ڶ���С���任
        coef=medfilt1(abs(coef),30);%��ֵ�˲�
        v_qam=var(coef);%����緽��
        VAR_fsk8(m,i)=v_qam;
        %******************************************************************
        %16qam��С���任�����VAR
        %******************************************************************
        data=QAM16();
        data=(data.*exp(1i*2*pi*fc/fs*(0:length(data)-1)));
        data = (MUL_RAYLEIGH(data,itau,power,itn,length(itau),length(data),1/fs,fmax,0));
        data1 = awgn(data,snr(i),'measured');
        data1=hilbert(real(data1));%ϣ�����ر任
        data2 = data1/sqrt(sum(real(data1).*real(data1)+imag(data1).*imag(data1))/length(data1));
        coef = cwt(data2,scal,'haar');
        coef = cwt(abs(coef),scal,'haar');
        coef=medfilt1(abs(coef),30);
        v_qam=var(coef);%����緽��
        VAR_qam16(m,i)=v_qam;
        %******************************************************************
        %64qam��С���任����VAR
        %******************************************************************
        data=QAM64();
        data=(data.*exp(1i*2*pi*fc/fs*(0:length(data)-1)));
        data = (MUL_RAYLEIGH(data,itau,power,itn,length(itau),length(data),1/fs,fmax,0));
        data1 = awgn(data,snr(i),'measured');
        data1=hilbert(real(data1));%ϣ�����ر任
        data2 = data1/sqrt(sum(real(data1).*real(data1)+imag(data1).*imag(data1))/length(data1));
        coef = cwt(data2,scal,'haar');
        coef = cwt(abs(coef),scal,'haar');
        b=medfilt1(abs(coef),30);
        v_qam=var(b);%����緽��
        VAR_qam64(m,i)=v_qam;
        %******************************************************************
        %qpsk��С���任����VAR
        %******************************************************************
        data=QPSK();
        data = (MUL_RAYLEIGH(data,itau,power,itn,length(itau),length(data),1/fs,fmax,0));
        data1 = awgn(data,snr(i),'measured'); 
        data1=hilbert(real(data1));%ϣ�����ر任
        data2 = data1/sqrt(sum(real(data1).*real(data1)+imag(data1).*imag(data1))/length(data1));
        coef = cwt(data2,scal,'haar');
        coef = cwt(abs(coef),scal,'haar');
        b=medfilt1(abs(coef),30);
        v_qam=var(b);%����緽��
        VAR_qpsk(m,i)=v_qam;
        %******************************************************************
        %ofdm��С���任����VAR
        %******************************************************************
        y2=ofdm(N*2,para,ratio);
%         fc = 10e6;   %�źŵ��ز�Ƶ��
        data = (y2.*exp(1i*2*pi*fc/fs*(0:length(y2)-1)));
        data = (MUL_RAYLEIGH(data,itau,power,itn,length(itau),length(data),1/fs,fmax,0));
        data1 = awgn(data,snr(i),'measured'); 
        data1=hilbert(real(data1));%��Ӧ��ע����QAM�ź���ͬ
        data2 = data1/sqrt(sum(real(data1).*real(data1)+imag(data1).*imag(data1))/length(data1));
        coef = cwt(data2,scal,'haar');
        coef = cwt(abs(coef),scal,'haar');
        b=medfilt1(abs(coef),30);   %��ֵ�˲�
        v_qam=var(b);%����緽��
        VAR_ofdm(m,i)=v_qam;
    end
end
VAR_FSK8=mean(VAR_fsk8);%����緽���ƽ��ֵ
VAR_QAM16=mean(VAR_qam16);
VAR_QAM64=mean(VAR_qam64);
VAR_QPSK=mean(VAR_qpsk);
VAR_OFDM=mean(VAR_ofdm);
%���Ʋ�ͬ�źŰ��緽��������ȵı仯
if K==1
    figure
    plot(snr,VAR_FSK8,'k-o');
    hold on;
    plot(snr,VAR_QAM16,'b-s');
    hold on;
    plot(snr,VAR_QAM64,'g-*');
    hold on;
    plot(snr,VAR_QPSK,'r-v');
    hold on;
    plot(snr,VAR_OFDM,'r-o');
    hold on;
    xlabel('SNR(dB)');
    ylabel('VAR');
    title('����˥���ŵ���С���任����ֵ')
    legend('8fsk','16qam','64qam','qpsk','ofdm');
    grid on;
end