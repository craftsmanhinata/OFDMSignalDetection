function c42=rt_C42(rt)%���4���ۻ���C42
crt=conj(rt);   %rt�Ĺ���
P=mean(rt.*crt); %�źŵ�ƽ������

m20=mean(rt.^2);
m21=mean(rt.*crt);  %�źŵ�ƽ�����������var()�⺯������var()�󷽲�
m42=mean(rt.^2.*crt.^2);

M20=m20/P;
M21=m21/P;
M42=m42/P^2;
 
c42=M42-(abs(M20)).^2-2*(M21.^2);
% c42=m42-(abs(m20)).^2-2*(m21.^2);