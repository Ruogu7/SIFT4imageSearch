%% ��÷���任 ���õ���ȷ��
%  �Ӷ�����SIFT�任��Ч��
%  x =  a00x+a01y+b00
%  y =  a10x+a11y+b10
%  trsArray Ϊ����[a00 a01 b00;a10 a11 b10]; SIFT_pos1����trsArray������SIFT_pos2
 function [trsArray indx piancha] = affinity(SIFT_pos1,SIFT_pos2)
 trsArray = zeros(2,3); 
 A1 =  SIFT_pos1; % �������x�Լ�������y
 A1(:,3) = 1;
 
 A2 =  SIFT_pos2;
 A2(:,3) = 1;
 
 a0 = pinv(A1)*SIFT_pos2(:,1);  % ���x�ķ���任
 a1 = pinv(A1)*SIFT_pos2(:,2);  % ���y�ķ���任
 piancha(:,1)=A2(:,1)-A1*a0;
 piancha(:,2)=A2(:,2)-A1*a1;
 piancha(:,3)=sqrt(piancha(:,1).*piancha(:,1)+piancha(:,2).*piancha(:,2));
 [Val indx] = sort(piancha(:,3));
 
 % ��ƥ�����õ�һ�������ٴ������任(��ֹ�����ƫ��Ӱ�����任)
 pos1 = []; pos2 = [];
 for i =1:1:round(size(SIFT_pos1,1)/2)
     pos1 = [pos1;SIFT_pos1(indx(i),:)];
     pos2 = [pos2;SIFT_pos2(indx(i),:)];
 end
 pos1(:,3) = 1;pos2(:,3) = 1;
 a0 = pinv(pos1)*pos2(:,1);  % ���x�ķ���任
 a1 = pinv(pos1)*pos2(:,2);  % ���y�ķ���任
 trsArray = [a0';a1'];
 piancha(:,1)=A2(:,1)-A1*a0;
 piancha(:,2)=A2(:,2)-A1*a1;
 piancha(:,3)=sqrt(piancha(:,1).*piancha(:,1)+piancha(:,2).*piancha(:,2));
 [Val indx ] = sort(piancha(:,3),'descend');
 
 
 
 
 