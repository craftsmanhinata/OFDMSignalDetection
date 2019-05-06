function [psdviaBurg, f, p] = Burg(x, Fs, varargin)
%MYBURG      ����burg�㷨ʵ�ֵ�ARģ�͹����׼���
% psdviaBurg ����burg�㷨����Ĺ�����ֵ
% f          Ƶ�������
% p          ģ�ͽ״�
% x          ����ź�
% Fs         ������
% varargin   ��Ϊ��ֵ�ͣ���ΪARģ�ͽ״�
%            ��Ϊ�ַ�������Ϊ����׼��ARģ�ͽ״��ɳ���ȷ��
%
% ���������������
if strcmp(class(varargin{1}), 'double')
    p = varargin{1};
elseif ischar(varargin{1})
    criterion = varargin{1};
else
    error('����2����Ϊ��ֵ�ͻ����ַ���');
end
x = x(:);
N = length(x);
% ģ�Ͳ������
if exist('p', 'var') % p�����Ƿ���ڣ���������Ҫ���ף�ֱ��ʹ��p��
    [a, E] = computeARpara(x, p);
else % p�����ڣ���Ҫ���ף�����׼��criterion
    p = ceil(N/3); % �״�һ�㲻�����źų��ȵ�1/3
    
    % ����1��p�׵����
    [a, E] = computeARpara(x, p);
    
    % ����������Ŀ�꺯����Сֵ
    kc = 1:p + 1;
    switch criterion
        case 'FPE'
            goalF = E.*(N + (kc + 1))./(N - (kc + 1));
        case 'AIC'
            goalF = N.*log(E) + 2.*kc;
    end
    [minF, p] = min(goalF); % p����Ŀ�꺯����С��λ�ã�Ҳ������׼������Ľ״�
    
    % ʹ��p���������ARģ�Ͳ���
    [a, E] = computeARpara(x, p);
end
[h, f] = freqz(1, a, 20e5, Fs);
psdviaBurg = E(end)*abs(h).^2./Fs;
psdviaBurg=psdviaBurg/abs(max(psdviaBurg));
psdviaBurg=(10*log10(abs(psdviaBurg)));