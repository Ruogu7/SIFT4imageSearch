%% SIFT 主函数
% 作者：ruogu7, 时间：2018-03-29
% Define（）: 全局数据定义，如果修改参数则可以在此子程序中进行
% buildgausspyr(Imagedb)： 创建高斯金字塔
% buildDogpyr(gausspyr)： 创建Dog金字塔

%% 全局变量的定义
%  必要的全局变量的定义，所有全局变量将在各个子程序中调用。
 function [Imagedb Keypoint Descriptors] = SIFT_csh(Input1)
 %keypoint每行为所在的1组、2层、3行、4列、以及（5层、6行、7列）的微小偏差、8主方向角度
 % Descriptors每行为Keypoint中某一行对应的d*d*n维特征向量描述符

% Input1 = imread('lena.png');
% Input1 = imread('book1gray.png');
% Input1 = imread('matrix.png');  %为中间有一片白色的正方形区域

%%
if ndims(Input1)==3
    Imagegray = rgb2gray(Input1); %将彩色图像转换为灰度图像 
else
     Imagegray = Input1;
end
% global camera_sigma sigma0;
% global enlarge
% global Octave Layers;
% global sigma;
Imagedb = Define(Imagegray);  %全局数据管理，并返回灰度图的浮点数数据Imagedb（0-1之间）
gausspyr = buildgausspyr(Imagedb);
Dogpyr = buildDogpyr(gausspyr);
Keypoint = findExtrma(gausspyr,Dogpyr);
Descriptors = [];
for i=1:1:size(Keypoint,1)
    kpt = Keypoint(i,:);
    descriptors = calcDescriptors(gausspyr,kpt);
    Descriptors = [Descriptors;descriptors];
end

