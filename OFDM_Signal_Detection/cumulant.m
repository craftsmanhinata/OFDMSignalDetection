function [c42_ofdm,c42_qpsk,c42_qam16,c42_qam64,c42_fsk8] = cumulant(snr,N,para,ratio,K)
%**************************************************************************
%���ܣ��߽�����ʶ���ź�
%awgn�ŵ���OFDM�źų��ָ�˹�ԣ����ز��ź�û�и�˹�ԣ����ø�˹�źŵĸ߽��ۻ���Ϊ�������ֵ��ز���OFDM�ź�
% ����ֵ�� c42_ofdm=0��c42_qpsk=-1��c42_qam16=-0.6800��c42_qam64=-0.6190
% �ɷ���ɼ�ֻ��������ȴ���10dBʱ��õ�m42��������ֵ���
%snr�������
%N�����Ÿ���
%para:���ز���Ŀ
%ratio��ѭ��ǰ׺����
%**************************************************************************

meantimes = 20;     %10��ȡƽ��
for i=1:length(snr)
    for j=1:meantimes
        st_ofdm=ofdm(N,para,ratio);
        rt_ofdm = awgn(st_ofdm,snr(i));
        c42_ofdm(i,j)=rt_C42(rt_ofdm);    %c42 ����������
        
        st_qpsk=QPSK();
        rt_qpsk= awgn(st_qpsk,snr(i),'measured');%�Ӹ�˹������
        c42_qpsk(i,j)=rt_C42( rt_qpsk); 
%         c40_qpsk(i,j)=rt_C40( rt_qpsk); 
        
        st_qam16=QAM16();
        rt_qam16= awgn(st_qam16,snr(i),'measured');%�Ӹ�˹������
        c42_qam16(i,j)=rt_C42(rt_qam16);
%         c40_qam16(i,j)=rt_C40(rt_qam16); 
        
        st_qam64=QAM64();
        rt_qam64 = awgn(st_qam64,snr(i),'measured');%�Ӹ�˹������
        c42_qam64(i,j)=rt_C42(rt_qam64);
        
        st_fsk8=FSK8();
        rt_fsk8 = awgn(st_fsk8,snr(i),'measured');%�Ӹ�˹������
        c42_fsk8(i,j)=rt_C42(rt_fsk8); 
%         c40_fsk8(i,j)=rt_C40(rt_fsk8); 
    end
end
c42_ofdm=mean(c42_ofdm.');
c42_qpsk=mean(c42_qpsk.');
c42_qam16=mean(c42_qam16.');
c42_qam64=mean(c42_qam64.');
c42_fsk8=mean(c42_fsk8.');

% c40_qpsk=mean(c40_qpsk.');
% c40_fsk8=mean(c40_fsk8.');
% c40_qam16=mean(c40_qam16.');

if K==1
  figure
  plot(snr,c42_ofdm,'r-o');
  hold on
  plot(snr,c42_qpsk,'k-x');
  hold on
  plot(snr,c42_qam16,'b-o');
  hold on
  plot(snr,c42_qam64,'k-o');
  hold on
  plot(snr,c42_fsk8,'r-v');
  hold on;

  legend('ofdm:0','qpsk:-1','16qam:-0.68','64qam:-0.619','8fsk:-1');
  xlabel('snr(dB)')
  ylabel('C42')
  title('�źŵĸ߽�����C42')

%   figure
%   plot(snr,c40_qpsk,'k-x');
%   hold on
%   plot(snr,c40_fsk8,'r-o');
%   hold on;
%   plot(snr,c40_qam16,'b-*');
%   hold on;
%   legend('qpsk:-x','8fsk:-o','qam16');
%   xlabel('snr(dB)')
%   ylabel('C40')
%   title('�źŵĸ߽�����C40')
end
