%% 
% ���sigma���У�ע�����sigma���ж�����Ա���ĳ߶ȣ��߶�һ��Ҫ�и��ο�ͼ��ߴ�
% ��߶�sigma��ͼ��ߴ�����ȹ�ϵ
% �ó��򷵻صĵ�1���Ǳ���߶�����һ��߶ȵ�ƽ�������
%  �ó��򷵻صĵ�2���Ǳ����ڵ�ʵ�ʳ߶�
%%
 function sigma =sigma_num()
  global sigma camera_sigma;
  global Layers sigma0  enlarge;
  if (logical(enlarge))
      sigma(1,1) = sqrt(sigma0*sigma0 - 4*camera_sigma*camera_sigma);
      sigma(2,1) = sigma0;
  else
      sigma(1,1) = sqrt(sigma0*sigma0 - camera_sigma*camera_sigma);
      sigma(2,1) = sigma0;
  end
  s=Layers;
  for i=2:1:s+3
      sigma_pre = sigma0*power(2,1/s*(i-2));
      sigma_at = sigma0*power(2,1/s*(i-1));
      sigma(1,i) = sqrt(sigma_at*sigma_at - sigma_pre*sigma_pre);
      sigma_2 = sigma(1,2:i).*sigma(1,2:i);
      sigma(2,i) = sqrt(sum(sigma_2(:))+sigma0*sigma0);
%       sigma(2,i) = sigma_at ; %�������Ч
  end
      
