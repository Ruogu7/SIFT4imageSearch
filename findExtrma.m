%% 寻找极值点
%
% adjustExtrPoint(Dogpyr,) 调整极值点位置，确定精确点
% oritHist 返回主方向统计图
%%
function keypoint = findExtrma(gausspyr,Dogpyr)
keypoint = [];
global Octave Layers;
global SIFT_Img_Border;
global ExtrThreshold;
global SIFT_ORI_PEAK_RATIO; %多个主方向，为最大值主方向的阈值
global SIFT_ORI_HIST_BINS;  %定义主方向柱数量
n = SIFT_ORI_HIST_BINS;
global boolParabolicFit; %主方向柱通过抛物线拟合方法或者中心偏移方法
for oct = 1:1:Octave
    for lay = 2:1:Layers+1
        [rows cols] = size(Dogpyr{oct}(:,:,lay));
        laymax = max(max(Dogpyr{oct}(:,:,lay)));
        laymin = min(min(Dogpyr{oct}(:,:,lay)));
        Extr_lay = 1/2*ExtrThreshold*max( abs(laymax),abs(laymin) );
        % 边界各去掉SIFT_Img_Border-1个元素
        for r = SIFT_Img_Border:1:rows-SIFT_Img_Border+1
            for c = SIFT_Img_Border:1:cols-SIFT_Img_Border+1
                cub1 = Dogpyr{oct}(r-1:r+1,c-1:c+1,lay-1);
                cub2 = Dogpyr{oct}(r-1:r+1,c-1:c+1,lay);
                cub3 = Dogpyr{oct}(r-1:r+1,c-1:c+1,lay+1);
                cub = [cub1(:) ; cub2(:) ;cub3(:)];  %在r,c附近的立方体共27个元素
                % 先去掉本身不稳定的极值点
                if abs(Dogpyr{oct}(r,c,lay)) > Extr_lay && ...
                        ( Dogpyr{oct}(r,c,lay) == max(cub) || Dogpyr{oct}(r,c,lay) == min(cub) )
                    r1 = r; c1 =c; lay1 = lay;
                    %kpt所在的组、层、行、列、以及（层、行、列）的微小偏差
                    [flagbool kpt] = adjustExtrPoint(Dogpyr,gausspyr,oct,lay1,r1,c1);
                    if flagbool == 1  %极值点位置进一步判断条件成立以及精确定位
                         [maxval hist] = oritHist(gausspyr,kpt);
                         for j = 1:1:n
                             j_pre = j-1;
                             j_pre(j_pre<1) = n;
                             j_next = j+1;
                             j_next(j_next>n) = 1;
                             if hist(j)>hist(j_pre) && hist(j)>hist(j_next) &&  hist(j)>=SIFT_ORI_PEAK_RATIO*maxval
                                 % 抛物线拟合方程
                                 if boolParabolicFit
                                     bin = j+0.5*(hist(j_pre)-hist(j_next))/(hist(j_pre)+hist(j_next)-2*hist(j));
                                 else
                                     % 我个人认为直观的解释或许下面这个更合适
                                     bin = j+(hist(j_next)-hist(j_pre))/(hist(j_pre)+hist(j)+hist(j_next));
                                 end
                                 angle = (bin-1)*360/n;
                                  %keypoint为所在的1组、2层、3行、4列、以及（5层、6行、7列）的微小偏差、8主方向角度
                                  keypoint = [keypoint;kpt angle];
                             end
                         end
                    end
                end
            end
        end
    end
end
           
        