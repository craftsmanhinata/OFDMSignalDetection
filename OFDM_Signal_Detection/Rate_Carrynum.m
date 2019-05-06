function  [Carry_num_rate ]= Rate_Carrynum(yc, snr,para,N,K )
%�����ز���Ŀ�Ĺ��Ƶ�׼ȷ��
%���ز���Ŀ����ֵpara
carrynum_ideal=para;
meantimes =100;
Carry_num_rate=zeros(1,length(snr));
for j=1:length(snr)
    for i=1:meantimes
        [carry_num(j,i)] = carrier_number(yc,N,snr(j),0);
        if(carry_num(j,i)==carrynum_ideal)
           Carry_num_rate(j)=Carry_num_rate(j)+1;
        end
    end
end
Carry_num_rate=Carry_num_rate/meantimes;

if K==1
    figure
    plot(snr,Carry_num_rate,'b-o');
    xlabel('snr/db');
    ylabel('percentage/%');
    title('���ز���Ŀ��������');
end


