%%  ��������������
%
% 
% 
%%
function descriptors= calcDescriptors(gausspyr,Keypoint)
 %keypointΪ���ڵ�1�顢2�㡢3�С�4�С��Լ���5�㡢6�С�7�У���΢Сƫ�8������Ƕ�
 
global SIFT_DESCR_WIDTH; %������������ ��ΪSIFT_DESCR_WIDTH *SIFT_DESCR_WIDTH ��������
d = SIFT_DESCR_WIDTH;
global SIFT_DESCR_HIST_BINS; %������������ �������ڷ�����������SIFT_DESCR_HIST_BINS
n = SIFT_DESCR_HIST_BINS ;  % d*d*n = 128ά 
dst = zeros(1,d*d*n);
deg_per_bin = 360/n;
global SIFT_DESCR_SCL_FCTR; %SIFT_DESCR_SCL_FCTR = 3; 
global sigma;
global SIFT_DESCR_MAG_THR;
oct = Keypoint(1);  % ��
lay = Keypoint(2);  % ��
gauss_sigma0 = sigma(2,lay);  % ��˹�����ڲ��sigma

hist_width = SIFT_DESCR_SCL_FCTR * gauss_sigma0 ;
radius = round(hist_width * sqrt(2)/2*(d+1));
ori = Keypoint(8);  % ������Ƕ�
cos_ori = cosd(ori);
sin_ori = sind(ori);
[rows cols] = size(gausspyr{oct}(:,:,lay));
exp_scale = -2/(d*d); %��˹Ȩ���൱��Ϊd/2��
cubhist = zeros(d+2,d+2,n+1);
k = 0;
for ri = -radius:1:radius
    for ci = -radius:1:radius
        rcd = [cos_ori -sin_ori;sin_ori cos_ori] *[ri;ci]; %��ת
        rd_ = rcd(1)/hist_width; %��ת����� d
        cd_ = rcd(2)/hist_width; %��ת����� d
        
        %  ��λ�����Ͻ�
        rbin = rd_ + d/2-0.5;  %��ת��λ����� d
        cbin = cd_ + d/2-0.5;  %��ת��λ����� d
%         r = gausspyr{oct} (Keypoint(3),Keypoint(4),lay);
        r = Keypoint(3)+ri; %��תǰ��������
        c = Keypoint(4)+ci; %��תǰ��������
        if rbin>-1 && rbin<d && cbin>-1 && cbin<d && ...
                r>=2 && r<=rows-1 && c>=2 && c<=cols-1
           k=k+1;
           dx = gausspyr{oct}(r,c+1,lay)-gausspyr{oct}(r,c-1,lay);
           dy = gausspyr{oct}(r+1,c,lay)-gausspyr{oct}(r-1,c,lay);
           Dx(k) =dx;Dy(k) =dy;
           Rbin(k) = rbin;Cbin(k) =cbin;
           W(k) = exp((rd_^2+cd_^2)*exp_scale); %Ȩ��
        end
    end
end

len = k;
Mag = sqrt(Dx.*Dx + Dy.*Dy);  %�ݶȷ�ֵ��
orik = rad2deg( atan2(Dy,Dx) );  %atan2(a,b)��4���޷����У�����ȡֵ����ȡ��������ֵa/b����ȡ���ڵ� (b, a) �����ĸ����ޣ�
orik(orik<0) = orik(orik<0)+360; % ��-180~180ת��Ϊ 0~360���������ori>0ʱ��ִ�У�
for k=1:1:len
    rbin =Rbin(k);cbin =Cbin(k); %��ת��λ������� d
    ori1 = orik(k)-ori;
    ori1(ori1<0) = ori1+360; %��-360-360ת��Ϊ 0-360��
    obin = ori1/deg_per_bin;
    mag = Mag(k)*W(k);
    r0 = floor(rbin);c0 = floor(cbin); %ȡֵ��ΧΪ [-1~d-1]  
    ob0 = floor(obin); %ȡֵ��ΧΪ [0~8]
    ob0(ob0==8) = 0; %ȡֵ��ΧΪ [0~7]
    rbin = rbin-r0; % С������
    cbin = cbin-c0;
    obin = obin-ob0;
    % Ϊ�˷�ֹ�����߽�
    histc = c0+2;  % c0 ȡֵ��ΧΪ [-1~d-1]
    histr = r0+2;  % r0 ȡֵ��ΧΪ [-1~d-1]
    histo = ob0+1; % ob0 ȡֵ��ΧΪ [0~7]
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
cubhist(:,:,1) = cubhist(:,:,1) +cubhist(:,:,n+1);  %��0���360�����ݺϲ�
for i=1:1:d % ��r
    for j=1:1:d  %��c 
        for k=1:1:n  %������1~n
            dst(((i-1)*d+j-1)*n+k) = cubhist(i+1,j+1,k);
        end
    end
end

descriptors =dst/sqrt(sumsqr(dst));
% ������ֵ����Ϊ��ֵֵ
descriptors(descriptors>SIFT_DESCR_MAG_THR) = SIFT_DESCR_MAG_THR;
descriptors =descriptors/sqrt(sumsqr(descriptors));




            
            
                               

