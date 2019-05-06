%**************************************************************************
%OFDM�ź�ʶ������ز����Ĺ���
%created by Songzhiyong
%2017.03.01
%**************************************************************************
% clc;
% close all;
% clear all;
% %**************************************************************************
% % �����źŸ߽�����ʵ���ź����ʶ��
% % c40_��c42_��ʾ�Ľ���������ʾ�����
% %**************************************************************************
% K = 1;           %��K��ֵΪ1��ʱ�����ͼ��
% N = 20;          %����һ�����ṹ��OFDM�źŵĸ���
% para = 128;%���ò��д�������ز�����
% ratio = 1/4 ; %ѭ��ǰ׺����
% S = 12.5e3  ;   %��������12.5Kbps
% snr1 = -5:5:25;   %�߰��ŵ�������ȣ���ʾ������ֵ�������
% snr = -4:2:10;   %�߰��ŵ��������
% 
% fc = 10e6;   %�źŵ��ز�Ƶ��
% fs = 40e6;   % ����Ƶ��
% 
 itau = floor([0,1e-8,2e-8,5e-8,2e-7,5e-7].*fs);  %�ྶ��ʱ
 power = [0,-1.0,-7.0,-10.0,-12.0,-17.0];  %�ྶ�ŵ���ÿ������
 fmax = 20 ;   %������Ƶ��
 itn = [10000,20000,30000,40000,50000,60000];    %�����ŵ��¼�����
% 
% %**************************************************************************
% [c42_ofdm,c42_qpsk,c42_qam16,c42_qam64,c42_fsk8] = cumulant(snr1,N,para,ratio,K);
% [VAR_FSK8,VAR_QAM16,VAR_QAM64,VAR_QPSK,VAR_OFDM] = sc_ofdm_wavelet(N,snr1,para,ratio,K);
% [VAR_FSK8_Ray,VAR_QAM16_Ray,VAR_QAM64_Ray,VAR_QPSK_Ray,VAR_OFDM_Ray] = sc_ofdm_wavelet_Ray(N,snr1,para,ratio,K,itau,power,itn,fmax,fs);
% %**************************************************************************
% %�߽������ķ�ʽ��ͬ��������źŵ�ʶ����
% %rate_ofdm��ʾ�źŵ���ȷʶ����
% %**************************************************************************
% [rate_ofdm] = OFDM_rate(snr,N,para,ratio);
% [rate_ofdm1] = OFDM_rate_xiaobo(snr,N,para,ratio);
% [rate_ofdm_Ray] = OFDM_rate_xiaobo_Ray(snr,N,para,ratio,itau,power,itn,fmax,fs);
% %**************************************************************************
% %OFDM��ͬ���ز���Ŀ�Ը߽��������ֵ�Ĳ��������Ӱ��
% %c42_ofdm64,c42_ofdm128,c42_ofdm256�ֱ��ʾ
% %���ز���ĿΪ128,256,512ʱ���Ľ�����
% %**************************************************************************
% [V_ofdm128,V_ofdm256,V_ofdm512] = ofdm_dif_para(snr,N,ratio,K);
%  
% %**************************************************************************
% %ofdm�ز�Ƶ�ʲ�������
% %ofdmѭ���׹���ofdm�ź��ز�Ƶ��
% %**************************************************************************
% trst_rate = 5e5;  % �źŷ�������,����Ƭ����
% M = 16; % ƽ������ 
% sig = ofdm(N,para,ratio);
% Ns = length(sig);       % ѭ���׼��������ȣ�����С�ڵ����ź����г���
%  
% %**************************************************************************
% %��������OFDM�źŲ���ѭ��ƽ����
% %**************************************************************************
% s_n = ceil(fs/trst_rate); % �������ʽ���ΪOFDM�ź����ʵ������� 
% sign = sig(ones(s_n,1),:); % ��Ԫ����
% sign = reshape(sign, 1, s_n*length(sign));
% data = sign.*exp(1i*2*pi*fc/fs*(0:length(sign)-1));
% %�߰��ŵ���ѭ���׹�����Ƶ
% data_awgn = awgn(data,25,'measured');
% [f_awgn] = cyclic_spectrum(real(data_awgn), Ns, fs, M,K);  % ѭ������Ƶ��f
% 
% %�����ŵ���ѭ���׹���
% %data_rayleigh = RayFade(itau,power,fmax,fs,data,25);
% data_rayleigh = (MUL_RAYLEIGH(data,itau,power,itn,length(itau),length(data),1/fs,fmax,0));
% data_rayleigh = data_rayleigh/std(data_rayleigh);
% data_rayleigh = awgn(data_rayleigh,25,'measured');
% [f_rayleigh] = cyclic_spectrum(real(data_rayleigh), Ns, fs, M,K);  % ѭ������Ƶ��f
%**************************************************************************
%������
%**************************************************************************
[sig_ofdm] = PSD_generate(N);
%[band_welch,band_ar] = PSD_OFDM(sig_ofdm,fc,fs,20,K);  %��⹦����(25db)
%[B_rate_welch,B_rate_ar ] = Bandwidth_rate( sig_ofdm,fc,fs,snr);   %���źŵĴ�����Ƶ�����

