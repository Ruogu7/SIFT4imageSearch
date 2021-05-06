clc;  clear;
tic;
% Input1 = imread('DIPbook1.png');
% Input2 = imread('DIPbook2.png');

Input1 = imread('7.jpg');
Input1 = imresize(Input1, 0.25);
size(Input1)
Input2 = imread('air.jpg');
Input2 = imresize(Input2, 0.75);
size(Input2)

% Input1 = imread('matrix.png');
% Input2 = imread('matrix.png');

[Imagedb1 Kpt1 Dsp1] = SIFT_yhb(Input1);
fprintf('Found %d SIFT points.\n', size(Kpt1,1));

[Imagedb2 Kpt2 Dsp2] = SIFT_yhb(Input2);
fprintf('Found %d SIFT points.\n', size(Kpt2,1));
% Keypoint数据每行为所在的1组、2层、3行、4列、以及（5层、6行、7列）的微小偏差、8主方向角度

toc

distRatio = 0.6;
% Kpt1 * Kpt2';
k = 0;
for i = 1:1:size(Dsp1,1)
    angle = acosd(Dsp1(i,:)*Dsp2');
    [angle indx] = sort(angle);
    if angle(1)<distRatio * angle(2)
        k=k+1;
        match(k,1:2) = [i indx(1)];
    end
end
len =k;
fprintf('Found %d matches.\n', len);
twoPic = appendimages(Imagedb1,Imagedb2);
imshow(twoPic);
hold on;
cols1 = size(Imagedb1,2);
SIFT_pos1 = [];
SIFT_pos2 = [];
for i=1:1:len
    zb1 = [ Kpt1(match(i,1),3) + Kpt1(match(i,1),6) Kpt1(match(i,1),4)+Kpt1(match(i,1),7) ];
    zb2 = [ Kpt2(match(i,2),3) + Kpt2(match(i,2),6) Kpt2(match(i,2),4)+Kpt2(match(i,2),7) ];
    zb1_img = round(zb1*2^(Kpt1(match(i,1),1)-1));
    zb2_img = round(zb2*2^(Kpt2(match(i,2),1)-1));
    % line([起点横坐标，终点横坐标],[起点纵坐标，终点纵坐标])，
    line([zb1_img(2) zb2_img(2) + cols1], [zb1_img(1) zb2_img(1)],'linestyle',':', 'Color', 'c');
    
    text(zb1_img(2),zb1_img(1),num2str(i),'color','red');  
    text(zb2_img(2)+cols1,zb2_img(1),num2str(i),'color','red');
    SIFT_pos1 = [SIFT_pos1;zb1_img(2) zb1_img(1)];  % 点横坐标x以及纵坐标y
    SIFT_pos2 = [SIFT_pos2;zb2_img(2) zb2_img(1)];  % 点横坐标x以及纵坐标y
end
[trsArray indx piancha] = affinity(SIFT_pos1,SIFT_pos2);