%% 获得坐标归1化仿射变换 并得到正确率
%  从而检验SIFT变换的效果
%  x =  a00x+a01y+b00
%  y =  a10x+a11y+b10
%  trsArray 为矩阵[a00 a01 b00;a10 a11 b10]; SIFT_pos1经过trsArray仿射至SIFT_pos2
 function [trsArray piancha] = affinity1(SIFT_pos1,SIFT_pos2)
 trsArray = zeros(2,3); 
 A1(:,1) =  SIFT_pos1(:,1)./SIFT_pos2(:,1); 
 A1(:,2) =  SIFT_pos1(:,2)./SIFT_pos2(:,1);
 A1(:,3) = ones(size(SIFT_pos1,1),1)./SIFT_pos2(:,1);
 
 A2(:,1) =  SIFT_pos1(:,1)./SIFT_pos2(:,2); 
 A2(:,2) =  SIFT_pos1(:,2)./SIFT_pos2(:,2);
 A2(:,3) = ones(size(SIFT_pos1,1),1)./SIFT_pos2(:,2);

 
 a0 = pinv(A1)*ones(size(SIFT_pos1,1),1);
 a1 = pinv(A2)*ones(size(SIFT_pos1,1),1);
 trsArray = [a0';a1'];
 
 piancha(:,1)=ones(size(SIFT_pos1,1),1)-A1*a0;
 piancha(:,2)=ones(size(SIFT_pos1,1),1)-A2*a1;
 piancha(:,3)=sqrt(piancha(:,1).*piancha(:,1)+piancha(:,2).*piancha(:,2));
 [Val piancha(:,4)] = sort(piancha(:,3));
 
 
 
 
 