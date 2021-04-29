%% Ѱ�Ҽ�ֵ��
%
% adjustExtrPoint(Dogpyr,) ������ֵ��λ�ã�ȷ����ȷ��
% oritHist ����������ͳ��ͼ
%%
function keypoint = findExtrma(gausspyr,Dogpyr)
keypoint = [];
global Octave Layers;
global SIFT_Img_Border;
global ExtrThreshold;
global SIFT_ORI_PEAK_RATIO; %���������Ϊ���ֵ���������ֵ
global SIFT_ORI_HIST_BINS;  %����������������
n = SIFT_ORI_HIST_BINS;
global boolParabolicFit; %��������ͨ����������Ϸ�����������ƫ�Ʒ���
for oct = 1:1:Octave
    for lay = 2:1:Layers+1
        [rows cols] = size(Dogpyr{oct}(:,:,lay));
        laymax = max(max(Dogpyr{oct}(:,:,lay)));
        laymin = min(min(Dogpyr{oct}(:,:,lay)));
        Extr_lay = 1/2*ExtrThreshold*max( abs(laymax),abs(laymin) );
        % �߽��ȥ��SIFT_Img_Border-1��Ԫ��
        for r = SIFT_Img_Border:1:rows-SIFT_Img_Border+1
            for c = SIFT_Img_Border:1:cols-SIFT_Img_Border+1
                cub1 = Dogpyr{oct}(r-1:r+1,c-1:c+1,lay-1);
                cub2 = Dogpyr{oct}(r-1:r+1,c-1:c+1,lay);
                cub3 = Dogpyr{oct}(r-1:r+1,c-1:c+1,lay+1);
                cub = [cub1(:) ; cub2(:) ;cub3(:)];  %��r,c�����������干27��Ԫ��
                % ��ȥ�������ȶ��ļ�ֵ��
                if abs(Dogpyr{oct}(r,c,lay)) > Extr_lay && ...
                        ( Dogpyr{oct}(r,c,lay) == max(cub) || Dogpyr{oct}(r,c,lay) == min(cub) )
                    r1 = r; c1 =c; lay1 = lay;
                    %kpt���ڵ��顢�㡢�С��С��Լ����㡢�С��У���΢Сƫ��
                    [flagbool kpt] = adjustExtrPoint(Dogpyr,gausspyr,oct,lay1,r1,c1);
                    if flagbool == 1  %��ֵ��λ�ý�һ���ж����������Լ���ȷ��λ
                         [maxval hist] = oritHist(gausspyr,kpt);
                         for j = 1:1:n
                             j_pre = j-1;
                             j_pre(j_pre<1) = n;
                             j_next = j+1;
                             j_next(j_next>n) = 1;
                             if hist(j)>hist(j_pre) && hist(j)>hist(j_next) &&  hist(j)>=SIFT_ORI_PEAK_RATIO*maxval
                                 % ��������Ϸ���
                                 if boolParabolicFit
                                     bin = j+0.5*(hist(j_pre)-hist(j_next))/(hist(j_pre)+hist(j_next)-2*hist(j));
                                 else
                                     % �Ҹ�����Ϊֱ�۵Ľ��ͻ����������������
                                     bin = j+(hist(j_next)-hist(j_pre))/(hist(j_pre)+hist(j)+hist(j_next));
                                 end
                                 angle = (bin-1)*360/n;
                                  %keypointΪ���ڵ�1�顢2�㡢3�С�4�С��Լ���5�㡢6�С�7�У���΢Сƫ�8������Ƕ�
                                  keypoint = [keypoint;kpt angle];
                             end
                         end
                    end
                end
            end
        end
    end
end
           
        