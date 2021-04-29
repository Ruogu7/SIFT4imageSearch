
%% 全局变量的定义
%  必要的全局变量的定义，所有全局变量将在各个子程序中调用。
%  sigma_num()：得到本组内，层之间的尺度关系以及本组内实际尺度
 function Imagedb = Define(Imagegray)
ifelse=@(a,b,c)(a~=0)*b+(a==0)*c;  %生成三目运算符

global enlarge
enlarge = 1; %是否放大原始图片,等于0则不放大
if ( logical(enlarge) )
     Imagedb = im2double(imresize(Imagegray,2,'bilinear'));  %图片放大2倍
else
    Imagedb = im2double(Imagegray);
end

global camera_sigma sigma0;
camera_sigma = 0.5;  %原始输入图片定义尺度为camera_sigma;
sigma0 = 1.6;        % 高斯最下面一组最下一层的尺度

global Octave Layers;
Layers = 3; % 高斯塔为Layers+3层，Dog为Layers+2层
Octave = -1; % 定义高斯塔的组数目，其值>0则通过自动获取，否则按照图片尺寸确定
% 以下代码为组数的计算，是自定义还是根据图像（有无放大原图像）尺寸确定组的数量

Octave = ifelse(Octave >0,Octave,ifelse(logical(enlarge), ...
    log(min(size(Imagegray)))/log(2)-1,log(min(size(Imagegray)))/log(2)-2));
Octave = round(Octave);

global sigma;
sigma = zeros(2,Layers+3);
sigma = sigma_num(); %第1行返回本层尺度与上一层尺度的平方差开根号，第2行返回在本组中的实际尺度

global SIFT_Img_Border;
SIFT_Img_Border = 6; %在Dog金字塔中去掉四周的像素数量SIFT_Img_Borde-1

global ExtrThreshold;
% 在极值点精确定位前为1/2*ExtrThreshold，精确定位阈值为ExtrThreshold；
ExtrThreshold = 0.03;%lowe 建议值0.03，但是这个值是归一化0-1中间的

global edgegama; %hessian矩阵中用于判断是否属于边界点的阈值
edgegama = 10;

global SIFT_STEP;
SIFT_STEP = 5;
global IterationMax; %极值点精确查找过程中偏移量过大值，则认为极值点不稳定
IterationMax = 3;

global SIFT_ORI_HIST_BINS; %定义主方向柱数量
SIFT_ORI_HIST_BINS = 36;

global SIFT_ORI_SIG_FCTR; % 主方向半径为SIFT_ORI_RADIUS*SIFT_ORI_SIG_FCTR*所在组内尺度（包含层偏移小数）
SIFT_ORI_SIG_FCTR = 1.5;
global SIFT_ORI_RADIUS;
SIFT_ORI_RADIUS  = 3;

global SIFT_ORI_PEAK_RATIO; %多个主方向，为最大值主方向的阈值
SIFT_ORI_PEAK_RATIO = 0.8;

global boolParabolicFit;
boolParabolicFit = 0; %主方向柱通过抛物线拟合方法或者中心偏移方法

global SIFT_DESCR_WIDTH;
SIFT_DESCR_WIDTH = 4; %特征点描述符 分为SIFT_DESCR_WIDTH *SIFT_DESCR_WIDTH 个正方形
global SIFT_DESCR_HIST_BINS; %特征点描述符 正方形内方向柱数量：SIFT_DESCR_HIST_BINS
SIFT_DESCR_HIST_BINS = 8;  %128维 = SIFT_DESCR_WIDTH * SIFT_DESCR_WIDTH * SIFT_DESCR_HIST_BINS
global SIFT_DESCR_SCL_FCTR;
SIFT_DESCR_SCL_FCTR = 3; %特征点周围SIFT_DESCR_SCL_FCTR*（d+1）范围。备注：还需要扩大1.414倍
global SIFT_DESCR_MAG_THR;
SIFT_DESCR_MAG_THR = 0.2; % 特征点描述符中，大于该阈值的点被置为固定值