%�����ŵ��´����������
[B_rate_welch_rayleigh,B_rate_ar_rayleigh ] = Bandwidth_rate_rayleigh(sig_ofdm,fc,fs,snr,itau,power,fmax,itn);   %���źŵĴ�����Ƶ�����
[B_welch,B_ar] =PSD_OFDM_rayleigh(sig_ofdm,fc,fs,snr,1,itau,power,fmax,itn);
figure
plot(snr,B_rate_ar_rayleigh,'r-o');
hold on
plot(snr,B_rate_ar,'k-x');
xlabel('snr/db');
ylabel('percentage/%');
legend('Rayleigh','Awgn');
title('��ͬ�ŵ��´����������');

%**************************************************************************
%�߰��ŵ���ѭ����������������Ч���ݳ��Ⱥ��ܳ����Լ�ѭ��ǰ׺����
%**************************************************************************
% sig_a = sig.*exp(1i*2*pi*fc/fs*(0:length(sig)-1));  %���Ƶ���Ƶ 
% [Tu_128,Ts_128,Tg_128 ] = effectivelength(sig_a,fs,20,N,K);
% [ Tu_rate_128,Ts_rate_128,Tg_rate_128] = Length_rate(sig_a,fs,snr,N,1 );
% 
% %**************************************************************************
% %�����ŵ��¹�����Ч���ݳ��Ⱥ��ܳ����Լ�ѭ��ǰ׺����
% %**************************************************************************
% [Tu_128_rayleigh,Ts_128_rayleigh,Tg_128_rayleigh ] = effectivelength_rayleigh(sig_a,fs,10,N,1,itau,power,fmax,itn);
% [Tu_rate_128_rayleigh,Ts_rate_128_rayleigh,Tg_rate_128_rayleigh] = Length_rate_rayleigh(sig_a,fs,snr,N,0,itau,power,fmax,itn );
% figure
% plot(snr,Tu_rate_128_rayleigh,'r-o');
% hold on
% plot(snr,Tu_rate_128,'k-x');
% xlabel('snr/db');
% ylabel('percentage/%');
% legend('Rayleigh','Awgn');
% title('��ͬ�ŵ�����Ч���ݳ��ȹ��Ƶ�Ӱ��')
% figure
% plot(snr,Ts_rate_128_rayleigh,'r-o');
% hold on
% plot(snr,Ts_rate_128,'k-x');
% legend('Rayleigh','Awgn');
% xlabel('snr/db');
% ylabel('percentage/%');
% title('��ͬ�ŵ��������ܳ��ȹ��Ƶ�Ӱ��')
% figure
% plot(snr,Tg_rate_128_rayleigh,'r-o');
% hold on
% plot(snr,Tg_rate_128,'k-x');
% legend('Rayleigh','Awgn');
% xlabel('snr/db');
% ylabel('percentage/%');
% title('��ͬ�ŵ���ѭ��ǰ׺���ȹ��Ƶ�Ӱ��')
% 
% %**************************************************************************
% %�߰��ŵ����ز���Ŀ���źŲ����������ܵ�Ӱ��
% %**************************************************************************
% % sig_256 = ofdm(N,256,ratio);
% % sig256 = sig_256.*exp(1i*2*pi*fc/fs*(0:length(sig_256)-1));  %���Ƶ���Ƶ 
% % [ Tu_rate_256,Ts_rate_256,Tg_rate_256] = Length_rate_difpara(sig256,fs,snr,N,0 );
% % figure
% % plot(snr,Tu_rate_256,'r-o');
% % hold on
% % plot(snr,Tu_rate_128,'k-x');
% % xlabel('snr/db');
% % ylabel('percentage/%');
% % legend('256�����ز�','128�����ز�');
% % title('���ز���Ŀ����Ч���ݳ��ȹ��Ƶ�Ӱ��')
% % figure
% % plot(snr,Ts_rate_256,'r-o');
% % hold on
% % plot(snr,Ts_rate_128,'k-x');
% % legend('256�����ز�','128�����ز�');
% % xlabel('snr/db');
% % ylabel('percentage/%');
% % title('���ز���Ŀ�������ܳ��ȹ��Ƶ�Ӱ��')
% % figure
% % plot(snr,Tg_rate_256,'r-o');
% % hold on
% % plot(snr,Tg_rate_128,'k-x');
% % legend('256�����ز�','128�����ز�');
% % xlabel('snr/db');
% % ylabel('percentage/%');
% % title('���ز���Ŀ��ѭ��ǰ׺���ȹ��Ƶ�Ӱ��')
% 
% %**************************************************************************
% %�߰��ŵ��·�����Ŀ���źŲ����������ܵ�Ӱ��
% %**************************************************************************
% sig_10 = ofdm(10,para,ratio);
% sig10 = sig_10.*exp(1i*2*pi*fc/fs*(0:length(sig_10)-1));  %���Ƶ���Ƶ 
% [ Tu_rate_10,Ts_rate_10,Tg_rate_10] = Length_rate(sig10,fs,snr,10,0 );
% sig_30 = ofdm(30,para,ratio);
% sig30 = sig_30.*exp(1i*2*pi*fc/fs*(0:length(sig_30)-1));  %���Ƶ���Ƶ 
% [Tu_rate_30,Ts_rate_30,Tg_rate_30] = Length_rate(sig30,fs,snr,30,0 );
% figure
% plot(snr,Tu_rate_10,'r-o');
% hold on
% plot(snr,Tu_rate_128,'k-x');
% hold on
% plot(snr,Tu_rate_30,'b-*');
% legend('10������','20������','30������');
% xlabel('snr/db');
% ylabel('percentage/%');
% title('������Ŀ����Ч���ݳ��ȹ��Ƶ�Ӱ��')
% figure
% plot(snr,Ts_rate_10,'r-o');
% hold on
% plot(snr,Ts_rate_128,'k-x');
% hold on
% plot(snr,Ts_rate_30,'b-*');
% legend('10������','20������','30������');
% xlabel('snr/db');
% ylabel('percentage/%');
% title('������Ŀ�������ܳ��ȹ��Ƶ�Ӱ��')
% figure
% plot(snr,Tg_rate_10,'r-o');
% hold on
% plot(snr,Tg_rate_128,'k-x');
% hold on
% plot(snr,Tg_rate_30,'b-*');
% legend('10������','20������','30������');
% xlabel('snr/db');
% ylabel('percentage/%');
% title('������Ŀ��ѭ��ǰ׺���ȹ��Ƶ�Ӱ��')
% 
% %**************************************************************************
% %�߰��ŵ���ѭ��ǰ׺�������źŲ����������ܵ�Ӱ��
% %**************************************************************************
% sig_ratio = ofdm(N,para,1/8);
% sig_r = sig_ratio.*exp(1i*2*pi*fc/fs*(0:length(sig_ratio)-1));  %���Ƶ���Ƶ 
% [ Tu_rate_ratio,Ts_rate_ratio,Tg_rate_ratio] = Length_rate_difratio(sig_r,fs,snr,N,0 );
% 
% sig_ratio1 = ofdm(N,para,3/16);
% sig_r1= sig_ratio1.*exp(1i*2*pi*fc/fs*(0:length(sig_ratio1)-1));  %���Ƶ���Ƶ 
% [Tu_rate_ratio1,Ts_rate_ratio1,Tg_rate_ratio1] = Length_rate_difratio(sig_r1,fs,snr,N,0 );
% figure
% plot(snr,Tu_rate_ratio,'r-o');
% hold on
% plot(snr,Tu_rate_ratio1,'b-*');
% hold on
% plot(snr,Tu_rate_128,'k-x');
% legend('ratio=1/8','ratio=3/16','ratio=1/4');
% xlabel('snr/db');
% ylabel('percentage/%');
% title('ѭ��ǰ׺��������Ч���ݳ��ȹ��Ƶ�Ӱ��')
% figure
% plot(snr,Ts_rate_ratio,'r-o');
% hold on
% plot(snr,Ts_rate_ratio1,'b-*');
% hold on
% plot(snr,Ts_rate_128,'k-x');
% legend('ratio=1/8','ratio=3/16','ratio=1/4');
% xlabel('snr/db');
% ylabel('percentage/%');
% title('ѭ��ǰ׺�����������ܳ��ȹ��Ƶ�Ӱ��')
% figure
% plot(snr,Tg_rate_ratio,'r-o');
% hold on
% plot(snr,Tg_rate_ratio1,'b-*');
% hold on
% plot(snr,Tg_rate_128,'k-x');
% legend('ratio=1/8','ratio=3/16','ratio=1/4');
% xlabel('snr/db');
% ylabel('percentage/%');
% title('ѭ��ǰ׺������ѭ��ǰ׺���ȹ��Ƶ�Ӱ��')
% 
% %**************************************************************************
% %�߰��ŵ���OFDM���ز���Ŀ����
% %**************************************************************************
% [carry_num] = carrier_number(sig_a ,N,25,K);
% [Carry_num_rate_128 ] = Rate_Carrynum(sig_a,snr,para,N,K);
% 
% %**************************************************************************
% %�߰��ŵ���ÿ֡�ķ����������ز���Ŀ���Ƶ�Ӱ��
% %**************************************************************************
% [Carry_num_rate_10 ] = Rate_Carrynum(sig_10,snr,para,10,0);
% %[Carry_num_rate_30 ] = Rate_Carrynum(sig_30,snr,para,30,0);
% Carry_num_rate_30 = Tu_rate_30 ;
% figure
% plot(snr,Carry_num_rate_10,'r-o');
% hold on
% plot(snr,Carry_num_rate_128,'k-x');
% hold on
% plot(snr,Carry_num_rate_30,'b-*');
% xlabel('snr/db');
% ylabel('percentage/%');
% legend('10������','20������','30������');
% title('������Ŀ�����ز���Ŀ���Ƶ�Ӱ��')
% 
% %**************************************************************************
% %�߰��ŵ���ѭ��ǰ׺�ı��������ز���Ŀ���Ƶ�Ӱ��
% %**************************************************************************
% [Carry_num_rate_ratio ] = Rate_Carrynum(sig_ratio,snr,para,N,0);
% [Carry_num_rate_ratio1 ] = Rate_Carrynum(sig_ratio1,snr,para,N,0);
% figure
% plot(snr,Carry_num_rate_ratio,'r-o');
% hold on
% plot(snr,Carry_num_rate_ratio1,'b-*');
% hold on
% plot(snr,Carry_num_rate_128,'k-x');
% xlabel('snr/db');
% ylabel('percentage/%');
% legend('ratio=1/8','ratio=3/16','ratio=1/4');
% title('ѭ��ǰ׺���������ز���Ŀ���Ƶ�Ӱ��')
% 
% %**************************************************************************
% %�߰��ŵ������ز����������ز���Ŀ���Ƶ�Ӱ��
% %**************************************************************************
% %[Carry_num_rate_256 ] = Rate_Carrynum(sig_256,snr,256,N,0);
% % Carry_num_rate_256 = Tu_rate_256;
% % figure
% % plot(snr,Carry_num_rate_256,'r-o');
% % hold on
% % plot(snr,Carry_num_rate_128,'k-x');
% % legend('256�����ز�','128�����ز�');
% % xlabel('snr/db');
% % ylabel('percentage/%');
% % title('���ز���Ŀ�����ز���Ŀ���Ƶ�Ӱ��')
% 
% %**************************************************************************
% %�����ŵ���OFDM���ز���Ŀ��������
% %**************************************************************************
% [Carry_num_rate_rayleigh ]= Rate_Carrynum_rayleigh(sig_a, snr,N ,para,itau,power,fmax,fs,itn);
% figure
% plot(snr,Carry_num_rate_rayleigh,'r-o');
% hold on
% plot(snr,Carry_num_rate_128,'k-x');
% legend('Rayleigh','Awgn');
% xlabel('snr/db');
% ylabel('percentage/%');
% title('��ͬ�ŵ������ز���Ŀ��������');
% 
% %**************************************************************************
% %���ô��������ز���Ŀ
% %**************************************************************************
% [BB, Carrynum_B] =solve_carrynum_rate(sig_ofdm,fc,fs,snr,N );    %���ô���ķ�ʽ�����ز���Ŀ
