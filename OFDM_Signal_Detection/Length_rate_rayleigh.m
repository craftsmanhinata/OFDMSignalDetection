function [ Tu_rate,Ts_rate,Tg_rate] = Length_rate_rayleigh(x,fs,snr,N,K,itau,power,fmax,itn )
%**************************************************************************
%���ܣ���Ч���ݳ��ȣ������ܳ��ȣ�ѭ��ǰ׺���ȹ�������
%x:�����ź�
%fs������Ƶ��
%snr�������
%N�����Ÿ���
%Tu_rate����Ч���ݳ��ȹ�������
%Ts_rate�������ܳ��ȹ�������
%Tg_rate��ѭ��ǰ׺��������
%**************************************************************************
meantimes=100;
Lx=length(snr);
Tu_num=zeros(1,Lx);
Ts_num=zeros(1,Lx);
Tg_num=zeros(1,Lx);

%׼ȷ��
Tu_rate=zeros(1,Lx);
Ts_rate=zeros(1,Lx);
Tg_rate=zeros(1,Lx);
Tu_ideal=(3.2e-6);
Ts_ideal=(4.0e-6);
Tg_ideal=(8.0e-7);

% Tu_ideal=1.28e-5;
% Ts_ideal=1.6e-5;
% Tg_ideal=3.2e-6;
for i=1:Lx
    for j=1:meantimes
        [Tu(i,j),Ts(i,j),Tg(i,j)] = effectivelength_rayleigh(x,fs,snr(i),N,0,itau,power,fmax,itn);
        
        if  (Tu(i,j)==Tu_ideal)
            Tu_num(i)=Tu_num(i)+1;
        end
        if  (Ts(i,j)==Ts_ideal)
            Ts_num(i)=Ts_num(i)+1;
        end
        if  (Tg(i,j)==Tg_ideal)
            Tg_num(i)=Tg_num(i)+1;
        end
    end
    Tu_rate(i)=Tu_num(i)/meantimes;
    Ts_rate(i)= Ts_num(i)/meantimes;
    Tg_rate(i)=Tg_num(i)/meantimes;
end

if K==1
    figure
    plot(snr,Tu_rate,'b-o');
    grid on;
    title('��Ч���ݳ��ȹ�������');
    figure
    plot(snr,Ts_rate,'b-o');
    grid on;
    title('�����ܳ��ȹ�������');
    figure
    plot(snr,Tg_rate,'b-o');
    grid on;
    title('ѭ��ǰ׺���ȹ�������')
end