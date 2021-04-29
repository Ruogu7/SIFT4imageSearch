%% 获得仿射变换 并得到正确率
%  从而检验SIFT变换的效果
%  x =  a00x+a01y+b00
%  y =  a10x+a11y+b10
%  trsArray 为矩阵[a00 a01 b00;a10 a11 b10]; SIFT_pos1经过trsArray仿射至SIFT_pos2
 function [trsArray indx piancha] = affinity(SIFT_pos1,SIFT_pos2)
 trsArray = zeros(2,3); 
 A1 =  SIFT_pos1; % 点横坐标x以及纵坐标y
 A1(:,3) = 1;
 
 A2 =  SIFT_pos2;
 A2(:,3) = 1;
 
 a0 = pinv(A1)*SIFT_pos2(:,1);  % 求得x的仿射变换
 a1 = pinv(A1)*SIFT_pos2(:,2);  % 求得y的仿射变换
 piancha(:,1)=A2(:,1)-A1*a0;
 piancha(:,2)=A2(:,2)-A1*a1;
 piancha(:,3)=sqrt(piancha(:,1).*piancha(:,1)+piancha(:,2).*piancha(:,2));
 [Val indx] = sort(piancha(:,3));
 
 % 将匹配的最好的一半数据再次求仿射变换(防止过大的偏差影响仿射变换)
 pos1 = []; pos2 = [];
 for i =1:1:round(size(SIFT_pos1,1)/2)
     pos1 = [pos1;SIFT_pos1(indx(i),:)];
     pos2 = [pos2;SIFT_pos2(indx(i),:)];
 end
 pos1(:,3) = 1;pos2(:,3) = 1;
 a0 = pinv(pos1)*pos2(:,1);  % 求得x的仿射变换
 a1 = pinv(pos1)*pos2(:,2);  % 求得y的仿射变换
 trsArray = [a0';a1'];
 piancha(:,1)=A2(:,1)-A1*a0;
 piancha(:,2)=A2(:,2)-A1*a1;
 piancha(:,3)=sqrt(piancha(:,1).*piancha(:,1)+piancha(:,2).*piancha(:,2));
 [Val indx ] = sort(piancha(:,3),'descend');
 
 
 
 
 