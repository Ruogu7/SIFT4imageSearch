function [flagbool kpt] = adjustExtrPoint(Dogpyr,gausspyr,oct,lay1,r1,c1)
global Layers;
global edgegama; %是否是物体边缘判断的gamma系数
global SIFT_STEP; %迭代步数
global IterationMax; %相差一个较大值
global ExtrThreshold; %极值点稳定判断
global SIFT_Img_Border; %图片边界去掉SIFT_Img_Border-1个像素点

flagbool = 0;
kpt = [];
lay = lay1;r = r1;c = c1;  %这三个位置信息是会适当调整的 但是oct是不会调整的

for step = 1:1:SIFT_STEP  %循环次数
    cub_pre = Dogpyr{oct}(r-1:r+1,c-1:c+1,lay-1);
    cub_at = Dogpyr{oct}(r-1:r+1,c-1:c+1,lay);
    cub_next = Dogpyr{oct}(r-1:r+1,c-1:c+1,lay+1);
    dx = 1/2 * ( cub_at(2,3)-cub_at(2,1) );
    dy = 1/2 * ( cub_at(3,2)-cub_at(1,2) );
    ds = 1/2 * ( cub_next(2,2)-cub_pre(2,2) );
    Dx = [dx;dy;ds];
    atv2 = cub_at(2,2)*2;
    dxx = (cub_at(2,3)+cub_at(2,1)-atv2);
    dyy = (cub_at(3,2)+cub_at(1,2)-atv2);
    dss = (cub_next(2,2)+cub_pre(2,2)-atv2);
    dxy = (cub_at(3,3)+cub_at(1,1)-cub_at(3,1)-cub_at(1,3))/4;
    dxs = (cub_next(2,3)-cub_next(2,1)-cub_pre(2,3)+cub_pre(2,1))/4;
    dys = (cub_next(3,2)-cub_next(1,2)-cub_pre(3,2)+cub_pre(1,2))/4;
    H = [dxx dxy dxs; ...
        dxy dyy dys; ...
        dxs dys dss];
    Det = -inv(H)*Dx;
    dr = Det(1); dc = Det(2); di = Det(3);
    if abs(dr)<0.5 && abs(dc)<0.5 && abs(di)<0.5
        flagbool = 1;
        break;
    end
    if abs(dr)>IterationMax || abs(dc)>IterationMax || abs(di)>IterationMax
        flagbool = 0;
        break;
    end
    lay = round(lay+di); r = round(r+dr); c = round(c+dc);
    %同一组内的图片像素数量相同，所以取第1层。不能用lay层（程序运行过程中round(lay+di)可能非合理区）
    [rows cols] = size(Dogpyr{oct}(:,:,1));  
    % 极值点最多只能在Dog塔中的第2至s+1层寻找（上下都要有比较层）
    if lay<2 || lay >Layers+1 || ...
            r<SIFT_Img_Border || r>rows-SIFT_Img_Border+1 || ...
            c<SIFT_Img_Border || c>cols-SIFT_Img_Border+1
        flagbool = 0;
        break;
    end
end
%结束for循环，如果找到了极值点flagbool == 1


%%
%也只有迭代步数小于预设值且abs(dr)<0.5 && abs(dc)<0.5 && abs(di)<0.5时
%才会进入下面的if条件，因此下面的代码可以放到上面的“flagbool = 1;”语句前
if flagbool == 1
    fx = Dogpyr{oct}(r,c,lay)+1/2*Dx'*Det;
    laymax = max(max(Dogpyr{oct}(:,:,lay)));
    laymin = min(min(Dogpyr{oct}(:,:,lay)));
    stable = ExtrThreshold*max( abs(laymax),abs(laymin) );
    if abs(fx) < stable
        flagbool = 0;
    end
    % 计算Hessian矩阵，与OpenCV中不同的是通过gausspyr求Hessian矩阵
    % 我认为边界应该对图像本身来说，同时Dog本来就是差分再继续差分，即高阶差分其失真是非常大的
    % 具体操作中,Dog极值点对应高斯塔的被减层(因为Dog是Log的被减层的拉普拉斯差分的近似)。
    % 并且为了防止偏差，将极值点周围九个点都判断是不是落在边界上
    for rh = r-1:1:r+1
        for ch = c-1:1:c+1
%     for rh = r
%         for ch = c
            Hcub = gausspyr{oct}(rh-1:rh+1,ch-1:ch+1,lay);
            Hxx = Hcub(2,3)+Hcub(2,1)-2*Hcub(2,2);
            Hyy = Hcub(3,2)+Hcub(1,2)-2*Hcub(2,2);
            Hxy = (Hcub(3,3)+Hcub(1,1)-Hcub(1,3)-Hcub(3,1))/4;
            tr = Hxx+Hyy;
            Hdet = Hxx*Hyy-Hxy*Hxy;
            if Hdet <=0 || tr*tr/Hdet >= (edgegama+1)*(edgegama+1)/edgegama
                flagbool = 0;
            end
        end
    end
end
%%  极值点迭代精确定位稳定，且不属于边界等条件满足时
if  flagbool == 1
    kpt = [oct lay r c di dr dc];  %所在的组、层、行、列、以及（层、行、列）的微小偏差
end













