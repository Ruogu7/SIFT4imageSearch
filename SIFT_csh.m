%% SIFT ������
% ���ߣ�ruogu7, ʱ�䣺2018-03-29
% Define����: ȫ�����ݶ��壬����޸Ĳ���������ڴ��ӳ����н���
% buildgausspyr(Imagedb)�� ������˹������
% buildDogpyr(gausspyr)�� ����Dog������

%% ȫ�ֱ����Ķ���
%  ��Ҫ��ȫ�ֱ����Ķ��壬����ȫ�ֱ������ڸ����ӳ����е��á�
 function [Imagedb Keypoint Descriptors] = SIFT_csh(Input1)
 %keypointÿ��Ϊ���ڵ�1�顢2�㡢3�С�4�С��Լ���5�㡢6�С�7�У���΢Сƫ�8������Ƕ�
 % Descriptorsÿ��ΪKeypoint��ĳһ�ж�Ӧ��d*d*nά��������������

% Input1 = imread('lena.png');
% Input1 = imread('book1gray.png');
% Input1 = imread('matrix.png');  %Ϊ�м���һƬ��ɫ������������

%%
if ndims(Input1)==3
    Imagegray = rgb2gray(Input1); %����ɫͼ��ת��Ϊ�Ҷ�ͼ�� 
else
     Imagegray = Input1;
end
% global camera_sigma sigma0;
% global enlarge
% global Octave Layers;
% global sigma;
Imagedb = Define(Imagegray);  %ȫ�����ݹ��������ػҶ�ͼ�ĸ���������Imagedb��0-1֮�䣩
gausspyr = buildgausspyr(Imagedb);
Dogpyr = buildDogpyr(gausspyr);
Keypoint = findExtrma(gausspyr,Dogpyr);
Descriptors = [];
for i=1:1:size(Keypoint,1)
    kpt = Keypoint(i,:);
    descriptors = calcDescriptors(gausspyr,kpt);
    Descriptors = [Descriptors;descriptors];
end

