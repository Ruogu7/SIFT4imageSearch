%%  计算特征描述符
%
% 
% 
%%
function descriptors= calcDescriptors(gausspyr,Keypoint)
 %keypoint为所在的1组、2层、3行、4列、以及（5层、6行、7列）的微小偏差、8主方向角度
 
global SIFT_DESCR_WIDTH; %特征点描述符 分为SIFT_DESCR_WIDTH *SIFT_DESCR_WIDTH 个正方形
d = SIFT_DESCR_WIDTH;
global SIFT_DESCR_HIST_BINS; %特征点描述符 正方形内方向柱数量：SIFT_DESCR_HIST_BINS
n = SIFT_DESCR_HIST_BINS ;  % d*d*n = 128维 
dst = zeros(1,d*d*n);
deg_per_bin = 360/n;
global SIFT_DESCR_SCL_FCTR; %SIFT_DESCR_SCL_FCTR = 3; 
global sigma;
global SIFT_DESCR_MAG_THR;
oct = Keypoint(1);  % 组
lay = Keypoint(2);  % 层
gauss_sigma0 = sigma(2,lay);  % 高斯塔所在层的sigma

hist_width = SIFT_DESCR_SCL_FCTR * gauss_sigma0 ;
radius = round(hist_width * sqrt(2)/2*(d+1));
ori = Keypoint(8);  % 主方向角度
cos_ori = cosd(ori);
sin_ori = sind(ori);
[rows cols] = size(gausspyr{oct}(:,:,lay));
exp_scale = -2/(d*d); %高斯权重相当于为d/2；
cubhist = zeros(d+2,d+2,n+1);
k = 0;
for ri = -radius:1:radius
    for ci = -radius:1:radius
        rcd = [cos_ori -sin_ori;sin_ori cos_ori] *[ri;ci]; %旋转
        rd_ = rcd(1)/hist_width; %旋转后的行 d
        cd_ = rcd(2)/hist_width; %旋转后的列 d
        
        %  移位到左上角
        rbin = rd_ + d/2-0.5;  %旋转移位后的行 d
        cbin = cd_ + d/2-0.5;  %旋转移位后的列 d
%         r = gausspyr{oct} (Keypoint(3),Keypoint(4),lay);
        r = Keypoint(3)+ri; %旋转前的行坐标
        c = Keypoint(4)+ci; %旋转前的列坐标
        if rbin>-1 && rbin<d && cbin>-1 && cbin<d && ...
                r>=2 && r<=rows-1 && c>=2 && c<=cols-1
           k=k+1;
           dx = gausspyr{oct}(r,c+1,lay)-gausspyr{oct}(r,c-1,lay);
           dy = gausspyr{oct}(r+1,c,lay)-gausspyr{oct}(r-1,c,lay);
           Dx(k) =dx;Dy(k) =dy;
           Rbin(k) = rbin;Cbin(k) =cbin;
           W(k) = exp((rd_^2+cd_^2)*exp_scale); %权重
        end
    end
end

len = k;
Mag = sqrt(Dx.*Dx + Dy.*Dy);  %梯度幅值；
orik = rad2deg( atan2(Dy,Dx) );  %atan2(a,b)是4象限反正切，它的取值不仅取决于正切值a/b，还取决于点 (b, a) 落入哪个象限：
orik(orik<0) = orik(orik<0)+360; % 将-180~180转换为 0~360；该语句在ori>0时不执行；
for k=1:1:len
    rbin =Rbin(k);cbin =Cbin(k); %旋转移位后的行列 d
    ori1 = orik(k)-ori;
    ori1(ori1<0) = ori1+360; %将-360-360转换为 0-360°
    obin = ori1/deg_per_bin;
    mag = Mag(k)*W(k);
    r0 = floor(rbin);c0 = floor(cbin); %取值范围为 [-1~d-1]  
    ob0 = floor(obin); %取值范围为 [0~8]
    ob0(ob0==8) = 0; %取值范围为 [0~7]
    rbin = rbin-r0; % 小数部分
    cbin = cbin-c0;
    obin = obin-ob0;
    % 为了防止超出边界
    histc = c0+2;  % c0 取值范围为 [-1~d-1]
    histr = r0+2;  % r0 取值范围为 [-1~d-1]
    histo = ob0+1; % ob0 取值范围为 [0~7]
    %
    cubhist(histc,histr,histo) = (1-cbin)*(1-rbin)*(1-obin)*mag + ...
        cubhist(histc,histr,histo);
    cubhist(histc,histr,histo+1) = (1-cbin)*(1-rbin)*obin*mag + ...
        cubhist(histc,histr,histo+1);
    
    cubhist(histc,histr+1,histo) = (1-cbin)*rbin*(1-obin)*mag + ...
        cubhist(histc,histr+1,histo);
    cubhist(histc,histr+1,histo+1) = (1-cbin)*rbin*obin*mag + ...
        cubhist(histc,histr+1,histo+1);
    
    cubhist(histc+1,histr,histo) = cbin*(1-rbin)*(1-obin)*mag + ...
        cubhist(histc+1,histr,histo);
    cubhist(histc+1,histr,histo+1) = cbin*(1-rbin)*obin*mag + ...
        cubhist(histc+1,histr,histo+1);
    
    cubhist(histc+1,histr+1,histo) = cbin*rbin*(1-obin)*mag + ...
        cubhist(histc+1,histr+1,histo);
    cubhist(histc+1,histr+1,histo+1) = cbin*rbin*obin*mag + ...
        cubhist(histc+1,histr+1,histo+1);
end

% cs = [sum(Mag.*W) sum(cubhist(:))]
cubhist(:,:,1) = cubhist(:,:,1) +cubhist(:,:,n+1);  %在0°和360°数据合并
for i=1:1:d % 行r
    for j=1:1:d  %列c 
        for k=1:1:n  %方向柱1~n
            dst(((i-1)*d+j-1)*n+k) = cubhist(i+1,j+1,k);
        end
    end
end

descriptors =dst/sqrt(sumsqr(dst));
% 大于阈值则被置为阈值值
descriptors(descriptors>SIFT_DESCR_MAG_THR) = SIFT_DESCR_MAG_THR;
descriptors =descriptors/sqrt(sumsqr(descriptors));




            
            
                               

