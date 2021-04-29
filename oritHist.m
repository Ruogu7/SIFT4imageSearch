%%
% ��ֵ��λ�ô�����ͳ��
%
function [maxval Hist] = oritHist(gausspyr,kpt) % kpt���ڵ�1�顢2�㡢3�С�4�С��Լ���5�㡢6�С�7�У���΢Сƫ��
global SIFT_ORI_HIST_BINS;  %����������������
n = SIFT_ORI_HIST_BINS; % 
global SIFT_ORI_SIG_FCTR; % ������뾶ΪSIFT_ORI_RADIUS*SIFT_ORI_SIG_FCTR*�������ڳ߶ȣ�������ƫ��С����
global SIFT_ORI_RADIUS;
global sigma0;
global Layers;

oct = kpt(1);lay = kpt(2);
sgm = sigma0*power(2,1/Layers*(lay+kpt(5))); %����ڱ���ĳ߶�
radius = round(SIFT_ORI_RADIUS*SIFT_ORI_SIG_FCTR*sgm); %������ͳ������뾶
expf_scale = -1/(2*(sgm*SIFT_ORI_SIG_FCTR)*(sgm*SIFT_ORI_SIG_FCTR)); % ��̬Ȩ��eָ������
[rows cols] = size(gausspyr{oct}(:,:,lay));
k = 0;
for i=-radius:1:radius
    r = kpt(3)+i;
    if r<2 || r>rows-1   %�г�����Χ
        continue;
    end
    for j=-radius:1:radius
       c = kpt(4)+j;
       if c<2 || c>cols-1 %�г�����Χ
           continue;
       end
       % ��Ϊֻ��Ҫ��ֵ���ʲ�ֵķ�ĸȡ����Ҫ
       dx = gausspyr{oct}(r,c+1,lay)-gausspyr{oct}(r,c-1,lay);
       dy = gausspyr{oct}(r+1,c,lay)-gausspyr{oct}(r-1,c,lay);
       k = k+1;
       Dx(k) = dx; Dy(k) = dy;W(k) = (i*i+j*j)*expf_scale;
    end
end
len = k; %ʵ��ͳ�Ƶ�������Ϊ������Χ�п��ܲ�û������������radius �ķ�Χ��

clear Mag ori exp_W;
Mag = sqrt(Dx.*Dx + Dy.*Dy);  %�ݶȷ�ֵ��
ori = rad2deg( atan2(Dy,Dx) );  %atan2(a,b)��4���޷����У�����ȡֵ����ȡ��������ֵa/b����ȡ���ڵ� (b, a) �����ĸ����ޣ�
ori(ori<0) = ori(ori<0)+360; % ��-180~180ת��Ϊ 0~360���������ori>0ʱ��ִ�У�
exp_W = exp(W);  % Ȩ��û��Ҫ��һ������Ϊÿ�����Ӷ�����ͬ�����Ŵ����С

temphist = zeros(1,n+1);
for k = 1:1:len
    bin = round(ori(k)/360*n); 
    temphist(bin+1) =  temphist(bin+1)+exp_W(k)*Mag(k); 
end
temphist(1) = temphist(1)+temphist(1+n);%��i���ӵĽǶȷ�ΧΪ (i-1)*10-5 ~ (i-1)*10+5
lvbhist = zeros(1,n+4);
lvbhist = [temphist(n-1) temphist(n) temphist(1:n) temphist(1) temphist(2)];
Hist = zeros(1,n);
for i=1:1:n
    ilb=i+2;
    Hist(i) = 6/16*lvbhist(ilb)+4/16*(lvbhist(ilb+1)+lvbhist(ilb-1))+1/16*(lvbhist(ilb+2)+lvbhist(ilb-2)); %��i���ӵĽǶȷ�ΧΪ (i-1)*10-5 ~ (i-1)*10+5
end
maxval = max(Hist(:));



    
       
       
       



