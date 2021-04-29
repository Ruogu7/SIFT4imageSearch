%% 
% 获得sigma序列，注意这个sigma序列都是针对本组的尺度，尺度一定要有个参考图像尺寸
% 其尺度sigma与图像尺寸成正比关系
% 该程序返回的第1行是本层尺度与上一层尺度的平方差开根号
%  该程序返回的第2行是本组内的实际尺度
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
%       sigma(2,i) = sigma_at ; %这两句等效
  end
      
