function c40=rt_C40(rt)%���4���ۻ���C42
%crt=conj(rt);%rt�Ĺ���
m40=mean(rt.^4);
m20=mean(rt.^2);
%m21=mean(rt.*crt);
c40=abs(m40-3*m20.^2);