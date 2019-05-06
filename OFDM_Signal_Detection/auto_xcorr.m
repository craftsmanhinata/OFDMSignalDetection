 function [Tu,Ts] = auto_xcorr(data, P, xcorr_len, N,t,K)
 %*************************************************************************
 %���ܣ����㷢�����ݻ�������������
 %data����������
 %P��ѭ������
 %N��OFDM������
 %xcorr_len������س���,��OFDM����Ϊ��λ
 %K=1ʱ����ͼ��  
 %Rx����غ���
 %*************************************************************************
 kk = xcorr_len+2 ;
 xcorr_len = xcorr_len*P;
 Rx = zeros(xcorr_len, 2*P);
 data1=[zeros(1,P),data,zeros(1,P)];
 for i = 1 : N-kk+1
    for tao = 1-P : P
        for n = 1 : xcorr_len
            Rx(n,tao+P) = Rx(n,tao+P) + data1(P*(i-1)+n+P)*conj(data1(P*(i-1)+n+tao+P));
        end
    end
 end

 Rx = Rx./(N-kk+1);
 R_tao =zeros(1,length(Rx(1,:)));
 for i=1:length(Rx(:,1))
    R_tao= R_tao+Rx(i,:);
 end

 R_tao= abs(R_tao)/length(Rx(:,1));
 
 if K==1
     figure
     stem ((1-P)*t :t:( P)*t ,R_tao);   %P*t�ǽ��ɲ���������ʾ����Ч���ݳ��ȱ�Ϊ��ʱ���ʾ��
     xlabel('delay/s');
     ylabel('amplitute');
     title('�̲��ɱ���ʱ�����')
     figure
     stem ((1-P) :( P) ,R_tao);   %P*t�ǽ��ɲ���������ʾ����Ч���ݳ��ȱ�Ϊ��ʱ���ʾ��
     xlabel('delay/s');
     ylabel('amplitute');
     title('�����ɱ���ʱ�����')
 end
 %********************************************
 %ȡ��Ч���ݳ���
 %********************************************
 abc=sort( R_tao(1,1:end/2));    %����������
 Z=length(abc);
 [as1 ,Tu1] =find( R_tao(1,1:end/2)==abc(1,Z-1));%ȡ��ֵ�߶�Ϊ�ڶ��ߵķ�ֵ��Ӧ����
 Tu=(length(R_tao)/2-Tu1)*t;       %Ϊ�źŵ���Ч���ݳ���

 %********************************************
 %ȡ���ݵ��ܳ���
 %********************************************
 
 sigma0 = 6;   %�۲����ݵĳ�������
 L_fft=sigma0*P;     %�۲����ݵĳ��ȣ���fft�ĳ���
 RR = zeros(xcorr_len, L_fft);
 data111=[zeros(1,P),data,zeros(1,P)];   %���۲�����ݳ����ӳ��������������ʱ��������
 for i = 1 : N-4 
    for k=1:L_fft
            RR(i,k) =data111(P*(i-1)+k)*conj(data111(P*(i-1)+k+length(R_tao)/2-Tu1));
    end
 end

 RRR_tao =zeros(1,length(RR(1,:)));
 for i=1:length(RR(:,1))
    RRR_tao= RRR_tao+RR(i,:);
 end

 RRR_tao= abs(RRR_tao)/length(RR(:,1));
 RRR_T=ifft(RRR_tao);
 RRR_fft= abs(RRR_T(1,1:20*sigma0));
 if K==1
     figure
     LL=t:t:20*sigma0*t;
     stem(LL,RRR_fft);
     title('�̲��̶���ʱ����ص�IFFT')
     figure
     stem(RRR_fft);
     title('�����̶���ʱ����ص�IFFT')
 end

a=sort(RRR_fft);    %����������
Z=length(a);
[a1 ,T1] =find(RRR_fft==a(1,Z));%ȡ��ֵ�߶�Ϊ��һ�ߵķ�ֵ��Ӧ����
[a2 ,T2] =find(RRR_fft==a(1,Z-1));%ȡ��ֵ�߶�Ϊ�ڶ��ߵķ�ֵ��Ӧ����
[a3 ,T3] =find(RRR_fft==a(1,Z-2));%ȡ��ֵ�߶�Ϊ�����ߵķ�ֵ��Ӧ����
Ts1 = abs(T2-T1);
Ts2 = abs(T3-T2);
Ts3 = abs(T3-T1);
Tss = [Ts1 Ts2 Ts3];
TT = sort(Tss);  %����������ȡ�����Сֵ
Ts= L_fft/TT(1)*t;       %Ϊ�źŵ���Ч���ݳ���