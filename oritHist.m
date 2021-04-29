%%
% 极值点位置处方向统计
%
function [maxval Hist] = oritHist(gausspyr,kpt) % kpt所在的1组、2层、3行、4列、以及（5层、6行、7列）的微小偏差
global SIFT_ORI_HIST_BINS;  %定义主方向柱数量
n = SIFT_ORI_HIST_BINS; % 
global SIFT_ORI_SIG_FCTR; % 主方向半径为SIFT_ORI_RADIUS*SIFT_ORI_SIG_FCTR*所在组内尺度（包含层偏移小数）
global SIFT_ORI_RADIUS;
global sigma0;
global Layers;

oct = kpt(1);lay = kpt(2);
sgm = sigma0*power(2,1/Layers*(lay+kpt(5))); %相对于本组的尺度
radius = round(SIFT_ORI_RADIUS*SIFT_ORI_SIG_FCTR*sgm); %主方向统计邻域半径
expf_scale = -1/(2*(sgm*SIFT_ORI_SIG_FCTR)*(sgm*SIFT_ORI_SIG_FCTR)); % 正态权重e指数部分
[rows cols] = size(gausspyr{oct}(:,:,lay));
k = 0;
for i=-radius:1:radius
    r = kpt(3)+i;
    if r<2 || r>rows-1   %行超出范围
        continue;
    end
    for j=-radius:1:radius
       c = kpt(4)+j;
       if c<2 || c>cols-1 %列超出范围
           continue;
       end
       % 因为只需要比值，故差分的分母取消不要
       dx = gausspyr{oct}(r,c+1,lay)-gausspyr{oct}(r,c-1,lay);
       dy = gausspyr{oct}(r+1,c,lay)-gausspyr{oct}(r-1,c,lay);
       k = k+1;
       Dx(k) = dx; Dy(k) = dy;W(k) = (i*i+j*j)*expf_scale;
    end
end
len = k; %实际统计的数量因为超出范围有可能并没有真正在正负radius 的范围内

clear Mag ori exp_W;
Mag = sqrt(Dx.*Dx + Dy.*Dy);  %梯度幅值；
ori = rad2deg( atan2(Dy,Dx) );  %atan2(a,b)是4象限反正切，它的取值不仅取决于正切值a/b，还取决于点 (b, a) 落入哪个象限：
ori(ori<0) = ori(ori<0)+360; % 将-180~180转换为 0~360；该语句在ori>0时不执行；
exp_W = exp(W);  % 权重没必要归一化，因为每个柱子都是相同比例放大或缩小

temphist = zeros(1,n+1);
for k = 1:1:len
    bin = round(ori(k)/360*n); 
    temphist(bin+1) =  temphist(bin+1)+exp_W(k)*Mag(k); 
end
temphist(1) = temphist(1)+temphist(1+n);%第i柱子的角度范围为 (i-1)*10-5 ~ (i-1)*10+5
lvbhist = zeros(1,n+4);
lvbhist = [temphist(n-1) temphist(n) temphist(1:n) temphist(1) temphist(2)];
Hist = zeros(1,n);
for i=1:1:n
    ilb=i+2;
    Hist(i) = 6/16*lvbhist(ilb)+4/16*(lvbhist(ilb+1)+lvbhist(ilb-1))+1/16*(lvbhist(ilb+2)+lvbhist(ilb-2)); %第i柱子的角度范围为 (i-1)*10-5 ~ (i-1)*10+5
end
maxval = max(Hist(:));



    
       
       
       



