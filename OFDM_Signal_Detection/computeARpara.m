function [a, E] = computeARpara(x, p)
% �����ź�����x�ͽ״�p����ARģ�Ͳ��������
N = length(x);
% ��ʼֵ
ef = x; % ǰ��Ԥ�����
eb = x; % ����Ԥ�����
a  = 1; % ��ʼģ�Ͳ���
E  = x'*x/N; % ��ʼ���
k  = zeros(1, p); % Ϊ����ϵ��Ԥ����ռ䣬���ѭ���ٶ�
E  = [E k]; % Ϊ���Ԥ����ռ䣬����ٶ�
for m = 1:p
    % ����burg�㷨���裬���ȼ���m�׵ķ���ϵ��
    efm = ef(2:end); % ǰһ�״ε�ǰ��Ԥ�����
    ebm = eb(1:end - 1); % ǰһ�״εĺ���Ԥ�����
    num = -2.*ebm'*efm;  % ����ϵ���ķ�����
    den = efm'*efm + ebm'*ebm; % ����ϵ���ķ�ĸ��
    k(m) = num./den; % ��ǰ�״εķ���ϵ��
    
    % ����ǰ����Ԥ�����
    ef = efm + k(m)*ebm;
    eb = ebm + conj(k(m))*efm;
    
    % ����ģ��ϵ��a
    a = [a; 0] + k(m)*[0; conj(flipud(a))];
    
    % ��ǰ�״ε�����
    E(m + 1) = (1 - conj(k(m))*k(m))*E(m);
end