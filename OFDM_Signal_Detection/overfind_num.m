 function [Tu_over] = overfind_num(data, PP, N,fff)
  
 Rx_over = zeros(PP, 2*PP);
 data_over=[zeros(1,PP),data,zeros(1,PP)];
 for i = 1 : N-2
    for tao = 1 : 2*PP-1
        for n = 1 : PP
            Rx_over(n,tao) = Rx_over(n,tao) + data_over(PP*(i-1)+n+PP)*conj(data_over(PP*(i-1)+n+tao));
        end
    end
 end
 Rx_over = Rx_over./(N-2);
 R_over =zeros(1,length(Rx_over(1,:)));
 for i=1:length(Rx_over(:,1))
    R_over= R_over+Rx_over(i,:);
 end
 R_over= abs(R_over)/length(Rx_over(:,1));
 %********************************************
 %ȡ��Ч���ݳ���
 %********************************************
 abc11=sort( R_over(1,1:end/2-5*fff));    %����������
 ZZ=length(abc11);
 [as1 ,Tu_over] =find( R_over(1,1:end/2-5*fff)==abc11(1,ZZ));%ȡ��ֵ�߶�Ϊ��һ�ߵķ�ֵ��Ӧ����
 Tu_over=length(R_over)/2-Tu_over;       %Ϊ�źŵ���Ч���ݳ���