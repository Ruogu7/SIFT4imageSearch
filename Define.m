
%% ȫ�ֱ����Ķ���
%  ��Ҫ��ȫ�ֱ����Ķ��壬����ȫ�ֱ������ڸ����ӳ����е��á�
%  sigma_num()���õ������ڣ���֮��ĳ߶ȹ�ϵ�Լ�������ʵ�ʳ߶�
 function Imagedb = Define(Imagegray)
ifelse=@(a,b,c)(a~=0)*b+(a==0)*c;  %������Ŀ�����

global enlarge
enlarge = 1; %�Ƿ�Ŵ�ԭʼͼƬ,����0�򲻷Ŵ�
if ( logical(enlarge) )
     Imagedb = im2double(imresize(Imagegray,2,'bilinear'));  %ͼƬ�Ŵ�2��
else
    Imagedb = im2double(Imagegray);
end

global camera_sigma sigma0;
camera_sigma = 0.5;  %ԭʼ����ͼƬ����߶�Ϊcamera_sigma;
sigma0 = 1.6;        % ��˹������һ������һ��ĳ߶�

global Octave Layers;
Layers = 3; % ��˹��ΪLayers+3�㣬DogΪLayers+2��
Octave = -1; % �����˹��������Ŀ����ֵ>0��ͨ���Զ���ȡ��������ͼƬ�ߴ�ȷ��
% ���´���Ϊ�����ļ��㣬���Զ��廹�Ǹ���ͼ�����޷Ŵ�ԭͼ�񣩳ߴ�ȷ���������

Octave = ifelse(Octave >0,Octave,ifelse(logical(enlarge), ...
    log(min(size(Imagegray)))/log(2)-1,log(min(size(Imagegray)))/log(2)-2));
Octave = round(Octave);

global sigma;
sigma = zeros(2,Layers+3);
sigma = sigma_num(); %��1�з��ر���߶�����һ��߶ȵ�ƽ������ţ���2�з����ڱ����е�ʵ�ʳ߶�

global SIFT_Img_Border;
SIFT_Img_Border = 6; %��Dog��������ȥ�����ܵ���������SIFT_Img_Borde-1

global ExtrThreshold;
% �ڼ�ֵ�㾫ȷ��λǰΪ1/2*ExtrThreshold����ȷ��λ��ֵΪExtrThreshold��
ExtrThreshold = 0.03;%lowe ����ֵ0.03���������ֵ�ǹ�һ��0-1�м��

global edgegama; %hessian�����������ж��Ƿ����ڱ߽�����ֵ
edgegama = 10;

global SIFT_STEP;
SIFT_STEP = 5;
global IterationMax; %��ֵ�㾫ȷ���ҹ�����ƫ��������ֵ������Ϊ��ֵ�㲻�ȶ�
IterationMax = 3;

global SIFT_ORI_HIST_BINS; %����������������
SIFT_ORI_HIST_BINS = 36;

global SIFT_ORI_SIG_FCTR; % ������뾶ΪSIFT_ORI_RADIUS*SIFT_ORI_SIG_FCTR*�������ڳ߶ȣ�������ƫ��С����
SIFT_ORI_SIG_FCTR = 1.5;
global SIFT_ORI_RADIUS;
SIFT_ORI_RADIUS  = 3;

global SIFT_ORI_PEAK_RATIO; %���������Ϊ���ֵ���������ֵ
SIFT_ORI_PEAK_RATIO = 0.8;

global boolParabolicFit;
boolParabolicFit = 0; %��������ͨ����������Ϸ�����������ƫ�Ʒ���

global SIFT_DESCR_WIDTH;
SIFT_DESCR_WIDTH = 4; %������������ ��ΪSIFT_DESCR_WIDTH *SIFT_DESCR_WIDTH ��������
global SIFT_DESCR_HIST_BINS; %������������ �������ڷ�����������SIFT_DESCR_HIST_BINS
SIFT_DESCR_HIST_BINS = 8;  %128ά = SIFT_DESCR_WIDTH * SIFT_DESCR_WIDTH * SIFT_DESCR_HIST_BINS
global SIFT_DESCR_SCL_FCTR;
SIFT_DESCR_SCL_FCTR = 3; %��������ΧSIFT_DESCR_SCL_FCTR*��d+1����Χ����ע������Ҫ����1.414��
global SIFT_DESCR_MAG_THR;
SIFT_DESCR_MAG_THR = 0.2; % �������������У����ڸ���ֵ�ĵ㱻��Ϊ�̶�ֵ


